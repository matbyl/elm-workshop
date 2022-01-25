module Page.Home exposing (..)

import Html
import Html exposing (Html)
import Page exposing (PageView)
import Html.Attributes
import Route

view : PageView msg
view = {
    title = "Home",
    content = Html.div [] [ Html.a [ Html.Attributes.href <| Route.toString <| Route.Pokedex Nothing] [ Html.text "CATS ARE AMAZING" ]]
    }
    
