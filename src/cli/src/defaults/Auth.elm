module Auth exposing
    ( User
    , beforeProtectedInit
    )

{-|

@docs User
@docs beforeProtectedInit

-}

import Iop.Page as Iop
import Gen.Route exposing (Route)
import Request exposing (Request)
import Shared


{-| Replace the "()" with your actual User type
-}
type alias User =
    ()


{-| This function will run before any `protected` pages.

Here, you can provide logic on where to redirect if a user is not signed in. Here's an example:

    case shared.user of
        Just user ->
            Iop.Provide user

        Nothing ->
            Iop.RedirectTo Gen.Route.SignIn

-}
beforeProtectedInit : Shared.Model -> Request -> Iop.Protected User Route
beforeProtectedInit shared req =
    Iop.RedirectTo Gen.Route.NotFound
