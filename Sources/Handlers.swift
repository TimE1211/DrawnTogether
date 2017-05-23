//
//  Handlers.swift
//  DrawnTogether
//
//  Created by Timothy Hang on 5/23/17.
//
//

import PerfectHTTP
import SQLiteStORM
import StORM

func sendLine(request: HTTPRequest, _ response: HTTPResponse)
{
  response.setHeader(.contentType, value: "application/json")
  var responseDictionary = [String: String]()
  
  if let body = request.postBodyString
  {
    print(body)
  }
  guard let startx = request.param(name: "startx"),
    let starty = request.param(name: "starty"),
    let endx = request.param(name: "endx"),
    let endy = request.param(name: "endy") else
  {
    response.status = .badRequest
    responseDictionary["error"] = "Please supply values"
    
    do {
      try response.setBody(json: responseDictionary)
    }catch
    {
      print(error)
    }
    response.completed()
    return
  }
  
  let line = Line(connect)
  line.startx = startx
  line.starty = starty
  line.endx = endx
  line.endy = endy
  
  do {
    try line.save()
    responseDictionary["error"] = "Line saved."
  } catch
  {
    print(error)
    responseDictionary["error"] = String(describing: error)
  }
  
  do {
    try response.setBody(json: responseDictionary)
  } catch
  {
    print(error)
  }
  
  response.completed()
}

func getLine(request: HTTPRequest, _ response: HTTPResponse)
{
  response.setHeader(.contentType, value: "application/json")
  
  var responseDictionary = [String: Any]()
  
  let lines = Line(connect)
  let cursor = StORMCursor(limit: 10, offset: 0)
  
  do {
    try lines.select(columns: ["x", "y"], whereclause: "line > :1", params: [0], orderby: ["line DESC"], cursor: cursor)
    var resultArray = [[String: Any]]()
    
    for row in lines.rows()
    {
      var aPointDictionary = [String: Any]()
      aPointDictionary["startx"] = row.startx
      aPointDictionary["starty"] = row.starty
      aPointDictionary["endx"] = row.endx
      aPointDictionary["endy"] = row.endy
      resultArray.append(aPointDictionary)
    }
    
    responseDictionary["lines"] = resultArray
  } catch
  {
    print(error)
  }
  
  do {
    try response.setBody(json: responseDictionary)
  } catch
  {
    print(error)
  }
  response.completed()
}
