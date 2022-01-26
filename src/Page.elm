module Page exposing (..)

import Browser exposing (Document)
import Component.Navbar as Navbar
import Component.Searchbar as Searchbar
import Css
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes exposing (css)
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
        List.map Html.toUnstyled
            [ Html.header
                [ css
                    [ Css.padding2 (Css.px 20) (Css.px 25)
                    , Css.textAlign Css.center
                    -- , Css.justifyContent Css.center
                    -- , Css.displayFlex
                    ]
                ]
                [ Navbar.view ((==) activeRoute) [ Route.Home, Route.Pokedex Nothing ]
                , Searchbar.view searchbarConfig searchbarModel
                ]
            , Html.section [ css [ Css.padding2 (Css.px 35) (Css.px 50) ] ] [ Html.map fromPageMsg content ]
            ]
    }
