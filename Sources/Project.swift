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
  var id: Int = 0
  var projectName: String = ""
  var _users = [User]()
  var _lines = [Line]()
  
  override func to(_ this: StORMRow)
  {
    id = this.data["id"] as? Int ?? 0
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
      "id": self.id,
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

