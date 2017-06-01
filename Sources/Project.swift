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
//  var _users = [User]()
  var user1Id: Int = 0
  var user2Id: Int = 0
  var _lines = [Int]()
  
  override func to(_ this: StORMRow)
  {
    id = this.data["id"] as? Int ?? 0
    projectName = this.data["projectName"] as? String ?? ""
    user1Id = this.data["user1Id"] as? Int ?? 0
    user2Id = this.data["user1Id"] as? Int ?? 0
    _lines = getLineIds()
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
//      "users": self.users,
      "user1Id": self.user1Id,
      "user2Id": self.user2Id,
      "lines": self._lines
    ]
  }
  
  public func getLineIds() -> [Int]
  {
    let lines = Line()
    var lineIds = [Int]()
    
    let allLines = lines.rows()
    for line in allLines
    {
//      line with project .id
      if line.projectId == self.id
      {
        lineIds.append(line.id)
      }
    }
    return lineIds
  }
  
//  public func getUsers() -> [User]
//  {
//    let users = User()
//    return users.rows()
//  }
}

