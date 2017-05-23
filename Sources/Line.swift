//
//  Points.swift
//  DrawnTogether
//
//  Created by Timothy Hang on 5/21/17.
//
//

import StORM
import SQLiteStORM
import PerfectLib

class Line: SQLiteStORM
{
  var startx = "0"
  var starty = "0"
  var endx = "0"
  var endy = "0"
  
  override open func table() -> String
  {
    return "Lines"
  }

  override func to(_ this: StORMRow)
  {
    startx = this.data["startx"] as! String
    starty = this.data["starty"] as! String
    endx = this.data["endx"] as! String
    endy = this.data["endy"] as! String
  }
  
  func rows() -> [Line]
  {
    var lines = [Line]()
    for i in 0..<self.results.rows.count
    {
      let line = Line()
      line.to(self.results.rows[i])
      lines.append(line)
    }
    return lines
  }

  override public func setup()
  {
    do {
      try sqlExec("CREATE TABLE IF NOT EXISTS Scores (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, startx TEXT, starty TEXT, endx TEXT, endy TEXT)")
//      try sqlExec("CREATE TABLE IF NOT EXISTS Points (startx STRING PRIMARY KEY AUTOINCREMENT NOT NULL, starty STRING, endx STRING, endy STRING)")
    } catch
    {
      print(error)
    }
  }
}

