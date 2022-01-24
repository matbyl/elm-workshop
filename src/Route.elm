module Route exposing (..)
import Url.Parser exposing (Parser)
import Url.Parser as Parser
import Url exposing (Url)


type Route = Root | MyNewPage

parser : Parser (Route -> a) a
parser = Parser.oneOf [
        Parser.map Root Parser.top
    ]

fromUrl : Url -> Maybe Route
fromUrl url = Parser.parse parser { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }

toString : Route -> String
toString route = case route of
    Root ->
     "#/"

    MyNewPage ->
     "#/my-new-page"
