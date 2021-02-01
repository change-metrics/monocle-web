open MaterialUi
open Belt

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
    | Success(data) => {
        Js.log(data)
        <p> {"Success"->React.string} </p>
      }
    | Failure(_) => <p> {"Failure loading report"->React.string} </p>
    }
  }
}

module Main = (Fetcher: Http.Fetcher) => {
  module API = RemoteApi.API(Http.BsFetch)

  @react.component
  let make = () => {
    <Container>
      <Grid container=true>
        <Grid item=true>
          <Typography variant=#H3 gutterBottom=true> {"Monocle Web"->React.string} </Typography>
        </Grid>
        <Grid> <Indices hook=API.Hook.useGet /> </Grid>
      </Grid>
    </Container>
  }
}
