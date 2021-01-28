// module RealApp = App.Main(Http.BsFetch);

switch ReactDOM.querySelector("#root") {
// | Some(root) => ReactDOM.render(<RealApp />, root)
| Some(root) => ReactDOM.render(<App.Main />, root)
| None => Js.log("Can't find #root element!")
}
