module Pokemon exposing (..)

import Json.Decode as JD exposing (Decoder)

type Pokemon = Pokemon {
        name : String
    }

decoder : Decoder Pokemon
decoder = JD.map (\name -> Pokemon {name = name}) 
    <| JD.field "name" JD.string
