//
//  User.swift
//  iASTwitter
//
//  Created by Amr Salman on 8/18/17.
//  Copyright © 2017 Amr Salman. All rights reserved.
//

import UIKit
import PKHUD

class User: BaseModel{
  
  //MARK: - Properties
  
  var id: String = ""
  var username: String = ""
  var name: String = ""
  var token: String?
  var profileImageURL: String = ""
  var bio: String = ""
  var followers = [User]()
  var cursor = -1
  var backgroundImageURL: String = ""
  var tweets = [String]()
  var isKilled = false
  
  //MARK: - Initualizers
  
  override init() {
    super.init()
  }
  
  init(withID id: String) {
    super.init()
    var parameters = JSON()
    if let localUser = localUser(withID: id) {
      parameters = localUser
      try! self.configureUser(parameters)
    } else {
      self.loadUser(id) { (json: JSON, error: Error?) in
        if error != nil {
          HUD.flash(.labeledError(title: nil, subtitle: error?.localizedDescription), delay: 2.0)
        } else {
          parameters = json
          do {
            try StorageManager.default.store(dictionary: parameters, fileName: id)
            try self.configureUser(parameters)
          } catch {
            HUD.flash(.labeledError(title: nil, subtitle: error.localizedDescription), delay: 2.0)
          }
        }
      }
    }
  }
  
  init(_ json: JSON) throws {
    super.init()
    do {
      try configureUser(json)
    } catch {
      throw error
    }
  }
  
  //MARK: - Singleton
  
  static func currentUser() -> User? {
    do {
      return try User(try StorageManager.default.dictionaryValue(FileType.user))
    } catch {
      return nil
    }
  }
  
  //MARK: - Actions
  
  func configureUser(_ json: JSON) throws {
    guard let id = json[Keys.id] as? String else { throw iASError.missing(Keys.id) }
    guard let username = json[Keys.username] as? String else { throw iASError.missing(Keys.username) }
    guard let name = json[Keys.name] as? String else { throw iASError.missing(Keys.name) }
    guard let profileImageURL = json[Keys.profileImageURL] as? String else { throw iASError.missing(Keys.profileImageURL) }
    
    self.id = id
    self.username = username
    self.name = name
    self.profileImageURL = profileImageURL
    self.token = json[Keys.token] as? String
    self.bio = json[Keys.description] as? String ?? ""
    self.backgroundImageURL = json[Keys.backgroundImageURL] as? String ?? ""
  }
  
  func localUser(withID id: String) -> JSON? {
    do {
      let userJSON = try StorageManager.default.dictionaryValue(id)
      return userJSON
    } catch {
      return nil
    }
  }
  
  func loginButton() -> TWTRLogInButton {
    let loginBtn = TWTRLogInButton { (session: TWTRSession?, error: Error?) in
      if error != nil {
        HUD.flash(.labeledError(title: nil, subtitle: error?.localizedDescription), delay: 2.0)
      } else {
        guard let session = session else { return }
        var parameters = JSON()
        self.loadUser(session.userID) { (json: JSON, error: Error?) in
          if error != nil {
            HUD.flash(.labeledError(title: nil, subtitle: error?.localizedDescription), delay: 2.0)
          } else {
            parameters = json
            parameters[Keys.token] = session.authToken
            do {
              try StorageManager.default.store(dictionary: parameters, fileName: FileType.user)
              self.hijackWindow(withStoryBoardname: Storyboards.followers)
            } catch {
              HUD.flash(.labeledError(title: nil, subtitle: error.localizedDescription), delay: 2.0)
            }
          }
        }
      }
    }
    return loginBtn
  }
  
  func getFollowers(completionHandler: @escaping (Error?) -> Void) {
    let networkStatus = Reachability().connectionStatus()
    switch networkStatus {
    case .Offline:
      do {
        let followersJSON = try StorageManager.default.arrayValue(FileType.followers)
        for followerJSON in followersJSON {
          followers.append(try User(followerJSON))
        }
        completionHandler(nil)
      } catch {
        completionHandler(error)
      }
    default:
      let client = TWTRAPIClient()
      let endpoint = "https://api.twitter.com/1.1/followers/list.json"
      let params: [String : Any] = [Keys.userID: id,
                                    Keys.username: username,
                                    Keys.cursor: "\(cursor)"]
      if cursor == -1 {
        followers.removeAll()
      }
      
      var clientError : NSError?
      
      let request = client.urlRequest(withMethod: "GET", url: endpoint, parameters: params, error: &clientError)
      
      client.sendTwitterRequest(request) { (response: URLResponse?, data: Data?, error: Error?) -> Void in
        if error != nil {
          completionHandler(error)
        } else {
          do {
            if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? JSON {
              if let nextCursor = json["next_cursor"] as? Int {
                self.cursor = nextCursor
              }
              guard let usersArray = json[Keys.users] as? [JSON] else {
                completionHandler(iASError.missing(Keys.users))
                return
              }
              
              try StorageManager.default.store(array: usersArray, fileName: FileType.followers)
              
              for userJSON in usersArray {
                self.followers.append(try User(userJSON))
              }
              
              completionHandler(nil)
            } else {
              completionHandler(iASError.invalid("JSON", data ?? "No data"))
            }
          } catch {
            completionHandler(error)
          }
        }
      }
    }
  }
  
  func getTweets(completionHandler: @escaping (Error?) -> Void) {
    let networkStatus = Reachability().connectionStatus()
    switch networkStatus {
    case .Offline:
      do {
        let tweetsJSON = try StorageManager.default.arrayValue(self.id + FileType.tweets)
        for tweetjson in tweetsJSON {
          tweets.append(tweetjson["text"] as? String ?? "")
        }
        completionHandler(nil)
      } catch {
        completionHandler(error)
      }
    default:
      let client = TWTRAPIClient()
      let endpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
      let params: [String : Any] = [Keys.userID: id,
                                    Keys.username: username,
                                    Keys.count: "10"]
      var clientError : NSError?
      
      let request = client.urlRequest(withMethod: "GET", url: endpoint, parameters: params, error: &clientError)
      
      client.sendTwitterRequest(request) { (response: URLResponse?, data: Data?, error: Error?) -> Void in
        if error != nil {
          completionHandler(error)
        } else {
          do {
            if let tweetsArrayjson = try JSONSerialization.jsonObject(with: data!, options: []) as? [JSON] {
              
              try StorageManager.default.store(array: tweetsArrayjson, fileName: self.id + FileType.tweets)
              
              for tweetjson in tweetsArrayjson {
                self.tweets.append(tweetjson["text"] as? String ?? "")
              }
              completionHandler(nil)
            } else {
              completionHandler(iASError.invalid("JSON", data ?? "No data"))
            }
          } catch let jsonError as NSError {
            print("json error: \(jsonError.localizedDescription)")
          }
        }
      }
    }
  }
  
  //MARK: - Helpers
  
  fileprivate func loadUser(_ id: String, completionHandler: @escaping (JSON, Error?) -> Void) {
    var parameters = JSON()
    TWTRAPIClient(userID: id).loadUser(withID: id) { (user: TWTRUser?, error: Error?) in
      if error != nil {
        completionHandler(parameters, error)
      } else {
        guard let user = user else {
          completionHandler(parameters, error)
          return
        }
        parameters = [Keys.id: user.userID,
                      Keys.name: user.name,
                      Keys.username: user.screenName,
                      Keys.profileImageURL: user.profileImageURL]
        
        completionHandler(parameters, error)
      }
    }
  }
  
}
