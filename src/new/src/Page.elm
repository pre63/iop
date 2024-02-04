module Page exposing
    ( Page, With
    , static, sandbox, element, advanced
    , protected
    , layout
    )

{-|

@docs Page, With
@docs static, sandbox, element, advanced
@docs protected

-}

import Auth exposing (User)
import Effect exposing (Effect)
import Iop.Gen.Route exposing (Route)
import Iop.Page as Iop
import Request exposing (Request)
import Shared
import View exposing (View)



-- PAGES


type alias Page =
    With () Never


type alias With model msg =
    Iop.Page Shared.Model Route (Effect msg) (View msg) model msg


static :
    { view : View Never
    }
    -> Page
static =
    Iop.static Effect.none


sandbox :
    { init : model
    , update : msg -> model -> model
    , view : model -> View msg
    }
    -> With model msg
sandbox =
    Iop.sandbox Effect.none


element :
    { init : ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , view : model -> View msg
    , subscriptions : model -> Sub msg
    }
    -> With model msg
element =
    Iop.element Effect.fromCmd


advanced :
    { init : ( model, Effect msg )
    , update : msg -> model -> ( model, Effect msg )
    , view : model -> View msg
    , subscriptions : model -> Sub msg
    }
    -> With model msg
advanced =
    Iop.advanced


layout :
    { init : ( model, Effect msg )
    , update : msg -> model -> ( model, Effect msg )
    , view : model -> View msg
    , layout : (model -> View msg) -> model -> View msg
    , subscriptions : model -> Sub msg
    }
    -> With model msg
layout =
    Iop.layout



-- PROTECTED PAGES


protected :
    { static :
        (User
         ->
            { view : View msg
            }
        )
        -> With () msg
    , sandbox :
        (User
         ->
            { init : model
            , update : msg -> model -> model
            , view : model -> View msg
            }
        )
        -> With model msg
    , element :
        (User
         ->
            { init : ( model, Cmd msg )
            , update : msg -> model -> ( model, Cmd msg )
            , view : model -> View msg
            , subscriptions : model -> Sub msg
            }
        )
        -> With model msg
    , advanced :
        (User
         ->
            { init : ( model, Effect msg )
            , update : msg -> model -> ( model, Effect msg )
            , view : model -> View msg
            , subscriptions : model -> Sub msg
            }
        )
        -> With model msg
    , access :
        (User
         ->
            { init : ( model, Effect msg )
            , update : msg -> model -> ( model, Effect msg )
            , view : model -> View msg
            , layout : (model -> View msg) -> model -> View msg
            , access : Maybe ()
            , subscriptions : model -> Sub msg
            }
        )
        -> With model msg
    }
protected =
    Iop.protected
        { effectNone = Effect.none
        , fromCmd = Effect.fromCmd
        , beforeInit = Auth.beforeProtectedInit
        , init = Auth.init
        }
