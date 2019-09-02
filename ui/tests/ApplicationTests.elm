module ApplicationTests exposing (all)

import Expect
import Test exposing (..)


all : Test
all =
    describe "top level application"
        [ test "some stuff" <|
            \_ ->
                List.length []
                    |> Expect.equal 0
        ]
