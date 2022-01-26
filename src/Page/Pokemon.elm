module Page.Pokemon exposing (..)

import Css
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes exposing (css, src)
import Page exposing (PageView)
import Pokemon exposing (Pokemon(..))
import Pokemon.API
import RemoteData exposing (WebData)
import Session exposing (Session)
import Html.Styled.Events exposing (onClick)


type alias Model =
    { session : Session
    , pokemon : WebData Pokemon
    }


init : Session -> Int -> ( Model, Cmd Msg )
init session pokemonId =
    ( { session = session
      , pokemon = RemoteData.NotAsked
      }
    , Pokemon.API.getPokemon pokemonId GotPokemon
    )


type Msg
    = GotPokemon (WebData Pokemon)
    | GetPokemon Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotPokemon pokemon ->
            ( { model | pokemon = pokemon }, Cmd.none )
        GetPokemon pokemonId ->
            ( model, Pokemon.API.getPokemon pokemonId GotPokemon)


view : Model -> PageView Msg
view model =
    { title = "Pokemon"
    , content =
        Html.section [ css [ Css.textAlign Css.center ] ]
            [ case model.pokemon of
                RemoteData.Loading ->
                    Html.text "Loading pokemon"

                RemoteData.NotAsked ->
                    Html.text "Loading pokemon"

                RemoteData.Success pokemon ->
                    viewPokemon pokemon

                _ ->
                    Html.text "State not handled yet"
            ]
    }


viewPokemon : Pokemon -> Html Msg
viewPokemon (Pokemon pokemon) =
    Html.div []
        [ Html.img [ src pokemon.image, css [ Css.margin Css.auto ] ] []
        , Html.ul [ ]
            [ Html.li []
                [ Html.text <|
                    "Name: "
                        ++ pokemon.name
                ]
            , Html.li []
                [ Html.text <|
                    "Height: "
                        ++ String.fromInt pokemon.height
                ]
            , Html.li []
                [ Html.text <| "Weight: " ++ String.fromInt pokemon.weight
                ]
            ]
        , Html.div [ css [ Css.margin Css.auto ] ] [ Html.button [onClick <| GetPokemon (pokemon.id - 1)] [ Html.text "<"], Html.button [onClick <| GetPokemon (pokemon.id + 1)] [Html.text ">"]]
        ]
