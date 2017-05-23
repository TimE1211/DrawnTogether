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

class Point: PostgresStORM
{
  
  var x = 0
  var y = 0
  
  override open func table() -> String
  {
    return "Points"
  }

  override func to(_ this: StORMRow)
  {
    x = this.data["x"] as? Double ?? 0
    y = this.data["y"] as? Double ?? 0
  }
  
  func rows() -> [Point]
  {
    var points = [Point]()
    for i in 0..<self.results.rows.count
    {
      let point = Point()
      row.to(self.results.rows[i])
      points.append(point)
    }
    return points
  }

  override public func setup()
  {
    do {
      try sqlExec("CREATE TABLE IF NOT EXISTS Points (x INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, y INTEGER)")
    } catch
    {
      print(error)
    }
  }
  
//  func asDictionary() -> [String: Any]
//  {
//    return [
//      "point": self.point
//    ]
//  }
}

