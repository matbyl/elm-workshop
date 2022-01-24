module Route exposing (..)
import Url.Parser exposing (Parser)
import Url.Parser as Parser
import Url exposing (Url)


type Route = Home | Pokedex

parser : Parser (Route -> a) a
parser = Parser.oneOf [
        Parser.map Home Parser.top
        , Parser.map Pokedex <| Parser.s "pokedex"
    ]

fromUrl : Url -> Maybe Route
fromUrl url = Parser.parse parser { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }

toString : Route -> String
toString route = case route of
    Home ->
     "#/"

    Pokedex ->
     "#/pokedex"
