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
  var user1Id: Int = 0
  var user2Id: Int = 0
  var lines = [Line]()
  
  override func to(_ this: StORMRow)
  {
    id = this.data["id"] as? Int ?? 0
    projectName = this.data["projectName"] as? String ?? ""
    user1Id = this.data["user1Id"] as? Int ?? 0
    user2Id = this.data["user2Id"] as? Int ?? 0
    lines = getLines()
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
      "user1Id": self.user1Id,
      "user2Id": self.user2Id,
      "lines": self.lines.map { $0.asDictionary() }
    ]
  }
  
  public func getLines() -> [Line]
  {
    let projectsLines = Line()
    
    do {
      try projectsLines.select(whereclause: "projectId = :1", params: [id], orderby: ["id"])
    } catch {
      print("line get error: \(error)")
    }
    
    return projectsLines.rows()
  }
}

