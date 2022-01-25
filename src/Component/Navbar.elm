module Component.Navbar exposing (..)
import Route exposing (Route)
import Html exposing (Html)
import Html exposing (div)
import List.Nonempty exposing (Nonempty(..))
import Html exposing (header)
import Html exposing (a)
import Html.Attributes exposing (href)
import Html exposing (text)

view : (Route -> Bool) -> List Route -> Html msg
view isSelected routes = 
    let
        link x = a [ href <| Route.toString x] [ text <| Route.show x] 
    in
    header [] <| List.map link routes
