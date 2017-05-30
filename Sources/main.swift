import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import SQLiteStORM

let connect = SQLiteConnect("./projectdb")
//
//let projects = Project(connect)
//let lines = Line(connect)
//let users = User(connect)
//SQLiteConnector.db = "./projectsdb"

let projectSetup = Project(connect)
try? projectSetup.setup()

let userSetup = User(connect)
try? userSetup.setup()

let lineSetup = Line(connect)
try? lineSetup.setup()

let server = HTTPServer()
server.serverPort = 8080
server.documentRoot = "webroot"

var routes = Routes()
routes.add(method: .get, uri: "/", handler: {
  request, response in
  response.setBody(string: "Hello, Perfect!")
  .completed()
})

routes.add(method: .post, uri: "/saveProject", handler: saveProject)
routes.add(method: .post, uri: "/saveUser", handler: saveUser)
routes.add(method: .get, uri: "/getProjects", handler: getProjects)
routes.add(method: .get, uri: "/getUsers", handler: getUsers)

server.addRoutes(routes)

do {
  try server.start()
} catch PerfectError.networkError(let err, let msg) {
  print("Network error thrown: \(err) \(msg)")
}
