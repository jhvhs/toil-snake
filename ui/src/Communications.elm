module Communications exposing
    ( fullSaveSnakeScaleUrl
    , fullSaveSnakeUrl
    , saveSnakeScaleUrl
    , saveSnakeUrl
    , scaleRepresentation
    , snakeRepresentation
    )

import Models exposing (Scale, ToilSnake, ToilSnakeScale)
import Url


fullSaveSnakeUrl : ToilSnake -> String
fullSaveSnakeUrl snake =
    saveSnakeUrl snake ++ "?" ++ snakeRepresentation snake


saveSnakeUrl : ToilSnake -> String
saveSnakeUrl snake =
    if snake.id > 0 then
        "/snakes/" ++ String.fromInt snake.id

    else
        "/snakes/"


snakeRepresentation : ToilSnake -> String
snakeRepresentation snake =
    String.join "&"
        [ "snake[title]=" ++ Url.percentEncode snake.title
        , "snake[author]=" ++ Url.percentEncode snake.author
        ]


fullSaveSnakeScaleUrl : ToilSnakeScale -> String
fullSaveSnakeScaleUrl toilSnakeScale =
    saveSnakeScaleUrl toilSnakeScale ++ "?" ++ scaleRepresentation toilSnakeScale.scale


saveSnakeScaleUrl : ToilSnakeScale -> String
saveSnakeScaleUrl snakeScale =
    if snakeScale.scale.id > 0 then
        "/snakes/" ++ String.fromInt snakeScale.snake.id ++ "/scales/" ++ String.fromInt snakeScale.scale.id ++ "/"

    else
        "/snakes/" ++ String.fromInt snakeScale.snake.id ++ "/scales/"


scaleRepresentation : Scale -> String
scaleRepresentation scale =
    String.join "&"
        [ "scale[details]=" ++ Url.percentEncode scale.details
        , "scale[author]=" ++ Url.percentEncode scale.author
        ]
