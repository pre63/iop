module Pages.{{module}} exposing (Model, Msg, page)

import Effect exposing (Effect)
import Iop.Gen.Params.{{module}} exposing (Params)
import Page
import Request
import Shared
import View exposing (View)
import Page
import Auth


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.protected.access
        (\user ->
            { init = init user req.params
            , update = update
            , view = view
            , layout = layout
            , access = Nothing
            , subscriptions = subscriptions
            }
        )


layout : (Model -> View Msg) -> Model -> View Msg
layout toView model_ =
    toView model_


-- INIT


type alias Model =
    { user : Auth.User
    , params : Params
    }


init : Auth.User -> Params -> ( Model, Effect Msg )
init user params =
    ( { user = user
      , params = params
      }
    , Effect.none
    )


-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    View.placeholder "{{module}}"
