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

  override open func table() -> String
  {
    return "Users"
  }
  
  override func to(_ this: StORMRow)
  {
    username = this.data["username"] as! String
    password = this.data["password"] as! String
  }
  
  override init()
  {
    super.init()
    username = ""
    password = ""
  }
  
  init(userDictionary: [String: Any])
  {
    super.init()
    username = userDictionary["username"] as! String
    password = userDictionary["password"] as! String
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
  
  override public func setup()
  {
    do {
      try sqlExec("CREATE TABLE IF NOT EXISTS Users (username TEXT PRIMARY KEY NOT NULL, password TEXT)")
    } catch
    {
      print(error)
    }
  }
  
  func asDictionary() -> [String: Any]
  {
    return [
      "username": self.username,
      "password": self.password
    ]
  }
}

