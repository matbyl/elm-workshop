module Route exposing (..)

import Url exposing (Url)
import Url.Parser as Parser exposing (Parser)


type Route
    = Home
    | Error
    | Pokedex


all : List Route
all =
    [ Home, Error, Pokedex ]


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Home Parser.top
        , Parser.map Pokedex (Parser.s "pokedex")
        ]


fromUrl : Url -> Maybe Route
fromUrl url =
    Parser.parse parser { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }


toString : Route -> String
toString route =
    case route of
        Home ->
            "#/"

        Error ->
            "#/error"

        Pokedex ->
            "#/pokedex"


show : Route -> String
show route =
    case route of
        Home ->
            "Home"

        Error ->
            "Error"

        Pokedex ->
            "Pokedex"
