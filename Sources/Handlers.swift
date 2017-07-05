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

func createProject(request: HTTPRequest, _ response: HTTPResponse)
{
  response.setHeader(.contentType, value: "application/json")
  var responseDictionary = [String: String]()
  
  guard let dataFromString = request.postBodyString?.data(using: .utf8, allowLossyConversion: false) else { return }
  let json = JSON(data: dataFromString)
  
  print(json)
  
  guard
    let projectName = json["projectName"].string,
    let user1Id = json["user1Id"].int,
    let user2Id = json["user2Id"].int,
    let _ = json["lines"].array else
  {
    response.status = .badRequest
    responseDictionary["error"] = "Please supply project values"
    print(responseDictionary["error"]!)
    do {
      try response.setBody(json: responseDictionary)
    }catch
    {
      print("Project JSON submission Error: \(error)")
    }
    response.completed()
    return
  }
  
  let aProject = Project()
  
  aProject.projectName = projectName
  aProject.user1Id = user1Id
  aProject.user2Id = user2Id
  aProject.lines = []
  
  do {
    try aProject.save() { id in
      aProject.id = id as! Int
    }
    responseDictionary["error"] = "Project saved."
    
    for (key, value) in aProject.asDictionary()
    {
      responseDictionary[key] = "\(value)"
    }
    print(responseDictionary["error"]!)
  } catch
  {
    responseDictionary["error"] = "Project could not be saved: \(error)"
    print(responseDictionary["error"]!)
  }
  
  do {
    try response.setBody(json: responseDictionary)
      .setHeader(.contentType, value: "application/json")
      .completed()
  } catch {
    print("Couldnt set response Body for projects: \(error)")
    response.setBody(string: "Couldnt get responseDictionary: \(error)")
      .completed(status: .internalServerError)
  }
}

func saveUser(request: HTTPRequest, _ response: HTTPResponse)
{
  response.setHeader(.contentType, value: "application/json")
  var responseDictionary = [String: String]()
  
  print(request.postBodyString ?? "no params")
  
  guard let dataFromString = request.postBodyString?.data(using: .utf8, allowLossyConversion: false) else { return }
  let json = JSON(data: dataFromString)
  
  print(dataFromString)
  
  guard let username = json["username"].string,
    let password = json["password"].string else
  {
    response.status = .badRequest
    responseDictionary["error"] = "Please supply user values"
    print(responseDictionary["error"] ?? "user value incorrect")
    do {
      try response.setBody(json: responseDictionary)
    }catch
    {
      print("User JSON submission Error: \(error)")
    }
    response.completed()
    return
  }
  let aUser = User()
  
  aUser.username = username
  aUser.password = password
  do {
    try aUser.save() { id in
      aUser.id = id as! Int
    }
    responseDictionary["error"] = "User saved."
    
    for (key, value) in aUser.asDictionary()
    {
      responseDictionary[key] = "\(value)"
    }
  } catch
  {
    responseDictionary["error"] = "Couldn't save User \(error)."
    print("responseDict: \(responseDictionary["error"] ?? "user not saved")")
  }
  do {
    try response.setBody(json: responseDictionary)
    .setHeader(.contentType, value: "application/json")
    .completed()
  } catch {
    print("Couldnt set response Body for users: \(error)")
    response.setBody(string: "Couldnt get responseDictionary: \(error)")
      .completed(status: .internalServerError)
  }
}

func getProjects(request: HTTPRequest, _ response: HTTPResponse)
{
  response.setHeader(.contentType, value: "application/json")
  
  let aProject = Project()
  
  do {
    try aProject.findAll()
    let projects = aProject.rows().map{ $0.asDictionary() }
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

func getAProject(request: HTTPRequest, _ response: HTTPResponse)
{
  response.setHeader(.contentType, value: "application/json")
  var responseDictionary = [String: String]()

  guard let dataFromString = request.postBodyString?.data(using: .utf8, allowLossyConversion: false) else { return }
  let json = JSON(data: dataFromString)

  print(json)

  guard let projectId = json["id"].int else
  {
    response.status = .badRequest
    responseDictionary["error"] = "Please supply the project id"
    print(responseDictionary["error"]!)
    do {
      try response.setBody(json: responseDictionary)
    }catch
    {
      print("Project JSON submission Error: \(error)")
    }
    response.completed()
    return
  }

  let aProject = Project()

  do {
    try aProject.get(projectId)
    let project = aProject.rows().map{ $0.asDictionary() }
    try response.setBody(json: project)
      .setHeader(.contentType, value: "application/json")
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
  
  let aUser = User()
  
  do {
    try aUser.findAll()
    let users = aUser.rows().map{ $0.asDictionary() }
    try response.setBody(json: users)
      .setHeader(.contentType, value: "application/json")
      .completed()
  } catch
  {
    print("Couldnt set response Body for users: \(error)")
    response.setBody(string: "Couldnt get responseDictionary: \(error)")
      .completed(status: .internalServerError)
  }
}

func updateProject(request: HTTPRequest, _ response: HTTPResponse)
{
  response.setHeader(.contentType, value: "application/json")
  var responseDictionary = [String: String]()
  
  guard let dataFromString = request.postBodyString?.data(using: .utf8, allowLossyConversion: false) else { return }
  let json = JSON(data: dataFromString)
  
  guard let id = json["id"].int,
    let projectName = json["projectName"].string,
    let user1Id = json["user1Id"].int,
    let user2Id = json["user2Id"].int,
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
  
  var linesArray = [Line]()
  for lineDict in lines
  {
    let line = Line()
    line.getLineFrom(lineDictionary: lineDict)
    do
    {
      //something is going wrong here maybe .. After first line saved no lines are displayed but the first
      //also i think lines are being saved more than once
      try line.save(set: { id in
        line.id = id as! Int
      })
      responseDictionary["error"] = "Line saved."
      print(responseDictionary["error"]!)
    }
    catch
    {
      print("Updating Line in project Error: \(error)")
      responseDictionary["error"] = String(describing: error)
    }
    linesArray.append(line)
  }

  
  let projectToUpdate = Project()
  
  projectToUpdate.id = id
  projectToUpdate.projectName = projectName
  projectToUpdate.user1Id = user1Id
  projectToUpdate.user2Id = user2Id
  projectToUpdate.lines = linesArray

  do {
    try projectToUpdate.save(set: { _ in
    })
    responseDictionary["error"] = "Project updated."
    print(responseDictionary["error"]!)
  } catch
  {
    print("Updating Project Error: \(error)")
    responseDictionary["error"] = String(describing: error)
  }
  
  do {
    try response.setBody(json: responseDictionary)
      .setHeader(.contentType, value: "application/json")
      .completed()
  } catch {
    print("Couldnt set response Body for projects: \(error)")
    response.setBody(string: "Couldnt get responseDictionary: \(error)")
      .completed(status: .internalServerError)
  }
}
