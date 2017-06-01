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
      "user1Id": self.user1Id,
      "user2Id": self.user2Id,
      "lines": self._lines
    ]
  }
  
  public func getLineIds() -> [Int]
  {
    let aLine = Line()
    var lineIds = [Int]()
    
    do {
      try aLine.findAll()
      let allLines = aLine.rows()
      for line in allLines
      {
        if line.projectId == self.id
        {
          let thisProjectsLine = line
          lineIds.append(thisProjectsLine.id)
        }
      }
    } catch {
      print("Couldnt find all Lines: \(error)")
    }
    return lineIds
  }
}

