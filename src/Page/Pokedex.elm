module Page.Pokedex exposing (..)

import Html exposing (Html)
import Page exposing (PageView)
import Pokemon exposing (Pokemon(..))
import Pokemon.API
import RemoteData exposing (WebData)
import Session exposing (Session)


type Msg
    = Init
    | GotPokemons (WebData (Pokemon.API.Page Pokemon))


type alias Model =
    { session : Session, mSearchQuery : Maybe String, pokemons : WebData (Pokemon.API.Page Pokemon) }


init : Session -> { model | mSearchQuery : Maybe String } -> ( Model, Cmd Msg )
init session { mSearchQuery } =
    ( { session = session, mSearchQuery = mSearchQuery, pokemons = RemoteData.NotAsked }, Pokemon.API.getPokemons GotPokemons )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Init ->
            ( model, Pokemon.API.getPokemons GotPokemons )

        GotPokemons pokemons ->
            ( { model | pokemons = pokemons }, Cmd.none )


view : Model -> PageView Msg
view model =
    { title = "Pokedex"
    , content =
        Html.div [] <|
            case model.pokemons of
                RemoteData.Success x ->
                    let
                        searchedPokemons =
                            model.mSearchQuery
                                |> Maybe.map
                                    (\needle ->
                                        List.filter
                                            (\(Pokemon { name }) ->
                                                String.contains (String.toLower needle) (String.toLower name)
                                            )
                                            x.results
                                    )
                                |> Maybe.withDefault x.results
                    in
                    [ viewPokemons searchedPokemons ]

                _ ->
                    [ Html.text "Loading..." ]
    }


viewPokemons : List Pokemon -> Html Msg
viewPokemons =
    let
        viewPokemon (Pokemon pokemon) =
            Html.li [] [ Html.text pokemon.name ]
    in
    Html.ul [] << List.map viewPokemon
