module ViewHelperTests exposing (all)

import Expect
import Test exposing (..)
import Time exposing (millisToPosix)
import ViewHelpers exposing (dateDiff)


all : Test
all =
    describe "date diff display helper"
        [ test "very close" <|
            \_ ->
                makeDiff 1
                    |> Expect.equal "just now"
        , test "over a minute" <|
            \_ ->
                makeDiff 75
                    |> Expect.equal "1m ago"
        , test "over an hour" <|
            \_ ->
                makeDiff 11000
                    |> Expect.equal "3h ago"
        , test "over a day" <|
            \_ ->
                makeDiff 90000
                    |> Expect.equal "1d ago"
        , test "over a week" <|
            \_ ->
                makeDiff 700000
                    |> Expect.equal "1w ago"
        , test "over a month" <|
            \_ ->
                makeDiff 4000000
                    |> Expect.equal "1mth ago"
        , test "over a year" <|
            \_ ->
                makeDiff 50000000
                    |> Expect.equal "1y ago"
        , test "wrong order" <|
            \_ ->
                dateDiff (millisToPosix 0) (millisToPosix 653687)
                    |> Expect.equal "not happened yet"
        ]


makeDiff : Int -> String
makeDiff sec =
    dateDiff (millisToPosix (sec * 1000)) (millisToPosix 0)
