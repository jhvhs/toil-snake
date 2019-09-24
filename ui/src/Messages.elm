module Messages exposing (Message(..))

import Http
import Models exposing (Scale, ToilSnake)
import Time


type Message
    = NewScale ToilSnake
    | NewSnake
    | SnakeTitle String
    | SnakeAuthor String
    | SnakeArchived Bool
    | EditSnake ToilSnake
    | SaveSnake
    | ScaleDetails String
    | ScaleAuthor String
    | EditScale ToilSnake Scale
    | SaveScale
    | Tick Time.Posix
    | ReceivedToilSnake (Result Http.Error (List ToilSnake))
    | LogError (Result Http.Error ())
    | CancelEdit
