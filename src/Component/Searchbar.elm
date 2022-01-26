module Component.Searchbar exposing (..)

import Css
import Html.Styled as Html exposing (Html, form, input)
import Html.Styled.Attributes exposing (css, value)
import Html.Styled.Events exposing (onInput, onSubmit)
import Html.Styled.Attributes exposing (placeholder)


type Msg
    = Search
    | UpdateInput String


type alias Config msg =
    { onSearch : msg, onChange : String -> msg }


type alias Model =
    Maybe String


view : Config msg -> Model -> Html msg
view { onSearch, onChange } model =
    form [ onSubmit onSearch ]
        [ input
            [ value (Maybe.withDefault "" model)
            , onInput onChange
            , placeholder "Search for a pokemon"
            , css
                [ Css.margin2 Css.auto (Css.px 5)
                , Css.borderRadius (Css.px 10)
                , Css.width (Css.px 200)
                , Css.padding2 (Css.px 5) (Css.px 10)
                ]
            ]
            []
        ]
