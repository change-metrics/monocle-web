open Belt

let listToReactArray: list<React.element> => React.element = xs =>
  xs->Belt.List.toArray->React.array

let displayImg = (width: string, height, src: string, alt: string) => {
  <img
    src alt width height style={ReactDOM.Style.make(~marginLeft="5px", ~marginRight="5px", ())}
  />
}

module Asset = {
  // require binding does not support complex string manipulation
  @bs.val external require: string => string = "require"
  let asset = path => require("../assets/" ++ path)

  module Logo = {
    let getLogoImg = (size: string) => displayImg(size, size)
    let displayLogo = (src: string, alt: string, link: string, size: string) =>
      <a href=link> {getLogoImg(size, src, alt)} </a>
    let logo = name => asset("logos/" ++ name)
    let monocle = logo("monocle.png")

    @react.component
    let make = (~name: string, ~link: string) =>
      switch name {
      | "monocle" => displayLogo(monocle, "Monocle", link, "35")
      | _ => React.null
      }
  }
}

module Nav = {
  type t = {
    name: string,
    link: string,
  }

  @react.component
  let make = (~sections: list<t>, ~selected: option<string>) => {
    let makeLink = (section: t) => {
      let classes =
        section.name == selected->Belt.Option.getWithDefault("")
          ? "bg-gray-900 text-white"
          : "text-gray-300 hover:bg-gray-700 hover:text-white"
      <a
        href={section.link}
        className={classes ++ "bg-gray-900 text-white px-3 py-2 rounded-md text-sm font-medium"}>
        {section.name->React.string}
      </a>
    }
    <nav className="bg-gray-800">
      <div className="max-w-7xl mx-auto px-2 sm:px-6 lg:px-8">
        <div className="relative flex items-center justify-between h-16">
          <div
            className="flex-1 flex items-center justify-center sm:items-stretch sm:justify-start">
            <div className="hidden sm:block sm:ml-6">
              <div className="flex space-x-4">
                {sections->Belt.List.map(makeLink)->listToReactArray}
              </div>
            </div>
          </div>
        </div>
      </div>
    </nav>
  }
}

module Indices = {
  @decco type indices = list<string>

  let decode = (json: Js.Json.t): Result.t<indices, string> =>
    switch json->indices_decode {
    | Ok(data) => data->Ok
    | Error(err) => ("Decoding Error: " ++ err.message)->Error
    }

  let renderIndice = (x: string) => {
    <div
      className="p-6 max-w-sm mx-auto rounded-x1 show-md items-center bg-white flex space-x-4 hover:bg-yellow-100">
      {x->React.string}
    </div>
  }

  let render = (xs: indices) => {
    <ul> {xs->Belt.List.map(x => <li key={x}> {x->renderIndice} </li>)->listToReactArray} </ul>
  }

  @react.component
  let make = (~hook: RemoteApi.decoder_t<'a, 'b> => RemoteApi.gethook_t<'a>) => {
    let (state, cb, _) = hook(decode)
    let url = "indices.json"
    switch state {
    | NotAsked => cb(url)
    | _ => ()
    }
    switch state {
    | NotAsked | Loading(_) => React.null
    | Success(data) => render(data)
    | Failure(_) => <p> {"Unable to load the indices"->React.string} </p>
    }
  }
}

module Main = (Fetcher: Http.Fetcher) => {
  module API = RemoteApi.API(Fetcher)

  @react.component
  let make = () => {
    <React.Fragment>
      <Nav
        sections=list{{name: "Main", link: "/"}, {name: "People", link: "/people"}}
        selected=Some("Main")
      />
      <Indices hook=API.Hook.useGet />
    </React.Fragment>
  }
}
