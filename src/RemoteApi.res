open Belt

type state_t<'a> = RemoteData.t<'a, option<'a>, string>

type json_t = Js.Json.t
type result_t<'a, 'b> = Result.t<'a, 'b>
type decode_t<'a, 'b> = result_t<'a, 'b>
type decoder_t<'a, 'b> = json_t => decode_t<'a, 'b>
// type response_t<'a> = result_t<'a, string>
type promise_t<'a> = Js.Promise.t<'a>
type gethook_t<'a> = (state_t<'a>, string => unit, unit => unit)

let note = (o: option<'a>, e: 'e): result_t<'a, 'e> =>
  switch o {
  | Some(v) => v->Ok
  | None => e->Error
  }

module API = (Fetcher: Http.Fetcher) => {
  let get = (url: string, decode: decoder_t<'a, 'b>, setState: state_t<'a> => unit) => {
    Loading(None)->setState
    open Js.Promise
    Fetcher.fetch(url) |> then_(json =>
      json
      ->note("Network Error")
      ->Result.flatMap(json => json->decode)
      ->(result =>
        switch result {
        | Ok(data) => Success(data)->setState
        | Error(err) => Failure(err)->setState
        })
      ->Ok
      ->resolve
    )
  }

  module Hook = {
    let useGet = (decoder: decoder_t<'a, 'b>): gethook_t<'a> => {
      let (state, setState) = React.useState(() => RemoteData.NotAsked)
      let set_state = s => setState(_prevState => s)
      let reset = () => NotAsked->set_state
      let dispatch = (url: string) => get(url, decoder, r => r->set_state)->ignore
      (state, dispatch, reset)
    }
  }
}
