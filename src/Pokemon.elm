module Pokemon exposing (..)

import Json.Decode as JD exposing (Decoder)

import Json.Encode
import Json.Decode
-- elm-package install -- yes noredink/elm-decode-pipeline
import Json.Decode.Pipeline

type Pokemon = Pokemon PokemonData
type alias PokemonData = { id : Int
    , name : String
    , height : Int
    , weight : Int
    , image : String 
    }


decodePokemon : JD.Decoder Pokemon
decodePokemon = JD.map Pokemon decodePokemonData

decodePokemonData : JD.Decoder PokemonData
decodePokemonData = JD.map5 PokemonData
    (JD.field "id" JD.int)
    (JD.field "name" JD.string)
    (JD.field "height" JD.int)
    (JD.field "weight" JD.int)
    (JD.field "sprites" <| JD.field "other" <| JD.field "home" <| JD.field "front_default" JD.string)

type PokedexItem = PokedexItem {
        name : String
    }

decodePokedexItem : Decoder PokedexItem
decodePokedexItem = JD.map (\name -> PokedexItem {name = name}) 
    (JD.field "name" JD.string)
