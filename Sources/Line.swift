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
import SwiftyJSON

class Line: SQLiteStORM
{
  var projectUUID = ""
  var startx = "0"
  var starty = "0"
  var endx = "0"
  var endy = "0"
  var color = ""
  var thickness = "0"
  
//  override open func table() -> String
//  {
//    return "linesTable"
//  }

  override func to(_ this: StORMRow)
  {
    projectUUID = this.data["projectUUID"] as? String ?? ""
    startx = this.data["startx"] as? String ?? ""
    starty = this.data["starty"] as? String ?? ""
    endx = this.data["endx"] as? String ?? ""
    endy = this.data["endy"] as? String ?? ""
    color = this.data["color"] as? String ?? ""
    thickness = this.data["thickness"] as? String ?? ""
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
  
  func asDictionaryFrom(lineDictionary: [String: JSON])
  {
    projectUUID = (lineDictionary["projectUUID"]?.string)!
    startx = (lineDictionary["startx"]?.string)!
    starty = (lineDictionary["starty"]?.string)!
    endx = (lineDictionary["endx"]?.string)!
    endy = (lineDictionary["endy"]?.string)!
    color = (lineDictionary["color"]?.string)!
    thickness = (lineDictionary["thickness"]?.string)!
  }

  func asDictionary() -> [String: Any]
  {
    return [
      "projectUUID": self.projectUUID,
      "startx": self.startx,
      "starty": self.starty,
      "endx": self.endx,
      "endy": self.endy,
      "color": self.color,
      "thickness": self.thickness,
    ]
  }
}

