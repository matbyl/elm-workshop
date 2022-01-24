module Session exposing (..)

import Browser.Navigation as Navigation


type CatApiKey  = CatApiKey String

type alias Session = { navKey : Navigation.Key, catApiKey : CatApiKey }
