module Page.Pokedex exposing (..)
import RemoteData exposing (WebData)
import Session exposing (Session)
import Html exposing (div)
import Html exposing (text)
import Html exposing (Html)
import Page exposing (Page)

type alias Model = { session : Session, pokemons : WebData (List Pokemon) }

type alias Pokemon = { name : String }


init : Session -> (Model, Cmd Msg)
init session = ({ session = session, pokemons = RemoteData.Loading }, Cmd.none)

type Msg
    = GotPokemons

update : Msg -> Model ->  ( Model, Cmd Msg )
update msg model =
    case msg of
        GotPokemons ->
             ( model, Cmd.none )

view : Model -> Page Msg
view _ =
    { title = "Pokedex"
    , content = div [] [ text "Pokedex"] }
    
