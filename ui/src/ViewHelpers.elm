module ViewHelpers exposing (dateDiff)

import Time exposing (Posix, posixToMillis)


dateDiff : Posix -> Posix -> String
dateDiff current compared =
    let
        timeDiff =
            (posixToMillis current - posixToMillis compared) // 1000
    in
    if timeDiff < 0 then
        "not happened yet"

    else if timeDiff < 60 then
        "just now"

    else if timeDiff < 3600 then
        String.fromInt (timeDiff // 60) ++ "m ago"

    else if timeDiff < 86400 then
        String.fromInt (timeDiff // (60 * 60)) ++ "h ago"

    else if timeDiff < 604800 then
        String.fromInt (timeDiff // (60 * 60 * 24)) ++ "d ago"

    else if timeDiff < 2592000 then
        String.fromInt (timeDiff // (60 * 60 * 24 * 7)) ++ "w ago"

    else if timeDiff < 31536000 then
        String.fromInt (timeDiff // (60 * 60 * 24 * 30)) ++ "mth ago"

    else
        String.fromInt (timeDiff // (60 * 60 * 24 * 365)) ++ "y ago"
