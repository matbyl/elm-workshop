module Page exposing (..)
import Html exposing (Html)
import Browser exposing (Document)



type Page
    = Blank
    | Pokedex


type alias PageView msg = { title : String, content : Html msg}

view : Page -> PageView msg -> Document msg
view _ { title, content } =
    { title = title
    , body = [ content ]
    }
 
