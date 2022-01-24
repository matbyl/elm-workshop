module Page exposing (..)

import Browser exposing (Document)
import Html exposing (Html)


type alias Page msg =
    { title : String, content : Html msg }


view : Page msg -> Document msg
view { title, content } =
    { title = title
    , body = [ content ]
    }


map : (a -> b) -> Page a -> Page b
map f { title, content } =
    { title = title, content = Html.map f content }
