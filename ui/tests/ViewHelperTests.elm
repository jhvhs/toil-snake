module ViewHelperTests exposing (all)

import ElmTestBDDStyle exposing (..)
import Expect exposing (..)
import Test exposing (..)
import Time exposing (millisToPosix)
import ViewHelpers exposing (dateDiff)


all : Test
all =
    describe "date diff display helper"
        [ it "is very close" <|
            expect (makeDiff 1) to equal "just now"
        , it "is over a minute" <|
            expect (makeDiff 75) to equal "1m ago"
        , it "is over an hour" <|
            expect (makeDiff 11000) to equal "3h ago"
        , it "is over a day" <|
            expect (makeDiff 90000) to equal "1d ago"
        , it "is over a week" <|
            expect (makeDiff 700000) to equal "1w ago"
        , it "is over a month" <|
            expect (makeDiff 4000000) to equal "1mth ago"
        , it "is over a year" <|
            expect (makeDiff 50000000) to equal "1y ago"
        , it "is a wrong order" <|
            expect (dateDiff (millisToPosix 0) (millisToPosix 653687)) to equal "not happened yet"
        ]


makeDiff : Int -> String
makeDiff sec =
    dateDiff (millisToPosix (sec * 1000)) (millisToPosix 0)
