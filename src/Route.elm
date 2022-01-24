module Route exposing (..)

import Url exposing (Url)
import Url.Parser as Parser exposing (Parser)


type Route
    = Home
    | Pokedex


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Home Parser.top
        , Parser.map Pokedex <| Parser.s "pokedex"
        ]


fromUrl : Url -> Maybe Route
fromUrl url =
    Parser.parse parser { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }


toString : Route -> String
toString route =
    case route of
        Home ->
            "#/"

        Pokedex ->
            "#/pokedex"
