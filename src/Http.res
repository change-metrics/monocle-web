module type Fetcher = {
  let fetch: string => Js.Promise.t<option<Js.Json.t>>
}

module BsFetch = {
  let raiseOnNok = (promise: Js.Promise.t<Fetch.Response.t>) => {
    promise |> Js.Promise.then_(r =>
      r |> Fetch.Response.ok ? promise : Js.Exn.raiseError(Fetch.Response.statusText(r))
    )
  }

  let promiseToOptionalJson = (promise: Js.Promise.t<Fetch.response>): Js.Promise.t<
    option<Js.Json.t>,
  > => {
    promise
    |> raiseOnNok
    |> Js.Promise.then_(Fetch.Response.json)
    |> Js.Promise.then_(v => v->Some->Js.Promise.resolve)
    |> Js.Promise.catch(e => {
      Js.log2("Unexpected error: ", e)
      None->Js.Promise.resolve
    })
  }

  let fetch = (url: string): Js.Promise.t<option<Js.Json.t>> => {
    Fetch.fetch(url) |> promiseToOptionalJson
  }
}
