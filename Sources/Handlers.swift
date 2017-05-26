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

func sendProject(request: HTTPRequest, _ response: HTTPResponse)
{
  response.setHeader(.contentType, value: "application/json")
  var responseDictionary = [String: String]()
  
  let json = JSON(request.postBodyString!)
  
  let params = request.postParams
  print(params)
  guard let projectUUID = json["projectUUID"].string,
    let name = json["name"].string,
    let users = json["users"].array,
    let lines = json["lines"].array
    else
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
  
  let project = Project(connect)
  
  project.projectUUID = projectUUID
  project.name = name
  
  //  project.users = users
  //  project.lines = lines
  //  if let usersArray = users.
  //  {
  var usersArray = [User]()
  for userDict in users
  {
    usersArray
    let user = User.init(userDictionary: userDict)
    users.append(user)
  }
  project.users = users
  //  }
  
  //  if let linesArray = lines as? [[String: Any]] {
  //    var lines = [Line]()
  //    for lineDict in linesArray {
  //      // make line object
  //    }
  //    project.lines = lines
  //  }
  
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

