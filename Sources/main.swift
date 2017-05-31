import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import SQLiteStORM

//let connect = SQLiteConnect("./projectdb")
//let projects = Project(connect)
//let lines = Line(connect)
//let users = User(connect)

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

routes.add(method: .post, uri: "/saveProject", handler: saveProject)
routes.add(method: .post, uri: "/saveUser", handler: saveUser)
routes.add(method: .get, uri: "/getProjects", handler: getProjects)
routes.add(method: .get, uri: "/getUsers", handler: getUsers)

server.addRoutes(routes)

//let userTest = User()
//do {
//  try userTest.get(userSetup.username)
//} catch {
//  print("gameTest.get error: \(error)")
//}
//print("username: \(userTest.username)")
//print("password: \(userTest.password)")
//userTest._projectUUIDs.forEach{
//  projectUUID in
//  print("projectUUID: \(project.name), \(project.projectUUID)")
//}

do {
  try server.start()
} catch PerfectError.networkError(let err, let msg) {
  print("Network error thrown: \(err) \(msg)")
}
