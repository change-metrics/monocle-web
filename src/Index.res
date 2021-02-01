module RealApp = App.Main(Http.BsFetch)

switch ReactDOM.querySelector("#root") {
| Some(root) => ReactDOM.render(<RealApp />, root)
| None => Js.log("Can't find #root element!")
}
