import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import SQLiteStORM

//let connect = SQLiteConnect("./projectsdb")
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

func test(request: HTTPRequest, response: HTTPResponse)
{
  do {
    let project1 = Project()
    project1.projectName = "Joe"
    project1._lines = []
    project1._users = []
    try project1.save() { projectUUID in
      project1.projectUUID = projectUUID as! String
    }

  let testProject = Project()
  try testProject.findAll()
  let projects = testProject.rows().map{ $0.asDictionary()}
  try response.setBody(json: projects)
    .setHeader(.contentType, value: "application/json")
    .completed()
  } catch
  {
    print("Couldnt set response Body for projects: \(error)")
    response.setBody(string: "Couldnt get responseDictionary: \(error)")
      .completed(status: .internalServerError)
  }
}

//routes.add(method: .post, uri: "/saveProject", handler: saveProject)
//routes.add(method: .post, uri: "/saveUser", handler: saveUser)
//routes.add(method: .get, uri: "/getProjects", handler: getProjects)
//routes.add(method: .get, uri: "/getUsers", handler: getUsers)
routes.add(method: .get, uri: "/test", handler: test)

server.addRoutes(routes)

do {
  try server.start()
} catch PerfectError.networkError(let err, let msg) {
  print("Network error thrown: \(err) \(msg)")
}

