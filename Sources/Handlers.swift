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
  
  guard let dataFromString = request.postBodyString?.data(using: .utf8, allowLossyConversion: false) else { return }
  let json = JSON(data: dataFromString)
  
  print(json)
  
  guard let projectUUID = json["projectUUID"].string,
    let projectName = json["projectName"].string,
    let users = json["users"].array,
    let lines = json["lines"].array else
  {
    response.status = .badRequest
    responseDictionary["error"] = "Please supply project values"
    print(responseDictionary["error"]!)
    do {
      try response.setBody(json: responseDictionary)
    }catch
    {
      print("JSON submission Error: \(error)")
    }
    response.completed()
    return
  }
  
  let aProject = Project(connect)
  
  aProject.projectUUID = projectUUID
  aProject.projectName = projectName
  
//  var usersArray = [User]()
//  for userDict in users
//  {
//    let user = User()
//    user.asDictionaryFrom(userDictionary: userDict.dictionary!)
//    usersArray.append(user)
//  }
//  aProject._users = usersArray
//  
//  var linesArray = [Line]()
//  for lineDict in lines
//  {
//    let line = Line()
//    line.asDictionaryFrom(lineDictionary: lineDict.dictionary!)
//    linesArray.append(line)
//  }
//  aProject._lines = linesArray
  
  do {
    try aProject.save()
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

func saveUser(request: HTTPRequest, _ response: HTTPResponse)
{
  response.setHeader(.contentType, value: "application/json")
  var responseDictionary = [String: String]()
  
  guard let dataFromString = request.postBodyString?.data(using: .utf8, allowLossyConversion: false) else { return }
    let json = JSON(data: dataFromString)
  
  print(json)
  
  guard let username = json["username"].string,
    let password = json["password"].string else
  {
    response.status = .badRequest
    responseDictionary["error"] = "Please supply user values"
    print(responseDictionary["error"]!)
    do {
      try response.setBody(json: responseDictionary)
    }catch
    {
      print("JSON submission Error: \(error)")
    }
    response.completed()
    return
  }
  
  user.username = username
  user.password = password
  do {
    try user.save()
    responseDictionary["error"] = "User saved."
    print("responseDict: \(responseDictionary["error"]!)")
    response.completed()
  } catch
  {
    responseDictionary["error"] = "Couldn't save User \(error)."
    response.completed()
  }
}

func getProjects(request: HTTPRequest, _ response: HTTPResponse)
{
  response.setHeader(.contentType, value: "application/json")
  
  do {
    try project.findAll()
    let projects = project.rows().map{ $0.asDictionary()}
    try response.setBody(json: projects)
      .completed()
  } catch
  {
    print("Couldnt set response Body for projects: \(error)")
    response.setBody(string: "Couldnt get responseDictionary: \(error)")
      .completed(status: .internalServerError)
  }
}

func getUsers(request: HTTPRequest, _ response: HTTPResponse)
{
  response.setHeader(.contentType, value: "application/json")
  
  do {
    try user.findAll()
//    try getObj.get(user.username)
    let users = user.rows().map{ $0.asDictionary()}
    print(users)
    try response.setBody(json: users)
      .completed()
  } catch
  {
    print("Couldnt set response Body for users: \(error)")
    response.setBody(string: "Couldnt get responseDictionary: \(error)")
      .completed(status: .internalServerError)
  }
}

