module Main exposing (main)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Navigation
import Html exposing (Html, a, button, div, text)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Json.Decode as JD
import Json.Encode as JE
import Page
import Page.Blank
import Page.Home
import Page.Pokedex as Pokedex
import Route exposing (Route(..))
import Session exposing (CatApiKey, Session)
import Url exposing (Url)


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


type alias Model =
    { pageModel : PageModel
    , activeRoute : Route
    }


type PageModel
    = Error Session
    | Home Session
    | Pokedex Pokedex.Model


init : JE.Value -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        decoder =
            JD.map (Session navKey << Session.CatApiKey) (JD.field "catApiKey" JD.string)

        defaultSession =
            { navKey = navKey, catApiKey = Session.CatApiKey "" }
    in
    case JD.decodeValue decoder flags of
        Ok session ->
            Route.fromUrl url
                |> Maybe.map (changeRouteTo { activeRoute = Route.Home, pageModel = Home session })
                |> Maybe.withDefault ( { activeRoute = Route.Error, pageModel = Error defaultSession }, Cmd.none )

        Err err ->
            let
                _ =
                    Debug.log "Error: " err
            in
            ( { activeRoute = Route.Error, pageModel = Error defaultSession }, Cmd.none )


toSession : Model -> Session
toSession { pageModel } =
    case pageModel of
        Error session ->
            session

        Home session ->
            session

        Pokedex { session } ->
            session


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        session =
            toSession model

        updateWith =
            updateWithRoute model.activeRoute
    in
    case ( msg, model.pageModel ) of
        ( Ignored, _ ) ->
            ( model, Cmd.none )

        ( UrlChange url, _ ) ->
            Route.fromUrl url
                |> Maybe.map (changeRouteTo model)
                |> Maybe.withDefault ( model, Cmd.none )

        ( UrlRequest urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    url.fragment
                        |> Maybe.map (always ( model, Navigation.pushUrl session.navKey (Url.toString url) ))
                        |> Maybe.withDefault ( model, Cmd.none )

                Browser.External href ->
                    ( model, Navigation.load href )

        ( GotRootMsg, _ ) ->
            ( model, Cmd.none ) |> updateWith (always GotRootMsg) (always (Home session))

        ( GotPokedexMsg pokedexMsg, Pokedex pokedexModel ) ->
            Pokedex.update pokedexMsg pokedexModel |> updateWith GotPokedexMsg Pokedex

        _ ->
            -- Disregard messages that arrived for the wrong page.
            ( model, Cmd.none )


updateWithRoute : Route -> (subMsg -> Msg) -> (subModel -> PageModel) -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWithRoute activeRoute toMsg toPageModel ( subModel, subCmd ) =
    ( { activeRoute = activeRoute, pageModel = toPageModel subModel }, Cmd.map toMsg subCmd )


changeRouteTo : Model -> Route -> ( Model, Cmd Msg )
changeRouteTo model route =
    let
        session =
            toSession model

        updateWith =
            updateWithRoute route
    in
    case route of
        Route.Home ->
            ( model, Cmd.none ) |> updateWith (always GotRootMsg) (always (Home session))

        Route.Error ->
            ( model, Cmd.none ) |> updateWith (always Ignored) (always (Error session))

        Route.Pokedex ->
            Pokedex.init session |> updateWith GotPokedexMsg Pokedex


view : Model -> Document Msg
view model =
    let
        viewPage toMsg config =
            let
                { title, body } =
                    Page.view model.activeRoute config
            in
            { title = title
            , body = List.map (Html.map toMsg) body
            }
    in
    case model.pageModel of
        Error _ ->
            viewPage (always Ignored) Page.Blank.view

        Home _ ->
            viewPage (always Ignored) Page.Home.view

        Pokedex pokedex ->
            viewPage GotPokedexMsg (Pokedex.view pokedex)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
