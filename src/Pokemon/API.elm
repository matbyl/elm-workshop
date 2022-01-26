module Pokemon.API exposing (..)

import Http
import Json.Decode as JD exposing (Decoder)
import Pokemon exposing (PokedexItem, Pokemon)
import RemoteData exposing (WebData)
import Url.Builder exposing (QueryParameter)
import Route exposing (Route(..))


type alias Page a =
    { count : Int
    , next : Maybe String
    , previous : Maybe String
    , results : List a
    }


url : List String -> List QueryParameter -> String
url =
    Url.Builder.crossOrigin "https://pokeapi.co/api/v2"


getPokemons : (WebData (Page PokedexItem) -> msg) -> Cmd msg
getPokemons toMsg =
    Http.get
        { url = url [ "pokemon-species" ] [ Url.Builder.string "limit" "1000" ]
        , expect = Http.expectJson (toMsg << RemoteData.fromResult) (pageDecoder Pokemon.decodePokedexItem)
        }

getPokemon : Int -> (WebData Pokemon -> msg) -> Cmd msg
getPokemon pokemonId toMsg =
    Http.get
        { url = url [ "pokemon", String.fromInt pokemonId ] [ Url.Builder.string "limit" "1000" ]
        , expect = Http.expectJson (toMsg << RemoteData.fromResult) Pokemon.decodePokemon
        }
    

pageDecoder : Decoder a -> Decoder (Page a)
pageDecoder resultsDecoder =
    JD.map4 Page
        (JD.field "count" JD.int)
        (JD.field "next" <| JD.maybe JD.string)
        (JD.field "previous" <| JD.maybe JD.string)
        (JD.field "results" <| JD.list resultsDecoder)
