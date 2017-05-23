import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import SQLiteStORM

let connect = SQLiteConnect("./pointsdb")
let scores = Point(connect)
scores.setup()

let server = HTTPServer()
server.serverPort = 8080
server.documentRoot = "webroot"

var routes = Routes()
routes.add(method: .get, uri: "/", handler: {
  request, response in
  response.setBody(string: "Hello, Perfect!")
  .completed()
})

func returnJSON(message: String, response: HTTPResponse) {
  do {
    try response.setBody(json: ["message": message])
    .setHeader(.contentType, value: "application/json")
    .completed()
  } catch {
    response.setBody(string: "Error handling request: \(error)")
      .completed(status: .internalServerError)
  }
}

routes.add(method: .get, uri: "/hello", handler: {
  request, response in
  returnJSON(message: "Hello, JSON!", response: response)
})

routes.add(method: .post, uri: "post", handler: {
  request, response in
  guard let name = request.param(name: "name") else {
    response.completed(status: .badRequest)
    return
  }
  returnJSON(message: "Hello \(name)", response: response)
})

routes.add(method: .post, uri: "/saveStartingPoint", handler: saveStartingPoint)
routes.add(method: .post, uri: "/saveEndingPoint", handler: saveEndingPoint)

routes.add(method: .get, uri: "/getStartingPoint", handler: getStartingPoint)
routes.add(method: .get, uri: "/getEndingPoint", handler: getEndingPoint)

server.addRoutes(routes)

do {
  try server.start()
} catch PerfectError.networkError(let err, let msg) {
  print("Network error thrown: \(err) \(msg)")
}
