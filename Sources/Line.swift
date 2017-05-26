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
    return "linesTable"
  }

  override func to(_ this: StORMRow)
  {
    id = this.data["id"] as? Int ?? 0
    startx = this.data["startx"] as! String
    starty = this.data["starty"] as! String
    endx = this.data["endx"] as! String
    endy = this.data["endy"] as! String
  }
  
  override init()
  {
    super.init()
    id = 0
    startx = "0"
    starty = "0"
    endx = "0"
    endy = "0"
  }
  
  init(lineDictionary: [String: Any])
  {
    super.init()
    id = lineDictionary["id"] as? Int ?? 0
    startx = lineDictionary["startx"] as! String
    starty = lineDictionary["starty"] as! String
    endx = lineDictionary["endx"] as! String
    endy = lineDictionary["endy"] as! String
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
      try sqlExec("CREATE TABLE IF NOT EXISTS lines_table (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, startx TEXT, starty TEXT, endx TEXT, endy TEXT)")
      //users INTEGER FOREIGN KEY
    } catch
    {
      print("LineTable: \(error)")
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

