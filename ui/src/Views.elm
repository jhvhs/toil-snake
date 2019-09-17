module Views exposing (view)

import Html exposing (Html, br, button, div, fieldset, form, h2, input, label, p, span, text, textarea)
import Html.Attributes exposing (class, for, id, name, type_, value)
import Html.Events exposing (onClick, onInput)
import ISO8601 exposing (toPosix)
import Markdown
import Messages exposing (..)
import Models exposing (..)
import String
import Time exposing (Posix)
import ViewHelpers exposing (dateDiff)


view : Model -> Html Message
view model =
    div [] [ mainView model ]


mainView : Model -> Html Message
mainView model =
    case model.editedSnake of
        Just snake ->
            snakeEditView snake

        Nothing ->
            scaleEditOrMainSnakeView model


scaleEditOrMainSnakeView : Model -> Html Message
scaleEditOrMainSnakeView model =
    case model.editedScale of
        Just scale ->
            scaleEditView scale

        Nothing ->
            mainSnakeView model


mainSnakeView : Model -> Html Message
mainSnakeView model =
    div [] (newSnakeView :: List.map (snakeView model.currentTime) model.data)


snakeEditView : ToilSnake -> Html Message
snakeEditView snake =
    div []
        [ form [ class "form" ]
            [ fieldset []
                [ inputComponent "Title" snake.title SnakeTitle
                , inputComponent "Author" snake.author SnakeAuthor
                , div [ class "grid" ]
                    [ div [ class "col" ] []
                    , div [ class "col col-fixed" ]
                        [ div [] [ cancelButton, saveButton SaveSnake ]
                        ]
                    ]
                ]
            ]
        ]


scaleEditView : ToilSnakeScale -> Html Message
scaleEditView snakeScale =
    div []
        [ div [ class "grid" ]
            [ div [ class "col col-fixed" ]
                [ h2 [] [ text ("Scale for " ++ snakeScale.snake.title) ]
                ]
            ]
        , form [ class "form" ]
            [ fieldset []
                [ textAreaComponent "Details" snakeScale.scale.details ScaleDetails
                , inputComponent "Author" snakeScale.scale.author ScaleAuthor
                , div [ class "grid" ]
                    [ div [ class "col" ] []
                    , div [ class "col col-fixed" ]
                        [ div [] [ cancelButton, saveButton SaveScale ]
                        ]
                    ]
                ]
            ]
        ]


formInput : String -> Html Message -> Html Message
formInput fieldName component =
    div [ class "form-unit" ]
        [ div [ class "grid grid-nogutter label-row" ]
            [ div [ class "col" ] [ label [ for fieldName ] [ text fieldName ] ]
            , div [ class "col col-fixed col-middle post-label" ] []
            ]
        , div [ class "field-row" ] [ component ]
        , div [ class "help-row type-gray" ] []
        ]


inputComponent : String -> String -> (String -> Message) -> Html Message
inputComponent fieldName fieldValue message =
    formInput fieldName
        (input
            [ type_ "text"
            , name fieldName
            , id fieldName
            , value fieldValue
            , onInput message
            ]
            []
        )


textAreaComponent : String -> String -> (String -> Message) -> Html Message
textAreaComponent fieldName fieldValue message =
    formInput fieldName
        (textarea
            [ name fieldName
            , value fieldValue
            , onInput message
            ]
            []
        )


cancelButton : Html Message
cancelButton =
    button
        [ type_ "button"
        , class "pui-btn pui-btn--primary pui-btn--alt"
        , onClick CancelEdit
        ]
        [ span [] [ text "Cancel" ] ]


saveButton : Message -> Html Message
saveButton message =
    button
        [ type_ "button"
        , class "pui-btn pui-btn--primary"
        , onClick message
        ]
        [ span [] [ text "Save" ] ]


snakeView : Maybe Posix -> ToilSnake -> Html Message
snakeView currentTime snake =
    div [ class "grid" ]
        (snakeHeadView snake currentTime :: List.map (scaleReadView snake currentTime) snake.scales ++ [ newScaleView snake ])


snakeHeadView : ToilSnake -> Maybe Posix -> Html Message
snakeHeadView snake currentTime =
    div [ class "col col-fixed ts-head" ]
        [ div [ onClick (EditSnake snake), class "ts-ellipsis" ] [ text snake.title ]
        , p [ class "type-xs" ]
            [ text snake.author
            , br [] []
            , text (isoDateView snake.updated_at currentTime)
            ]
        ]


newScaleView : ToilSnake -> Html Message
newScaleView snake =
    if snake.id > 0 then
        div [ class "col col-fixed ts-scale" ]
            [ p [ class "ts-filler" ] []
            , p [ class "ts-ellipsis type-lg em-high", onClick (NewScale snake) ]
                [ text "🐍 <Add a scale>" ]
            ]

    else
        div [] []


newSnakeView : Html Message
newSnakeView =
    div []
        [ div [ class "grid" ] [ div [ class "col col-fixed" ] [ h2 [] [ text "Team toil snake" ] ] ]
        , div [ class "grid" ]
            [ div [ class "col col-fixed ts-new-snake" ]
                [ button [ onClick NewSnake, class "pui-btn pui-btn--primary" ] [ text "New snake" ] ]
            ]
        ]


scaleReadView : ToilSnake -> Maybe Posix -> Scale -> Html Message
scaleReadView snake currentTime scale =
    div [ class "col col-fixed ts-scale" ]
        [ div
            [ class "aligner" ]
            [ div
                [ class "aligner-item ts-ellipsis"
                , onClick (EditScale snake scale)
                ]
                (Markdown.toHtml Nothing scale.details)
            , div [ class "aligner-item aligner-item-bottom" ]
                [ p [ class "type-xs" ]
                    [ text scale.author
                    , br [] []
                    , text (isoDateView scale.created_at currentTime)
                    , text " * "
                    , text (isoDateView scale.updated_at currentTime)
                    ]
                ]
            ]
        ]


isoDateView : String -> Maybe Posix -> String
isoDateView date currentTime =
    let
        d =
            ISO8601.fromString date
    in
    case d of
        Result.Ok t ->
            case currentTime of
                Just time ->
                    dateDiff time (toPosix t)

                Nothing ->
                    ""

        Result.Err _ ->
            "Saving..."
