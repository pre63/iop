export default (): string => `
module Request exposing
    ( Request, With
    , create
    , pushRoute, replaceRoute
    )

{-|

@docs Request, With
@docs create
@docs pushRoute, replaceRoute

-}

import Browser.Navigation exposing (Key)
import Iop.Request as Iop
import Gen.Route as Route exposing (Route)
import Url exposing (Url)


type alias Request =
    With ()


type alias With params =
    Iop.Request Route params


create : params -> Url -> Key -> With params
create params url key =
    Iop.create (Route.fromUrl url) params url key


pushRoute : Route -> With params -> Cmd msg
pushRoute route req =
    Browser.Navigation.pushUrl req.key (Route.toHref route)


replaceRoute : Route -> With params -> Cmd msg
replaceRoute route req =
    Browser.Navigation.replaceUrl req.key (Route.toHref route)

`.trimLeft()