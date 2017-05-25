//
//  Line.swift
//  DrawnTogether
//
//  Created by Timothy Hang on 5/21/17.
//
//

import StORM
import SQLiteStORM
import PerfectLib

class Project: SQLiteStORM
{
  var id = 0
  var startx = "0"
  var starty = "0"
  var endx = "0"
  var endy = "0"
  
  override open func table() -> String
  {
    return "Projects"
  }

  override func to(_ this: StORMRow)
  {
    id = this.data["id"] as? Int ?? 0
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

