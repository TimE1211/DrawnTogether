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
  var projectUUID: String
  var name: String
  var users: [User] = []
  var lines: [Line] = []
  
  override open func table() -> String
  {
    return "Projects"
  }
  
  override func to(_ this: StORMRow)
  {
    projectUUID = this.data["projectUUID"] as? Int ?? 0
    startx = this.data["startx"] as! String
    starty = this.data["starty"] as! String
    endx = this.data["endx"] as! String
    endy = this.data["endy"] as! String
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
      try sqlExec("CREATE TABLE IF NOT EXISTS Projects (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, startx TEXT, starty TEXT, endx TEXT, endy TEXT)")
      //users INTEGER FOREIGN KEY
    } catch
    {
      print(error)
    }
  }
  
  func asDictionary() -> [String: Any]
  {
    return [
      "startx": self.startx,
      "starty": self.starty,
      "endx": self.endx,
      "endy": self.endy
    ]
  }
}

