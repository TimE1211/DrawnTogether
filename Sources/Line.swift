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

class Line: SQLiteStORM
{
  var id = 0
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
    id = this.data["id"] as? Int ?? 0
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
      try sqlExec("CREATE TABLE IF NOT EXISTS Lines (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, startx TEXT, starty TEXT, endx TEXT, endy TEXT)")
    } catch
    {
      print(error)
    }
  }
  
//  init(dictionary: [String: Any])
//  {
//    startx = dictionary["startx"] as! String
//    starty = dictionary["starty"] as! String
//    endx = dictionary["endx"] as! String
//    endy = dictionary["endy"] as! String
//  }
  
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

