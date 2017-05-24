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
import Foundation

func sendLine(request: HTTPRequest, _ response: HTTPResponse)
{
  response.setHeader(.contentType, value: "application/json")
  var responseDictionary = [String: String]()
  
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
      print("JSON submission Error: \(error)")
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
    print(responseDictionary["error"]!)
  } catch
  {
    print("Saving Error: \(error)")
    responseDictionary["error"] = String(describing: error)
  }
  
  do {
    try response.setBody(json: responseDictionary)
  } catch
  {
    print("Response Error: \(error)")
  }
  response.completed()
}

func getLine(request: HTTPRequest, _ response: HTTPResponse)
{
  response.setHeader(.contentType, value: "application/json")
  
//  var responseDictionary = [String: Any]()
  
  let getObj = Line(connect)    //changed line to getObj

  //let cursor = StORMCursor(limit: 10, offset: 0)
//
//  do {
//    try //lines.select(columns: ["startx", "starty","endx","endy"], whereclause: "line > :1", params: [0], orderby: ["line DESC"], cursor: cursor)
//    lines.select(columns: ["startx", "starty", "endx", "endy"], whereclause: "line > :1", params: [0], orderby: ["line DESC"])
//    var resultArray = [[String: Any]]()
//    
//    for row in lines.rows()
//    {
//      var aLineDictionary = [String: Any]()
//      aLineDictionary["startx"] = row.startx
//      aLineDictionary["starty"] = row.starty
//      aLineDictionary["endx"] = row.endx
//      aLineDictionary["endy"] = row.endy
//      resultArray.append(aLineDictionary)
//    }
//    
//    responseDictionary["lines"] = resultArray
//  } catch
//  {
//    print("Couldnt set JSON Dictionary correctly: \(error)")
//  }
//  
  do {
//    new here
    try getObj.findAll()
    var lines: [[String: Any]] = []
    for row in getObj.rows()
    {
      lines.append(row.asDictionary())
    }
//    old here
    try response.setBody(json: lines)
      .completed()
  } catch
  {
    print("Couldnt send responseDictionary: \(error)")
    response.setBody(string: "Couldnt send responseDictionary: \(error)")
      .completed(status: .internalServerError)
  }
  
}

