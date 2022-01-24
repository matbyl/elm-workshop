module Main exposing (main)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Navigation
import Html exposing (Html, a, button, div, text)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Json.Decode as JD
import Json.Encode as JE
import Page.Pokedex as Pokedex
import Route exposing (Route(..))
import Session exposing (CatApiKey, Session)
import Url exposing (Url)
import Page
import Page.Blank
import Page.Home


main : Program JE.Value Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = onUrlChange
        , onUrlRequest = onUrlRequest
        }


onUrlChange : Url.Url -> Msg
onUrlChange =
    UrlChange


onUrlRequest : UrlRequest -> Msg
onUrlRequest =
    UrlRequest


type Msg
    = Ignored
    | UrlChange Url
    | UrlRequest Browser.UrlRequest
    | GotRootMsg
    | GotPokedexMsg Pokedex.Msg


type Model
    = Error Session
    | Redirect Session
    | Pokedex Pokedex.Model


init : JE.Value -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        decoder =
            JD.map (Session navKey << Session.CatApiKey) (JD.field "catApiKey" JD.string)

        defaultSession = { navKey = navKey, catApiKey = Session.CatApiKey ""}
    in
    case JD.decodeValue decoder flags of
        Ok session ->
            Route.fromUrl url
                |> Maybe.map (changeRouteTo (Redirect session))
                |> Maybe.withDefault ( Error defaultSession, Cmd.none )

        Err err ->
            let
                _ = Debug.log "Error: " err
            in
            (Error defaultSession, Cmd.none)


toSession : Model -> Session
toSession m = case m of
                Error session ->
                    session
                Redirect session ->
                    session
                Pokedex { session } ->
                    session

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
        let
            session = toSession model
        in
        case (msg, model) of
                (Ignored, _) ->
                    ( model, Cmd.none )
                (UrlChange url, _) ->
                    Route.fromUrl url
                        |> Maybe.map (changeRouteTo model)
                        |> Maybe.withDefault ( model, Cmd.none )

                (UrlRequest urlRequest, _) ->
                    case urlRequest of
                        Browser.Internal url ->
                            url.fragment
                                |> Maybe.map (always ( model, Navigation.pushUrl session.navKey (Url.toString url) ))
                                |> Maybe.withDefault ( model, Cmd.none )

                        Browser.External href ->
                            ( model, Navigation.load href )

                (GotRootMsg, _) ->
                    ( model, Cmd.none ) |> updateWith (always GotRootMsg) (always model)

                (GotPokedexMsg pokedexMsg, Pokedex pokedexModel) ->
                    Pokedex.update pokedexMsg pokedexModel |> updateWith GotPokedexMsg Pokedex
                _ ->
                    -- Disregard messages that arrived for the wrong page.
                    ( model, Cmd.none )



updateWith : (subMsg -> Msg) -> (subModel -> Model) -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toMsg toModel ( subModel, subCmd ) =
    ( toModel subModel, Cmd.map toMsg subCmd )


updateWhenJust : Maybe a -> (a -> ( model, Cmd msg )) -> model -> ( model, Cmd msg )
updateWhenJust x f model =
    Maybe.map f x |> Maybe.withDefault ( model, Cmd.none )


changeRouteTo : Model -> Route -> ( Model, Cmd Msg )
changeRouteTo model route =
    let
        session = toSession model
    in
    case route of
        Route.Root ->
            ( model, Cmd.none )

        Route.Pokedex ->
            Pokedex.init session |> updateWith GotPokedexMsg Pokedex


view : Model -> Document Msg
view model =
    let
        viewPage page toMsg config =
            let
                { title, body } =
                    Page.view page config
            in
            { title = title
            , body = List.map (Html.map toMsg) body
            }
    in
    case model of
        Error _ ->
            viewPage Page.Blank (always Ignored) Page.Blank.view
        Redirect _ ->
            viewPage Page.Blank (always Ignored) Page.Home.view
        Pokedex pokedexModel ->
            viewPage Page.Pokedex GotPokedexMsg (Pokedex.view pokedexModel)
    


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
