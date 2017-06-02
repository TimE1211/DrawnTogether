import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import SQLiteStORM

SQLiteConnector.db = "./projectsdb"

let project = Project()
try? project.setup()

let user = User()
try? user.setup()

let line = Line()
try? line.setup()

let server = HTTPServer()
server.serverPort = 8080
server.documentRoot = "webroot"

var routes = Routes()
routes.add(method: .get, uri: "/", handler: {
  request, response in
  response.setBody(string: "Hello, Perfect!")
  .completed()
})

routes.add(method: .post, uri: "/createProject", handler: createProject)
routes.add(method: .post, uri: "/updateProject", handler: updateProject)
routes.add(method: .post, uri: "/saveUser", handler: saveUser)
routes.add(method: .get, uri: "/getProjects", handler: getProjects)
routes.add(method: .get, uri: "/getUsers", handler: getUsers)

server.addRoutes(routes)

do {
  try server.start()
} catch PerfectError.networkError(let err, let msg) {
  print("Network error thrown: \(err) \(msg)")
}

