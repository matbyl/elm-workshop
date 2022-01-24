module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation
import Html exposing (Html, a, button, div, text)
import Html.Attributes exposing (default, href)
import Html.Events exposing (onClick)
import Json.Encode as JE
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
    = GotHomeMsg HomeMsg
    | OnUrlChange Url.Url
    | OnUrlRequest Browser.UrlRequest


type HomeMsg
    = Increment
    | Decrement


type Model
    = Home { session : Session, counter : Int }
    | MyNewPage { session : Session }


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

        MyNewPage { session } ->
            session


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        session =
            toSession model
    in
    case ( model, msg ) of
        ( Home homeModel, GotHomeMsg subMsg ) ->
            case subMsg of
                Increment ->
                    ( Home { homeModel | counter = homeModel.counter + 1 }, Cmd.none )

                Decrement ->
                    ( Home { homeModel | counter = homeModel.counter - 1 }, Cmd.none )

        ( _, OnUrlChange url ) ->
            case Route.fromUrl url of
                Just Route.Home ->
                    ( defaultModel session.navKey, Cmd.none )

                Just Route.MyNewPage ->
                    ( MyNewPage { session = session }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        ( _, OnUrlRequest urlRequest ) ->
            case urlRequest of
                Browser.Internal url ->
                    url.fragment
                        |> Maybe.map (always ( model, Browser.Navigation.pushUrl session.navKey <| Url.toString url ))
                        |> Maybe.withDefault ( model, Cmd.none )

                Browser.External url ->
                    ( model, Browser.Navigation.load url )

        ( _, _ ) ->
            ( model, Cmd.none )


view : Model -> Document Msg
view model =
    { title = "My applications"
    , body =
        [ case model of
            Home homeModel ->
                div []
                    [ button [ onClick <| GotHomeMsg Decrement ] [ text "-" ]
                    , text <| "Clicked " ++ String.fromInt homeModel.counter
                    , button [ onClick <| GotHomeMsg Increment ] [ text "+" ]
                    , a [ href <| Route.toString Route.MyNewPage ] [ text "Go to my new page" ]
                    ]

            MyNewPage sessino ->
                div [] [ text "my new page" ]
        ]
    }
