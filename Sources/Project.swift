//
//  Project.swift
//  DrawnTogether
//
//  Created by Timothy Hang on 5/25/17.
//
//

//https://github.com/iamjono/NestedObjectsExample/blob/master/Sources/Games.swift

import StORM
import SQLiteStORM
import PerfectLib

class Project: SQLiteStORM
{
  var projectUUID = ""
  var projectName = ""
  var _users = [User]()
  var _lines = [Line]()
//  
//  override open func table() -> String
//  {
//    return "project"
//  }
  
  override func to(_ this: StORMRow)
  {
    projectUUID = this.data["projectUUID"] as? String ?? ""
    projectName = this.data["projectName"] as? String ?? ""
    _users = getUsers()
    _lines = getLines()
  }
  
  func rows() -> [Project]
  {
    var projects = [Project]()
    for i in 0..<self.results.rows.count
    {
      let project = Project()
      project.to(self.results.rows[i])
      projects.append(project)
    }
    return projects
  }
  
  func asDictionary() -> [String: Any]
  {
    return [
      "projectUUID": self.projectUUID,
      "projectName": self.projectName,
      "users": self._users,
      "lines": self._lines
    ]
  }
  
  public func getLines() -> [Line]
  {
    let lines = Line()
    return lines.rows()
  }
  
  public func getUsers() -> [User]
  {
    let users = User()
    return users.rows()
  }
}

