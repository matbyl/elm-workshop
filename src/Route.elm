module Route exposing (..)

import Browser.Navigation
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), (<?>), Parser, int, oneOf, s, string)
import Url.Parser.Query as Query


type Route
    = Home
    | Error
    | Pokedex (Maybe String)
    | Pokemon Int


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Home Parser.top
        , Parser.map Pokedex <| Parser.s "pokedex" <?> Query.string "search"
        , Parser.map Pokemon <| Parser.s "pokemon" </> Parser.int
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
            "/error"

        Pokedex Nothing ->
            "/pokedex"

        Pokedex (Just s) ->
            "/pokedex?search=" ++ s

        Pokemon pokemonId ->
            "/pokemon/" ++ String.fromInt pokemonId


show : Route -> String
show route =
    case route of
        Home ->
            "Home"

        Error ->
            "Error"

        Pokedex _ ->
            "Pokedex"

        Pokemon _ ->
            "Pokemon"


navigateToRoute : Browser.Navigation.Key -> Route -> Cmd msg
navigateToRoute key =
    Browser.Navigation.pushUrl key << toString
