module Events exposing (loadToilSnake, onReceivedToilSnakes, onSaveScaleChanges, onSaveSnakeChanges, submitScale, submitSnake)

import Communications exposing (fullSaveSnakeScaleUrl, fullSaveSnakeUrl)
import Decoders exposing (modelDecoder)
import Http
import Messages exposing (..)
import Models exposing (..)


onSaveScaleChanges : Model -> ( Model, Cmd Message )
onSaveScaleChanges model =
    case model.editedScale of
        Just snakeScale ->
            ( { model | data = List.map (saveSnakeScale snakeScale.snake snakeScale.scale) model.data, editedScale = Nothing }
            , submitScale snakeScale
            )

        Nothing ->
            ( model, Cmd.none )


onSaveSnakeChanges : Model -> ( Model, Cmd Message )
onSaveSnakeChanges model =
    case model.editedSnake of
        Just snake ->
            ( { model | data = List.map (saveSnake snake) model.data, editedSnake = Nothing }, submitSnake snake )

        Nothing ->
            ( model, Cmd.none )


loadToilSnake : Model -> Cmd Message
loadToilSnake model =
    if model.editedScale == Nothing && model.editedSnake == Nothing then
        Http.get
            { url = "/snakes/", expect = Http.expectJson ReceivedToilSnake modelDecoder }

    else
        Cmd.none


onReceivedToilSnakes : Model -> List ToilSnake -> ( Model, Cmd Message )
onReceivedToilSnakes model snakes =
    if model.editedScale == Nothing && model.editedSnake == Nothing then
        ( { model | data = snakes }, Cmd.none )

    else
        ( model, Cmd.none )


submitSnake : ToilSnake -> Cmd Message
submitSnake snake =
    let
        method =
            if snake.id > 0 then
                "PUT"

            else
                "POST"

        request =
            { method = method
            , headers = []
            , url = fullSaveSnakeUrl snake
            , body = Http.emptyBody
            , expect = Http.expectWhatever LogError
            , timeout = Nothing
            , tracker = Nothing
            }
    in
    Http.request request


submitScale : ToilSnakeScale -> Cmd Message
submitScale snakeScale =
    let
        method =
            if snakeScale.scale.id > 0 then
                "PUT"

            else
                "POST"

        request =
            { method = method
            , headers = []
            , url = fullSaveSnakeScaleUrl snakeScale
            , body = Http.emptyBody
            , expect = Http.expectWhatever LogError
            , timeout = Nothing
            , tracker = Nothing
            }
    in
    Http.request request
