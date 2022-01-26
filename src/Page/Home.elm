module Page.Home exposing (..)

import Css
import Html.Styled as Html
import Html.Styled.Attributes as Attributes exposing (css)
import Page exposing (PageView)
import Route


view : PageView msg
view =
    { title = "Home"
    , content =
        Html.section [ css [ Css.width (Css.pct 100), Css.textAlign Css.center ] ]
            [ Html.h2 [ css [ Css.fontSize (Css.px 48) ] ] [ Html.text "Pokedex" ]
            ]
    }
