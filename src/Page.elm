module Page exposing (..)

import Browser exposing (Document)
import Component.Navbar as Navbar
import Component.Searchbar as Searchbar
import Html exposing (Html)
import Route exposing (Route)


type Page
    = Blank
    | Pokedex


type alias PageView msg =
    { title : String, content : Html msg }


view :
    { a
        | activeRoute : Route
        , searchbarConfig : Searchbar.Config msg
        , searchbarModel : Searchbar.Model
        , fromPageMsg : pageMsg -> msg
    }
    -> PageView pageMsg
    -> Document msg
view { activeRoute, searchbarConfig, searchbarModel, fromPageMsg } { title, content } =
    { title = title
    , body =
        [ Navbar.view ((==) activeRoute) Route.all
        , Searchbar.view searchbarConfig searchbarModel
        , Html.map fromPageMsg content
        ]
    }
