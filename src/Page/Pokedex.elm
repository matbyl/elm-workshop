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
    { session : Session, pokemons : WebData (Pokemon.API.Page Pokemon) }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session, pokemons = RemoteData.NotAsked }, Pokemon.API.getPokemons GotPokemons )


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
                    [ viewPokemons x.results ]

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
