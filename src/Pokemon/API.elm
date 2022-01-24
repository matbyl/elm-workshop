module Pokemon.API exposing (..)

import Http
import RemoteData exposing (WebData)
import Url exposing (Url)
import Url.Builder exposing (QueryParameter)
import Pokemon exposing (Pokemon)
import Json.Decode as JD
import Json.Decode exposing (Decoder)

type alias Page a = { count: Int, next : Maybe String, previous : Maybe String, results : List a }

url : List String -> List QueryParameter -> String
url = Url.Builder.crossOrigin "https://pokeapi.co/api/v2"

getPokemons : (WebData (Page Pokemon)-> msg) -> Cmd msg
getPokemons toMsg = Http.get {
        url = url ["pokemon"] [],
        expect = Http.expectJson (toMsg << RemoteData.fromResult) (pageDecoder Pokemon.decoder)
    }

getNextPage : Page a -> Cmd msg
getNextPage =  

pageDecoder : Decoder a -> Decoder (Page a)
pageDecoder resultsDecoder= JD.map4 Page 
    (JD.field "count" JD.int)
    (JD.field "next" <| JD.maybe JD.string)
    (JD.field "previous" <| JD.maybe JD.string)
    (JD.field "results" <| JD.list resultsDecoder)
