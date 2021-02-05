open Belt
open TW

%%raw(`require("tailwindcss/dist/tailwind.min.css")`)

let listToReactArray = xs => xs->Belt.List.toArray->React.array

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

module Indices = {
  @decco type indices = list<string>

  let decode = (json: Js.Json.t): Result.t<indices, string> =>
    switch json->indices_decode {
    | Ok(data) => data->Ok
    | Error(err) => ("Decoding Error: " ++ err.message)->Error
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
    | NotAsked
    | Loading(_) => React.null
    | Success(data) => <p> {"Success"->React.string} </p>
    | Failure(_) => <p> {"Unable to load the indices"->React.string} </p>
    }
  }
}

let tw = (styles: array<TW.t>) => styles->Belt.List.fromArray->make

// <Indices hook=API.Hook.useGet />
module Example = {
  @react.component
  let make = () => {
    <div className={[Display(Flex), BackgroundColor(BgRed500), TextColor(TextYellow300)]->tw}>
      <p>{"Hello Example"->React.string}</p>
    </div>;
  }
}

module Main = (Fetcher: Http.Fetcher) => {
  module API = RemoteApi.API(Http.BsFetch)

  @react.component
  let make = () => {
    <Example />
  }
}
