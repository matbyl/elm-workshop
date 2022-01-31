## Elm-workshop
---

This is an elm-workshop that guides in create an elm application from scratch.

### Getting started

Setup:
```
nix-shell
npm i
```

Serve the application:
```
parcel serve src/index.html
```

## Workshop structure
  * Part 1 - [Bootstrapping](../../tree/001-bootstraping)
    * Make a minimal elm sandbox application using [Parcel](https://parceljs.org/languages/elm/)
  * Part 2 - [Application](../../tree/002-application)
    * Switch over to Browser.application instead of Browser.sandbox
  * Part 3 - [Session](../../tree/003-session)
    * Create a Session module and add it to the main model
  * Part 4 - [Pages](../../tree/004-pages)
    * Create a Page structure and page module (e.g. Page/Home.elm, Page/Pokedex.elm)
  * Part 5 - [Routing](../../tree/005-routing)
    * Add routing to the application and make it possible to navigate between pages
  * Part 6 - [Pokemon API](../../tree/006-pokemon-api)
    * Add the [Pokemon API](https://pokeapi.co/) to the application
  * Part 7 - [UI components](../../tree/007-ui-components)
    * Create reusable ui components (e.g. Navbar, Searchbar, Button, Link)
  * Part 8 - [Styling](../../tree/008-styling)
    * Add elm-css and make some basic styling to some of the components
