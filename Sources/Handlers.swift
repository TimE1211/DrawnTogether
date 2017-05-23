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

func savePoint(request: HTTPRequest, _ response: HTTPResponse)
{
  response.setHeader(.contentType, value: "application/json")
  var responseDictionary = [String: String]()
  
  guard let xValue = Int(request.param(name: "x")!),
    let yValue = Int(request.param(name: "y")!) else
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
  
  let point = Point(connect)
  point.x = xValue
  point.y = yValue
  
  do {
    try point.save()
    responseDictionary["error"] = "Point saved."
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

func getPoint(request: HTTPRequest, _ response: HTTPResponse)
{
  response.setHeader(.contentType, value: "application/json")
  
  var responseDictionary = [String: Any]()
  
  let points = Point(connect)
  let cursor = StORMCursor(limit: 10, offset: 0)
  
  do {
    try points.select(columns: ["x", "y"], whereclause: "point > :1", params: [0], orderby: ["point DESC"], cursor: cursor)
    var resultArray = [[String: Any]]()
    
    for row in points.rows()
    {
      var aPointDictionary = [String: Any]()
      aPointDictionary["x"] = row.x
      aPointDictionary["y"] = row.y
      resultArray.append(aPointDictionary)
    }
    
    responseDictionary["points"] = resultArray
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
