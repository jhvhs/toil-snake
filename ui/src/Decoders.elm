module Decoders exposing (modelDecoder, scaleDecoder, snakeDecoder)

import Json.Decode exposing (Decoder, bool, field, int, list, map6, map7, string)
import Models exposing (Scale, ToilSnake)


modelDecoder : Decoder (List ToilSnake)
modelDecoder =
    list snakeDecoder


snakeDecoder : Decoder ToilSnake
snakeDecoder =
    map7 ToilSnake
        (field "id" int)
        (field "title" string)
        (field "author" string)
        (field "created_at" string)
        (field "updated_at" string)
        (field "archived" bool)
        (field "scales" (list scaleDecoder))


scaleDecoder : Decoder Scale
scaleDecoder =
    map6 Scale
        (field "id" int)
        (field "snake_id" int)
        (field "author" string)
        (field "details" string)
        (field "created_at" string)
        (field "updated_at" string)
