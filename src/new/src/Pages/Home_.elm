module Pages.Home_ exposing (view)

import Element
import View exposing (View)


view : View msg
view =
    { title = "Homepage"
    , body = [ Element.text "Hello, world!" ]
    }
