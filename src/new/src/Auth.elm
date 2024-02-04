module Auth exposing
    ( User
    , beforeProtectedInit
    , init
    )

{-|

@docs User
@docs beforeProtectedInit

-}

import Iop.Auth as Auth
import Iop.Gen.Route exposing (Route)
import Iop.Page as Iop
import Request exposing (Request)
import Shared


{-| Replace the "()" with your actual User type
-}
type alias User =
    Auth.User


{-| This function will run before any `protected` pages.

Here, you can provide logic on where to redirect if a user is not signed in. Here's an example:

    case shared.user of
        Just user ->
            Iop.Provide user

        Nothing ->
            Iop.RedirectTo Iop.Gen.Route.SignIn

-}
beforeProtectedInit : Shared.Model -> Request -> Iop.Protected User Route
beforeProtectedInit shared req =
    Iop.RedirectTo Iop.Gen.Route.NotFound


init : Maybe a -> User -> Iop.Protected User Iop.Gen.Route.Route
init access user =
    case access of
        Just _ ->
            Iop.Provide user

        Nothing ->
            Iop.RedirectTo Iop.Gen.Route.NotFound
