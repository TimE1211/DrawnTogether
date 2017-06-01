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
  var id = 0
  var projectId = 0
  var startx = "0"
  var starty = "0"
  var endx = "0"
  var endy = "0"
  var color = ""
  var thickness = "0"

  override func to(_ this: StORMRow)      //from storm to object to make a dict
  {
    id = this.data["id"] as? Int ?? 0
    projectId = this.data["projectId"] as? Int ?? 0
    startx = this.data["startx"] as? String ?? ""
    starty = this.data["starty"] as? String ?? ""
    endx = this.data["endx"] as? String ?? ""
    endy = this.data["endy"] as? String ?? ""
    color = this.data["color"] as? String ?? ""
    thickness = this.data["thickness"] as? String ?? ""
  }
  
  func rows() -> [Line]       //get all rows in storm table and make them into objects
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
  
  func getLineFrom(lineDictionary: [String: JSON])      //make line obj from json request
  {
    projectId = (lineDictionary["projectId"]?.int)!
    startx = (lineDictionary["startx"]?.string)!
    starty = (lineDictionary["starty"]?.string)!
    endx = (lineDictionary["endx"]?.string)!
    endy = (lineDictionary["endy"]?.string)!
    color = (lineDictionary["color"]?.string)!
    thickness = (lineDictionary["thickness"]?.string)!
  }

  func asDictionary() -> [String: Any]        //as dict from storm
  {
    return [
      "id": self.id,
      "projectId": self.projectId,
      "startx": self.startx,
      "starty": self.starty,
      "endx": self.endx,
      "endy": self.endy,
      "color": self.color,
      "thickness": self.thickness,
    ]
  }
}

