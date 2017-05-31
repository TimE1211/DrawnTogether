//
//  User.swift
//  DrawnTogether
//
//  Created by Timothy Hang on 5/25/17.
//
//


import StORM
import SQLiteStORM
import PerfectLib

class User: SQLiteStORM
{
  var username = ""
  var password = ""
//  var _projectUUIDs = [Project]()
//
//  override open func table() -> String
//  {
//    return "usersTable"
//  }
  
  override func to(_ this: StORMRow)
  {
    username = this.data["username"] as! String
    password = this.data["password"] as! String
//    _projectUUIDs = getProjs()
  }
  
  func rows() -> [User]
  {
    var users = [User]()
    for i in 0..<self.results.rows.count
    {
      let user = User()
      user.to(self.results.rows[i])
      users.append(user)
    }
    return users
  }
  
  func asDictionaryFrom(userDictionary: [String: Any])
  {
    username = userDictionary["username"] as! String
    password = userDictionary["password"] as! String
//    _projectUUIDs = userDictionary["projectUUIDs"] as! [Project]
  }

  func asDictionary() -> [String: Any]
  {
    return [
      "username": self.username,
      "password": self.password,
//      "projectUUIDs": self._projectUUIDs
    ]
  }
  
//  public func getProjs() -> [Project]
//  {
//    let projs = Project()
//    return projs.rows()
//  }
}

