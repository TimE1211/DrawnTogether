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
  var users = [User]()
  var lines = [Line]()
  
  override open func table() -> String
  {
    return "Projects"
  }
  
  override func to(_ this: StORMRow)
  {
    projectUUID = this.data["projectUUID"] as! String
    name = this.data["name"] as! String
    users = this.data["users"] as! [User]
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
  
  override public func setup()
  {
    do {
      try sqlExec("CREATE TABLE IF NOT EXISTS Projects (projectUUID TEXT PRIMARY KEY NOT NULL, name TEXT, users TEXT FOREIGN KEY, lines INTEGER FOREIGN KEY)")
    } catch
    {
      print(error)
    }
  }
  
  func asDictionary() -> [String: Any]
  {
    return [
      "projectUUID": self.projectUUID,
      "name": self.name,
      "users": self.users,
      "lines": self.lines
    ]
  }
}

