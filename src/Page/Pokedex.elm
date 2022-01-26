module Page.Pokedex exposing (..)

import Css
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes exposing (css, href)
import Page exposing (PageView)
import Pokemon exposing (PokedexItem(..))
import Pokemon.API
import RemoteData exposing (WebData)
import Session exposing (Session)
import Route
import Html.Styled.Events as Events
import Route exposing (Route(..))


type Msg
    = GotPokemons (WebData (Pokemon.API.Page PokedexItem))
    | NavigateToPokemon Int


type alias Model =
    { session : Session, mSearchQuery : Maybe String, pokemons : WebData (Pokemon.API.Page PokedexItem) }


init : Session -> { model | mSearchQuery : Maybe String } -> ( Model, Cmd Msg )
init session { mSearchQuery } =
    ( { session = session, mSearchQuery = mSearchQuery, pokemons = RemoteData.NotAsked }, Pokemon.API.getPokemons GotPokemons )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotPokemons pokemons ->
            ( { model | pokemons = pokemons }, Cmd.none )

        NavigateToPokemon pokemonId ->
            (model, Route.navigateToRoute model.session.navKey <| Route.Pokemon pokemonId)


view : Model -> PageView Msg
view model =
    { title = "Pokedex"
    , content =
        Html.div [] <|
            case model.pokemons of
                RemoteData.Success x ->
                    let
                        searchedPokemons =
                            let
                                indexedPokemons =
                                    List.indexedMap Tuple.pair x.results
                            in
                            model.mSearchQuery
                                |> Maybe.map
                                    (\needle ->
                                        List.filter
                                            (\( _, PokedexItem { name } ) ->
                                                String.contains (String.toLower needle) (String.toLower name)
                                            )
                                            indexedPokemons
                                    )
                                |> Maybe.withDefault indexedPokemons
                    in
                    [ viewPokemons searchedPokemons ]

                _ ->
                    [ Html.text "Loading..." ]
    }


viewPokemons : List ( Int, PokedexItem ) -> Html Msg
viewPokemons =
    let
        viewPokemon ( index, PokedexItem pokemon ) =
            let
                pokemonId = index + 1
            in
            Html.li
                [ Events.onClick <| NavigateToPokemon pokemonId
                , css
                    [ Css.padding2 (Css.px 10) (Css.px 15)
                    , Css.fontSize (Css.rem 1.3)
                    , Css.cursor Css.pointer
                    , Css.margin2 Css.auto (Css.px 0)
                    , Css.hover
                        [ Css.backgroundColor <| Css.rgba 0 0 0 0.32
                        ]
                    ]
                ]
                [ Html.text <| "#" ++ String.fromInt pokemonId ++ " " ++ pokemon.name ]
    in
    Html.ul
        [ css
            [ Css.listStyle Css.none
            , Css.width (Css.px 500)
            , Css.margin Css.auto
            ]
        ]
        << List.map viewPokemon
