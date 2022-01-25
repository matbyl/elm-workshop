module Route exposing (..)

import Browser.Navigation
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), (<?>), Parser, int, oneOf, s, string)
import Url.Parser.Query as Query


type Route
    = Home
    | Error
    | Pokedex (Maybe String)


all : List Route
all =
    [ Home, Error, Pokedex Nothing ]


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Home Parser.top
        , Parser.map Pokedex <| Parser.s "pokedex" <?> Query.string "search"
        ]


fromUrl : Url -> Maybe Route
fromUrl =
    Parser.parse parser


toString : Route -> String
toString route =
    case route of
        Home ->
            "/"

        Error ->
            "error"

        Pokedex Nothing ->
            "pokedex"

        Pokedex (Just s) ->
            "pokedex?search=" ++ s


show : Route -> String
show route =
    case route of
        Home ->
            "Home"

        Error ->
            "Error"

        Pokedex _ ->
            "Pokedex"


navigateToRoute : Browser.Navigation.Key -> Route -> Cmd msg
navigateToRoute key =
    Browser.Navigation.pushUrl key << toString
