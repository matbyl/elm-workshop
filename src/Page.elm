module Page exposing (..)

import Browser exposing (Document)
import Component.Navbar as Navbar
import Html exposing (Html)
import Route exposing (Route)


type Page
    = Blank
    | Pokedex


type alias PageView msg =
    { title : String, content : Html msg }


view : Route -> PageView msg -> Document msg
view activeRoute { title, content } =
    { title = title
    , body =
        [ Navbar.view ((==) activeRoute) Route.all
        , content
        ]
    }
