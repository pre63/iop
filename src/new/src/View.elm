module View exposing (View, bmap, map, none, toBrowserDocument, placeholder)

import Browser
import Element exposing (Element, fill, height, text, width, column)


type alias View msg =
    { title : String
    , body : List (Element msg)
    }


placeholder : String -> View msg
placeholder txt =
    { title = txt
    , body = [ text txt ]
    }


none : View msg
none =
    placeholder ""


map : (msg -> msg1) -> View msg -> View msg1
map fn view =
    { title = view.title
    , body = List.map (Element.map fn) view.body
    }


bmap : (List (Element msg) -> List (Element msg)) -> View msg -> View msg
bmap fn view =
    { title = view.title
    , body = fn view.body
    }


toBrowserDocument : View msg -> Browser.Document msg
toBrowserDocument view =
    { title = view.title
    , body = [Element.layout [ width fill, height fill ] <| column [ width fill, height fill ] view.body]
    }
