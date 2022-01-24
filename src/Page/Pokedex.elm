module Page.Pokedex exposing (..)
import Html
import Html exposing (Html)
import Html.Attributes
import Session exposing (Session)
import Browser exposing (Document)
import Page exposing (PageView)
import Platform exposing (Router)
import Route exposing (Route)
import Pokemon.API
import Pokemon exposing (Pokemon(..))
import RemoteData exposing (WebData)
import Pokemon.API
import Html.Events

type Msg
    = FirstPage
    | PreviousPage
    | NextPage
    | LastPage
    | GotPokemons (WebData (Pokemon.API.Page Pokemon))


type alias Model = { session : Session, pokemons : WebData (Pokemon.API.Page Pokemon) } 

init : Session -> (Model, Cmd Msg)
init session = ( { session = session, pokemons = RemoteData.NotAsked }, Pokemon.API.getPokemons GotPokemons)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
    FirstPage ->
        (model, Pokemon.API.getPokemons GotPokemons)
    PreviousPage ->
        (model, Cmd.none)
    NextPage ->
        (model, Pokemon.API.getNextPokemons )
    LastPage ->
        (model, Cmd.none)
    GotPokemons pokemons ->
        ({model | pokemons = pokemons}, Cmd.none)

view : Model -> PageView Msg
view model =
    { title = "Pokedex"
    , content = Html.div [] case model.pokemons of
        RemoteData.Success x ->
            [ viewPokemons x.results
            , Html.button [ Html.Events.onClick NextPage ] [ Html.text Next] ]
        _ ->
            [ Html.text "Loading..." ]
    }

viewPokemons : List Pokemon -> Html Msg
viewPokemons = Html.ul [] << List.map (\(Pokemon pokemon) -> Html.li [] [Html.text pokemon.name])
