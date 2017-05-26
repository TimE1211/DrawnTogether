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
import SwiftyJSON

func saveProject(request: HTTPRequest, _ response: HTTPResponse)
{
  response.setHeader(.contentType, value: "application/json")
  var responseDictionary = [String: String]()
  
  let json = JSON(request.postBodyString!)
  print(json)
  
  let params = request.postParams
  print(params)
  guard let projectUUID = json["projectUUID"].string,
    let name = json["name"].string,
    let user1 = json["user1"].string,
    let user2 = json["user2"].string,
    let lines = json["lines"].array else {
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
  
  let project = Project(connect)
  
  project.projectUUID = projectUUID
  project.name = name
  project.user1 = user1
  project.user2 = user2
  
  var linesArray = [Line]()
  for lineDict in lines
  {
    let line = Line()
    line.Dictionary(lineDictionary: lineDict.dictionary!)
    linesArray.append(line)
  }
  project.lines = linesArray

  do {
    try project.save()
    responseDictionary["error"] = "Project saved."
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

func getProject(request: HTTPRequest, _ response: HTTPResponse)
{
  response.setHeader(.contentType, value: "application/json")
  
  let getObj = Project(connect)
  
  do {
    try getObj.findAll()
    let projects = getObj.rows().map{ $0.asDictionary()}
    try response.setBody(json: projects)
      .completed()
  } catch
  {
    print("Couldnt save responseDictionary: \(error)")
    response.setBody(string: "Couldnt save responseDictionary: \(error)")
      .completed(status: .internalServerError)
  }
}

func saveLine(request: HTTPRequest, _ response: HTTPResponse)
{
  response.setHeader(.contentType, value: "application/json")
  var responseDictionary = [String: String]()
  guard let startx = request.param(name: "startx"),
    let starty = request.param(name: "starty"),
    let endx = request.param(name: "endx"),
    let endy = request.param(name: "endy") else {
    response.status = .badRequest
    responseDictionary["error"] = "Please supply values"
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
    response.completed()
  }
}

func saveUser(request: HTTPRequest, _ response: HTTPResponse)
{
  
}

func getUser(request: HTTPRequest, _ response: HTTPResponse)
{
  
}
