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
import SwiftyJSON

class User: SQLiteStORM
{
  var id = 0
  var username = ""
  var password = ""
  
  override func to(_ this: StORMRow)
  {
    id = this.data["id"] as? Int ?? 0
    username = this.data["username"] as? String ?? ""
    password = this.data["password"] as? String ?? ""
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
  
  func getUserFrom(userDictionary: [String: JSON])
  {
    username = (userDictionary["username"]?.string)!
    password = (userDictionary["password"]?.string)!
  }
  
  func asDictionary() -> [String: Any]
  {
    return [
      "id": self.id,
      "username": self.username,
      "password": self.password,
    ]
  }
}

