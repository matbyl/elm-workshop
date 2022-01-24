module Page.Blank exposing (..)
import Html
import Page exposing (PageView)


view : PageView msg
view =
    { title = "Blank"
    , content = Html.text "blank"
    }
