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

func sendProject(request: HTTPRequest, _ response: HTTPResponse)
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
  
  let project = Line(connect)
  project.startx = startx
  project.starty = starty
  project.endx = endx
  project.endy = endy
  
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
  
  let getObj = Line(connect)

  do {
    try getObj.findAll()
    
    let projects = getObj.rows().map {
      $0.asDictionary()
    }
    
    try response.setBody(json: projects)
      .completed()
  } catch
  {
    print("Couldnt send responseDictionary: \(error)")
    response.setBody(string: "Couldnt send responseDictionary: \(error)")
      .completed(status: .internalServerError)
  }
}

func sendUser(request: HTTPRequest, _ response: HTTPResponse)
{
  
}

func getUser(request: HTTPRequest, _ response: HTTPResponse)
{
  
}

