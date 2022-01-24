module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation
import Html exposing (Html, a, button, div, text)
import Html.Attributes exposing (default, href)
import Html.Events exposing (onClick)
import Json.Encode as JE
import Page exposing (Page)
import Page.Pokedex as Pokedex
import Route exposing (Route(..))
import Session exposing (Session)
import Url exposing (Url)


main : Program JE.Value Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        , onUrlChange = OnUrlChange
        , onUrlRequest = OnUrlRequest
        }


type Msg
    = GotHomeMsg
    | GotPokedexMsg Pokedex.Msg
    | OnUrlChange Url.Url
    | OnUrlRequest Browser.UrlRequest


type Model
    = Home { session : Session, counter : Int }
    | Pokedex Pokedex.Model


defaultModel : Browser.Navigation.Key -> Model
defaultModel navKey =
    Home { session = { navKey = navKey }, counter = 0 }


init : JE.Value -> Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ _ navKey =
    ( defaultModel navKey, Cmd.none )


toSession : Model -> Session
toSession model =
    case model of
        Home { session } ->
            session

        Pokedex { session } ->
            session


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        session =
            toSession model
    in
    case ( msg, model ) of
        ( OnUrlChange url, _ ) ->
            case Route.fromUrl url of
                Just Route.Home ->
                    ( defaultModel session.navKey, Cmd.none )

                Just Route.Pokedex ->
                    Pokedex.init session |> updateWith Pokedex GotPokedexMsg

                Nothing ->
                    ( model, Cmd.none )

        ( OnUrlRequest urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    url.fragment
                        |> Maybe.map (always ( model, Browser.Navigation.pushUrl session.navKey <| Url.toString url ))
                        |> Maybe.withDefault ( model, Cmd.none )

                Browser.External url ->
                    ( model, Browser.Navigation.load url )

        ( GotHomeMsg, Home _ ) ->
            ( model, Cmd.none )

        ( GotPokedexMsg subMsg, Pokedex subModel ) ->
            Pokedex.update subMsg subModel |> updateWith Pokedex GotPokedexMsg

        _ ->
            ( model, Cmd.none )


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toCmd ( subModel, subMsg ) =
    ( toModel subModel, Cmd.map toCmd subMsg )


view : Model -> Document Msg
view model =
    case model of
        Home _ ->
            Page.view <|
                { title = "Home"
                , content =
                    div []
                        [ a [ href <| Route.toString Route.Pokedex ] [ text "Go Pokedex" ]
                        ]
                }

        Pokedex pokedexModel ->
            Page.view <| Page.map GotPokedexMsg <| Pokedex.view pokedexModel
