module ToilSnake exposing (main)

import Browser
import Events exposing (..)
import Messages exposing (..)
import Models exposing (..)
import Time
import Views exposing (..)



-- MESSAGES


init : () -> ( Model, Cmd Message )
init _ =
    ( initialModel, loadToilSnake initialModel )



-- UPDATE


update : Message -> Model -> ( Model, Cmd Message )
update msg model =
    case msg of
        NewSnake ->
            ( addSnake model, Cmd.none )

        NewScale snake ->
            ( addScale model snake, Cmd.none )

        SnakeTitle title ->
            ( setEditedSnakeTitle model title, Cmd.none )

        SnakeAuthor author ->
            ( setEditedSnakeAuthor model author, Cmd.none )

        SaveSnake ->
            onSaveSnakeChanges model

        EditSnake snake ->
            ( { model | editedSnake = Just snake }, Cmd.none )

        EditScale snake scale ->
            ( { model | editedScale = Just (ToilSnakeScale snake scale) }, Cmd.none )

        SaveScale ->
            onSaveScaleChanges model

        ScaleAuthor author ->
            ( setEditedScaleAuthor model author, Cmd.none )

        ScaleDetails details ->
            ( setEditedScaleDetails model details, Cmd.none )

        Tick time ->
            ( { model | currentTime = Just time }, loadToilSnake model )

        CancelEdit ->
            ( { model | editedSnake = Nothing, editedScale = Nothing }, Cmd.none )

        ReceivedToilSnake result ->
            case result of
                Ok snakes ->
                    onReceivedToilSnakes model snakes

                Err _ ->
                    ( model, Cmd.none )

        LogError result ->
            case result of
                Ok _ ->
                    ( model, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Message
subscriptions _ =
    Time.every 1000 Tick


main : Program () Model Message
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
