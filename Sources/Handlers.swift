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

func test(request: HTTPRequest, response: HTTPResponse)
{
  do {
    let project1 = Project()
    project1.projectName = "Joe"
    project1._lines = []
    project1._users = []
    try project1.save() { id in
      project1.id = id as! Int
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

func saveProject(request: HTTPRequest, _ response: HTTPResponse)
{
  response.setHeader(.contentType, value: "application/json")
  var responseDictionary = [String: String]()
  
  guard let dataFromString = request.postBodyString?.data(using: .utf8, allowLossyConversion: false) else { return }
  let json = JSON(data: dataFromString)
  
  print(json)
  
  guard //let id = json["id"].int,
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
  
  let aProject = Project()
  
  //  aProject.id = id
  aProject.projectName = projectName
  
  var usersArray = [User]()
  for userDict in users
  {
    let user = User()
    user.getUserFrom(userDictionary: userDict.dictionary!)
    usersArray.append(user)
  }
  aProject._users = usersArray
  
  var linesArray = [Line]()
  for lineDict in lines
  {
    let line = Line()
    line.getLineFrom(lineDictionary: lineDict.dictionary!)
    linesArray.append(line)
  }
  aProject._lines = linesArray
  
  do {
    try aProject.save() { id in
      aProject.id = id as! Int
    }
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
  let aUser = User()
  
  aUser.username = username
  aUser.password = password
  do {
    try aUser.save() { id in
      aUser.id = id as! Int
    }
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
  
  let aProject = Project()
  
  do {
    try aProject.findAll()
    let projects = aProject.rows().map{ $0.asDictionary()}
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

func getUsers(request: HTTPRequest, _ response: HTTPResponse)
{
  response.setHeader(.contentType, value: "application/json")
  
  let aUser = User()
  
  do {
    try aUser.findAll()
    let users = aUser.rows().map{ $0.asDictionary()}
    print(users)
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


//func update(cols: [lines], params: [[Line]], idName: id, idValue: project#) throws -> Bool
//{ bool
//  if bool == true
//  {
//    print("update successful")
//  }
//}
//catch {
//  error
//}
