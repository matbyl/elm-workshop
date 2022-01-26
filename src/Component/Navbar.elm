module Component.Navbar exposing (..)

import Css
import Html.Styled exposing (Html, a, div, header, text)
import Html.Styled.Attributes exposing (css, href)
import List.Nonempty exposing (Nonempty(..))
import Route exposing (Route)


view : (Route -> Bool) -> List Route -> Html msg
view isSelected routes =
    let
        link x =
            a
                [ href <| Route.toString x
                , css
                    [ Css.margin2 Css.auto (Css.px 5)
                    , Css.color <|
                        if isSelected x then
                            Css.rgba 0 0 0 0.94

                        else
                            Css.rgba 0 0 0 0.55
                    , Css.fontSize (Css.rem 1.2)
                    , Css.fontWeight (Css.int 800)
                    , Css.textDecorations <|
                        if isSelected x then
                            [ Css.underline ]

                        else
                            []
                    , Css.hover
                        [ Css.textDecoration Css.underline
                        ]
                    ]
                ]
                [ text <| Route.show x ]
    in
    div
        [ css
            [ Css.padding2 (Css.px 20) (Css.px 25)
            , Css.justifyContent Css.center
            , Css.displayFlex
            ]
        ]
    <|
        List.map link routes
