module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Json.Encode as JE
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
    = Increment
    | Decrement
    | OnUrlChange Url.Url
    | OnUrlRequest Browser.UrlRequest


type alias Model =
    Int


init : JE.Value -> Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ _ _ =
    ( 0, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( model + 1, Cmd.none )

        Decrement ->
            ( model - 1, Cmd.none )

        OnUrlChange _ ->
            ( model, Cmd.none )

        OnUrlRequest _ ->
            ( model, Cmd.none )


view : Model -> Document Msg
view model =
    { title = "My applications"
    , body =
        [ div []
            [ button [ onClick Decrement ] [ text "-" ]
            , text <| "Clicked " ++ String.fromInt model
            , button [ onClick Increment ] [ text "+" ]
            ]
        ]
    }
