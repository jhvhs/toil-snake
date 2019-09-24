module Models exposing
    ( Model
    , Scale
    , ToilSnake
    , ToilSnakeScale
    , addScale
    , addSnake
    , initialModel
    , saveSnake
    , saveSnakeScale
    , setEditedScaleAuthor
    , setEditedScaleDetails
    , setEditedSnakeArchived
    , setEditedSnakeAuthor
    , setEditedSnakeTitle
    , setSnakeAuthor
    )

import Time exposing (Posix)


type alias Scale =
    { id : Int
    , snake_id : Int
    , author : String
    , details : String
    , created_at : String
    , updated_at : String
    }


type alias ToilSnake =
    { id : Int
    , title : String
    , author : String
    , created_at : String
    , updated_at : String
    , archived : Bool
    , scales : List Scale
    }


type alias ToilSnakeScale =
    { snake : ToilSnake, scale : Scale }


type alias Model =
    { data : List ToilSnake
    , editedSnake : Maybe ToilSnake
    , editedScale : Maybe ToilSnakeScale
    , currentTime : Maybe Posix
    }



-- Initializers


newSnake : ToilSnake
newSnake =
    ToilSnake 0 "" "" "" "" False []


newScale : Scale
newScale =
    Scale 0 0 "" "" "" ""


initialModel : Model
initialModel =
    Model
        []
        Nothing
        Nothing
        Nothing


addSnake : Model -> Model
addSnake model =
    let
        shinySnake =
            newSnake
    in
    { model | data = model.data ++ [ shinySnake ], editedSnake = Just shinySnake }


addScale : Model -> ToilSnake -> Model
addScale model snake =
    let
        newData =
            List.map (addScaleToSnake snake) model.data

        insertedScale =
            List.head (List.filterMap (lastScaleForSnake snake) newData)

        editedScale =
            case insertedScale of
                Nothing ->
                    Nothing

                Just scale ->
                    Just (ToilSnakeScale snake scale)
    in
    { model | data = newData, editedScale = editedScale }


lastScaleForSnake : ToilSnake -> ToilSnake -> Maybe Scale
lastScaleForSnake theSnake aSnake =
    if theSnake.id == aSnake.id then
        List.head (List.reverse aSnake.scales)

    else
        Nothing


addScaleToSnake : ToilSnake -> ToilSnake -> ToilSnake
addScaleToSnake theSnake aSnake =
    if theSnake == aSnake then
        { aSnake | scales = aSnake.scales ++ [ newScale ] }

    else
        aSnake


setSnakeArchived : ToilSnake -> Bool -> ToilSnake
setSnakeArchived snake archived_ =
    { snake | archived = archived_ }


setSnakeAuthor : ToilSnake -> String -> ToilSnake
setSnakeAuthor snake newAuthor =
    { snake | author = newAuthor }


setEditedSnakeTitle : Model -> String -> Model
setEditedSnakeTitle model title =
    case model.editedSnake of
        Just snake ->
            let
                updatedSnake =
                    setSnakeTitle snake title
            in
            { model | editedSnake = Just updatedSnake, data = List.map (saveSnake updatedSnake) model.data }

        Nothing ->
            model


setSnakeTitle : ToilSnake -> String -> ToilSnake
setSnakeTitle snake newTitle =
    { snake | title = newTitle }


setEditedSnakeArchived : Model -> Bool -> Model
setEditedSnakeArchived model archived =
    case model.editedSnake of
        Just snake ->
            let
                updatedSnake =
                    setSnakeArchived snake archived
            in
            { model | editedSnake = Just updatedSnake, data = List.map (saveSnake updatedSnake) model.data }

        Nothing ->
            model


setEditedSnakeAuthor : Model -> String -> Model
setEditedSnakeAuthor model author =
    case model.editedSnake of
        Just snake ->
            let
                updatedSnake =
                    setSnakeAuthor snake author
            in
            { model | editedSnake = Just updatedSnake, data = List.map (saveSnake updatedSnake) model.data }

        Nothing ->
            model


setEditedScaleDetails : Model -> String -> Model
setEditedScaleDetails model details =
    case model.editedScale of
        Just snakeScale ->
            updateEditedScale model (ToilSnakeScale snakeScale.snake (setScaleDetails snakeScale.scale details))

        Nothing ->
            model


setScaleDetails : Scale -> String -> Scale
setScaleDetails scale newDetails =
    { scale | details = newDetails }


setEditedScaleAuthor : Model -> String -> Model
setEditedScaleAuthor model author =
    case model.editedScale of
        Just snakeScale ->
            updateEditedScale model (ToilSnakeScale snakeScale.snake (setScaleAuthor snakeScale.scale author))

        Nothing ->
            model


updateEditedScale : Model -> ToilSnakeScale -> Model
updateEditedScale model updatedScale =
    { model
        | editedScale = Just updatedScale
        , data = List.map (saveSnakeScale updatedScale.snake updatedScale.scale) model.data
    }


setScaleAuthor : Scale -> String -> Scale
setScaleAuthor scale newAuthor =
    { scale | author = newAuthor }


saveSnake : ToilSnake -> ToilSnake -> ToilSnake
saveSnake editedSnake someSnake =
    if editedSnake.id == someSnake.id then
        editedSnake

    else
        someSnake


saveSnakeScale : ToilSnake -> Scale -> ToilSnake -> ToilSnake
saveSnakeScale theSnake theScale aSnake =
    if aSnake.id == theSnake.id then
        { aSnake | scales = List.map (saveScale theScale) aSnake.scales }

    else
        aSnake


saveScale : Scale -> Scale -> Scale
saveScale theScale aScale =
    if theScale.id == aScale.id then
        theScale

    else
        aScale
