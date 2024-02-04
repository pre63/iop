
module Iop.Page exposing
    ( Page
    , Protected(..), protected
    , Bundle, bundle
    , Request, advanced, element, layout, sandbox, static
    )

{-|


# **Pages**

@docs Page


# **User Authentication**

@docs Protected, protected


# For generated code

@docs Bundle, bundle

-}

import Browser.Navigation exposing (Key)
import Iop.Request
import Url exposing (Url)



{-| Pages are the building blocks of **elm-spa**.

Instead of importing this module, your project will have a `Page` module with a much simpler type:

    module Page exposing (Page, ...)

    type Page model msg

This makes all the generic `route`, `effect`, and `view` arguments disappear!

-}
type Page shared route effect view model msg
    = Page (Internals shared route effect view model msg)


{-| A page that only needs to render a static view.

    import Page

    page : Page () Never
    page =
        Page.static
            { view = view
            }

    -- view : View Never

-}
static :
    effect
    ->
        { view : view
        }
    -> Page shared route effect view () msg
static none page =
    Page (\_ _ -> Ok (adapters.static none page))


{-| A page that can keep track of application state.

( Inspired by [`Browser.sandbox`](https://package.elm-lang.org/packages/elm/browser/latest/Browser#sandbox) )

    import Page

    page : Page Model Msg
    page =
        Page.sandbox
            { init = init
            , update = update
            , view = view
            }

    -- init : Model
    -- update : Msg -> Model -> Model
    -- view : Model -> View Msg

-}
sandbox :
    effect
    ->
        { init : model
        , update : msg -> model -> model
        , view : model -> view
        }
    -> Page shared route effect view model msg
sandbox none page =
    Page (\_ _ -> Ok (adapters.sandbox none page))


{-| A page that can handle effects like [HTTP requests or subscriptions](https://guide.elm-lang.org/effects/).

( Inspired by [`Browser.element`](https://package.elm-lang.org/packages/elm/browser/latest/Browser#element) )

    import Page

    page : Page Model Msg
    page =
        Page.element
            { init = init
            , update = update
            , view = view
            , subscriptions = subscriptions
            }

    -- init : ( Model, Cmd Msg )
    -- update : Msg -> Model -> ( Model, Cmd Msg )
    -- view : Model -> View Msg
    -- subscriptions : Model -> Sub Msg

-}
element :
    (Cmd msg -> effect)
    ->
        { init : ( model, Cmd msg )
        , update : msg -> model -> ( model, Cmd msg )
        , view : model -> view
        , subscriptions : model -> Sub msg
        }
    -> Page shared route effect view model msg
element fromCmd page =
    Page (\_ _ -> Ok (adapters.element fromCmd page))


{-| A page that can handles **custom** effects like sending a `Shared.Msg` or other general user-defined effects.

    import Effect
    import Page

    page : Page Model Msg
    page =
        Page.advanced
            { init = init
            , update = update
            , view = view
            , subscriptions = subscriptions
            }

    -- init : ( Model, Effect Msg )
    -- update : Msg -> Model -> ( Model, Effect Msg )
    -- view : Model -> View Msg
    -- subscriptions : Model -> Sub Msg

-}
advanced :
    { init : ( model, effect )
    , update : msg -> model -> ( model, effect )
    , view : model -> view
    , subscriptions : model -> Sub msg
    }
    -> Page shared route effect view model msg
advanced page =
    Page (\_ _ -> Ok (adapters.advanced page))




{-| A page that can handles **custom** effects like sending a 'Shared.Msg' or other general user-defined effects.

    import Effect
    import Page

    page : Page Model Msg
    page =
        Page.layout
            { init = init
            , update = update
            , view = view
            , layout = layout
            , subscriptions = subscriptions
            }

    -- init : ( Model, Effect Msg )
    -- update : Msg -> Model -> ( Model, Effect Msg )
    -- view : Model -> View Msg
    -- layout : (Model -> View Msg) -> Model -> View Msg
    -- subscriptions : Model -> Sub Msg

-}
layout :
    { init : ( model, effect )
    , update : msg -> model -> ( model, effect )
    , view : model -> view
    , layout : (model -> view) -> model -> view
    , subscriptions : model -> Sub msg
    }
    -> Page shared route effect view model msg
layout page =
    Page (\_ _ -> Ok (adapters.advanced <| applyLayout page))


applyLayout :
    { init : ( model, effect )
    , update : msg -> model -> ( model, effect )
    , view : model -> view
    , layout : (model -> view) -> model -> view
    , subscriptions : model -> Sub msg
    }
    ->
        { init : ( model, effect )
        , update : msg -> model -> ( model, effect )
        , view : model -> view
        , subscriptions : model -> Sub msg
        }
applyLayout ({ init, update, view,  subscriptions } as config) =
    { init = init
    , update = update
    , view = config.layout view
    , subscriptions = subscriptions
    }


{-| Actions to take when a user visits a 'protected' page

    import Iop.Gen.Route as Route exposing (Route)

    beforeProtectedInit : Shared.Model -> Request () -> Protected User Route
    beforeProtectedInit shared _ =
        case shared.user of
            Just user ->
                Provide user

            Nothing ->
                RedirectTo Route.SignIn

-}
type Protected user route
    = Provide user
    | RedirectTo route


{-| Prefixing any of the four functions above with 'protected' will guarantee that the page has access to a user. Here's an example with 'sandbox':

    -- before
    Page.sandbox
        { init = init
        , update = update
        , view = view
        }

    -- after
    Page.protected.sandbox
        (\user ->
            { init = init
            , update = update
            , view = view
            }
        )

    -- other functions have same API
    init : Model
    update : Msg -> Model -> Model
    view : Model -> View Msg

-}
protected :
    { effectNone : effect
    , fromCmd : Cmd msg -> effect
    , beforeInit : shared -> Request route () -> Protected user route
    , init : access -> user -> Protected user route
    }
    ->
        { static :
            (user
             ->
                { view : view
                }
            )
            -> Page shared route effect view () msg
        , sandbox :
            (user
             ->
                { init : model
                , update : msg -> model -> model
                , view : model -> view
                }
            )
            -> Page shared route effect view model msg
        , element :
            (user
             ->
                { init : ( model, Cmd msg )
                , update : msg -> model -> ( model, Cmd msg )
                , view : model -> view
                , subscriptions : model -> Sub msg
                }
            )
            -> Page shared route effect view model msg
        , advanced :
            (user
             ->
                { init : ( model, effect )
                , update : msg -> model -> ( model, effect )
                , view : model -> view
                , subscriptions : model -> Sub msg
                }
            )
            -> Page shared route effect view model msg
        , access :
            (user
             ->
                { init : ( model, effect )
                , update : msg -> model -> ( model, effect )
                , view : model -> view
                , layout : (model -> view) -> model -> view
                , access : access
                , subscriptions : model -> Sub msg
                }
            )
            -> Page shared route effect view model msg
        }
protected options =
    let
        protect toPage toRecord =
            Page
                (\shared req ->
                    case options.beforeInit shared req of
                        Provide user ->
                            Ok (user |> toRecord |> toPage)

                        RedirectTo route ->
                            Err route
                )
    in
    { static = protect (adapters.static options.effectNone)
    , sandbox = protect (adapters.sandbox options.effectNone)
    , element = protect (adapters.element options.fromCmd)
    , advanced = protect adapters.advanced
    , access = protectWithAccess options
    }


{-| Actions to take when a user visits a 'protected' page

    import Iop.Gen.Route as Route exposing (Route)

    beforeProtectedInit : Shared.Model -> Request () -> Protected User Route
    beforeProtectedInit shared _ =
        case shared.user of
            Just user ->
                Provide user

            Nothing ->
                RedirectTo Route.SignIn

-}
protectWithAccess :
    { effectNone : effect
    , fromCmd : Cmd msg -> effect
    , beforeInit : shared -> Request route () -> Protected user route
    , init : access -> user -> Protected user route
    }
    ->
        (user
         ->
            { init : ( model, effect )
            , update : msg -> model -> ( model, effect )
            , view : model -> view
            , layout : (model -> view) -> model -> view
            , access : access
            , subscriptions : model -> Sub msg
            }
        )
    -> Page shared route effect view model msg
protectWithAccess options =
    let
        protect toPage toRecord =
            Page
                (\shared req ->
                    case options.beforeInit shared req of
                        Provide user ->
                            let
                                rec =
                                    user |> toRecord
                            in
                            case options.init rec.access user of
                                Provide _ ->
                                    Ok <| (rec |> toPage)

                                RedirectTo route ->
                                    Err route

                        RedirectTo route ->
                            Err route
                )
    in
    protect (fromAccess >> adapters.advanced)


fromAccess :
    { init : ( model, effect )
    , update : msg -> model -> ( model, effect )
    , view : model -> view
    , layout : (model -> view) -> model -> view
    , access : access
    , subscriptions : model -> Sub msg
    }
    ->
        { init : ( model, effect )
        , update : msg -> model -> ( model, effect )
        , view : model -> view
        , subscriptions : model -> Sub msg
        }
fromAccess ({ init, update, view,  subscriptions } as config) =
    { init = init
    , update = update
    , view = config.layout view
    , subscriptions = subscriptions
    }



-- UPGRADING FOR GENERATED CODE


type alias Request route params =
    Iop.Request.Request route params


{-| A convenient function for use within generated code. Makes it easy to handle 'init', 'update', 'view', and 'subscriptions' for each page!
-}
type alias Bundle params model msg shared effect pagesModel pagesMsg pagesView =
    { init : params -> shared -> Url -> Key -> ( pagesModel, effect )
    , update : params -> msg -> model -> shared -> Url -> Key -> ( pagesModel, effect )
    , view : params -> model -> shared -> Url -> Key -> pagesView
    , subscriptions : params -> model -> shared -> Url -> Key -> Sub pagesMsg
    }


{-| This function is used by the generated code to connect your pages together.

It's big, spooky, and makes writing **iop** pages really nice!

-}
bundle :
    { redirecting : { model : pagesModel, view : pagesView }
    , toRoute : Url -> route
    , toUrl : route -> String
    , fromCmd : Cmd any -> pagesEffect
    , mapEffect : effect -> pagesEffect
    , mapView : view -> pagesView
    , page : shared -> Request route params -> Page shared route effect view model msg
    , toModel : params -> model -> pagesModel
    , toMsg : msg -> pagesMsg
    }
    -> Bundle params model msg shared pagesEffect pagesModel pagesMsg pagesView
bundle { redirecting, toRoute, toUrl, fromCmd, mapEffect, mapView, page, toModel, toMsg } =
    { init =
        \params shared url key ->
            let
                req =
                    Iop.Request.create (toRoute url) params url key
            in
            case toResult page shared req of
                Ok record ->
                    record.init ()
                        |> Tuple.mapBoth (toModel req.params) mapEffect

                Err route ->
                    ( redirecting.model, fromCmd <| Browser.Navigation.replaceUrl req.key (toUrl route) )
    , update =
        \params msg model shared url key ->
            let
                req =
                    Iop.Request.create (toRoute url) params url key
            in
            case toResult page shared req of
                Ok record ->
                    record.update msg model
                        |> Tuple.mapBoth (toModel req.params) mapEffect

                Err route ->
                    ( redirecting.model, fromCmd <| Browser.Navigation.replaceUrl req.key (toUrl route) )
    , view =
        \params model shared url key ->
            let
                req =
                    Iop.Request.create (toRoute url) params url key
            in
            case toResult page shared req of
                Ok record ->
                    record.view model
                        |> mapView

                Err _ ->
                    redirecting.view
    , subscriptions =
        \params model shared url key ->
            let
                req =
                    Iop.Request.create (toRoute url) params url key
            in
            case toResult page shared req of
                Ok record ->
                    record.subscriptions model
                        |> Sub.map toMsg

                Err _ ->
                    Sub.none
    }


toResult :
    (shared -> Request route params -> Page shared route effect view model msg)
    -> shared
    -> Request route params
    -> Result route (PageRecord effect view model msg)
toResult toPage shared req =
    let
        (Page toResult_) =
            toPage shared req
    in
    toResult_ shared (Iop.Request.create req.route () req.url req.key)



-- INTERNALS


type alias Internals shared route effect view model msg =
    shared -> Request route () -> Result route (PageRecord effect view model msg)


type alias PageRecord effect view model msg =
    { init : () -> ( model, effect )
    , update : msg -> model -> ( model, effect )
    , view : model -> view
    , subscriptions : model -> Sub msg
    }


adapters :
    { static :
        effect
        ->
            { view : view
            }
        -> PageRecord effect view () msg
    , sandbox :
        effect
        ->
            { init : model
            , update : msg -> model -> model
            , view : model -> view
            }
        -> PageRecord effect view model msg
    , element :
        (Cmd msg -> effect)
        ->
            { init : ( model, Cmd msg )
            , update : msg -> model -> ( model, Cmd msg )
            , view : model -> view
            , subscriptions : model -> Sub msg
            }
        -> PageRecord effect view model msg
    , advanced :
        { init : ( model, effect )
        , update : msg -> model -> ( model, effect )
        , view : model -> view
        , subscriptions : model -> Sub msg
        }
        -> PageRecord effect view model msg
    }
adapters =
    { static =
        \none page ->
            { init = \_ -> ( (), none )
            , update = \_ _ -> ( (), none )
            , view = \_ -> page.view
            , subscriptions = \_ -> Sub.none
            }
    , sandbox =
        \none page ->
            { init = \_ -> ( page.init, none )
            , update = \msg model -> ( page.update msg model, none )
            , view = page.view
            , subscriptions = \_ -> Sub.none
            }
    , element =
        \fromCmd page ->
            { init = \_ -> page.init |> Tuple.mapSecond fromCmd
            , update = \msg model -> page.update msg model |> Tuple.mapSecond fromCmd
            , view = page.view
            , subscriptions = page.subscriptions
            }
    , advanced =
        \page ->
            { init = always page.init
            , update = page.update
            , view = page.view
            , subscriptions = page.subscriptions
            }
    }
