%%raw(`import './index.css';`)

module Root = {
  type t
  @send external render: (t, React.element) => unit = "render"
  @send external unmount: (t, unit) => unit = "unmount"
}
@module("react-dom/client") external createRoot: Dom.element => Root.t = "createRoot"

type document
@send external getElementById: (document, string) => Dom.element = "getElementById"
@val external doc: document = "document"

let rootElement = getElementById(doc, "root")
let root = createRoot(rootElement)

Root.render(root, <App />)
