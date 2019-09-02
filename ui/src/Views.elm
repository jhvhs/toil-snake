module Views exposing (view)

import Html exposing (Html, button, div, fieldset, form, h2, input, label, p, span, text, textarea)
import Html.Attributes exposing (class, for, id, name, type_, value)
import Html.Events exposing (onClick, onInput)
import ISO8601
import Markdown
import Messages exposing (..)
import Models exposing (..)
import String


view : Model -> Html Message
view model =
    div [] [ mainView model ]


mainView : Model -> Html Message
mainView model =
    case model.editedSnake of
        Just snake ->
            snakeEditView snake

        Nothing ->
            case model.editedScale of
                Just scale ->
                    scaleEditView scale

                Nothing ->
                    div [] (newSnakeView :: List.map snakeView model.data)


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
        , div [ class "field-row" ]
            [ component
            ]
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


snakeView : ToilSnake -> Html Message
snakeView snake =
    div [ class "grid" ]
        (snakeHeadView snake :: List.map (scaleReadView snake) snake.scales ++ [ newScaleView snake ])


snakeHeadView : ToilSnake -> Html Message
snakeHeadView snake =
    div [ class "col col-fixed ts-head" ]
        [ div [] [ text snake.title ]
        , div [] [ text snake.author ]
        , div [] [ text (isoDateView snake.updated_at) ]
        , button [ onClick (EditSnake snake), class "pui-btn pui-btn--default" ] [ text "Edit" ]
        ]


newScaleView : ToilSnake -> Html Message
newScaleView snake =
    if snake.id > 0 then
        div [ class "col col-fixed ts-new-scale" ]
            [ button [ onClick (NewScale snake), class "pui-btn pui-btn--brand" ] [ text "Add a scale" ] ]

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


scaleReadView : ToilSnake -> Scale -> Html Message
scaleReadView snake scale =
    div [ class "col col-fixed ts-scale" ]
        [ div
            [ class "aligner" ]
            [ div [ class "aligner-item type-ellipsis" ] (Markdown.toHtml Nothing scale.details)
            , div [ class "aligner-item aligner-item-bottom" ]
                [ p [] [ text scale.author ]
                , p [] [ text (isoDateView scale.updated_at) ]
                , button
                    [ onClick (EditScale snake scale), class "pui-btn pui-btn--default aligner-item aligner-item-bottom" ]
                    [ text "Edit" ]
                ]
            ]
        ]


isoDateView : String -> String
isoDateView date =
    let
        d =
            ISO8601.fromString date
    in
    case d of
        Result.Ok t ->
            String.fromInt t.year ++ "-" ++ twoDigits t.month ++ "-" ++ twoDigits t.day

        Result.Err _ ->
            "Saving..."


twoDigits : Int -> String
twoDigits int =
    String.padLeft 2 '0' (String.fromInt int)
