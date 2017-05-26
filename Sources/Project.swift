//
//  Project.swift
//  DrawnTogether
//
//  Created by Timothy Hang on 5/25/17.
//
//

import StORM
import SQLiteStORM
import PerfectLib

class Project: SQLiteStORM
{
  var projectUUID = ""
  var name = ""
  var user1 = ""
  var user2 = ""
  var lines = [Line]()
  
  override open func table() -> String
  {
    return "projectsTable"
  }
  
  override func to(_ this: StORMRow)
  {
    projectUUID = this.data["projectUUID"] as! String
    name = this.data["name"] as! String
    user1 = this.data["user1"] as! String
    user2 = this.data["user2"] as! String
    lines = this.data["lines"] as! [Line]
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
  
//  override public func setup()
//  {
//    do {
//      try sqlExec("CREATE TABLE IF NOT EXISTS projects_table (projectUUID TEXT PRIMARY KEY NOT NULL, name TEXT, user1 TEXT NOT NULL, user2 TEXT NOT NULL")
//    } catch
//    {
//      print("ProjectTable: \(error)")
//    }
//  }
  
  func asDictionary() -> [String: Any]
  {
    return [
      "projectUUID": self.projectUUID,
      "name": self.name,
      "user1": self.user1,
      "user2": self.user2,
      "lines": self.lines
    ]
  }
}

