module Component.Searchbar exposing (..)

import Html exposing (Html, form, input)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput, onSubmit)


type Msg
    = Search
    | UpdateInput String


type alias Config msg =
    { onSearch : msg, onChange : String -> msg }


type alias Model =
    Maybe String


view : Config msg -> Model -> Html msg
view { onSearch, onChange } model =
    form [ onSubmit onSearch ] [ input [ value (Maybe.withDefault "" model), onInput onChange ] [] ]
