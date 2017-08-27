//
//  FollowerDetailsVC.swift
//  iASTwitter
//
//  Created by Amr Salman on 8/27/17.
//  Copyright © 2017 Amr Salman. All rights reserved.
//

import UIKit
import PKHUD
import Kingfisher

class FollowerDetailsVC: BaseViewController {
  
  //MARK: - Outlets
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var backgroundImg: UIImageView!
  @IBOutlet weak var profileImg: UIImageView!
  
  //MARK: - Properties
  
  var user: User!
  var refreshControl: UIRefreshControl!
  
  //MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  //MARK: - Actions
  
  @IBAction func onSpareBtnPressed(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func onKillBtnPressed(_ sender: Any) {
    user.isKilled = true
    navigationController?.popViewController(animated: true)
  }
  
  //MARK: - Helpers
  
  override func setup() {
    super.setup()
    
    profileImg.shape = .circular
    dispalyUserInfo()
    setupTableView()
    navigationController?.navigationBar.isTranslucent = false
    
    if user.tweets.count <= 0 {
      loadTweets()
    }
  }
  
  fileprivate func dispalyUserInfo() {
    profileImg.kf.setImage(with: URL(string: user.profileImageURL), placeholder: #imageLiteral(resourceName: "placeholder"), options: [.transition(ImageTransition.fade(1))])
    
    backgroundImg.kf.setImage(with: URL(string: user.backgroundImageURL), placeholder: UIImage.with(color: UIColor.init(red: 251 / 256, green: 222 / 256, blue: 139 / 256, alpha: 1.0), size: backgroundImg.bounds.size), options: [.transition(ImageTransition.fade(1))])
  }
  
  fileprivate func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 300
    initiatRefreshControl()
  }
  
  fileprivate func initiatRefreshControl() {
    refreshControl = UIRefreshControl()
    refreshControl.attributedTitle = NSAttributedString(string: "")
    refreshControl.tintColor = .white
    refreshControl.addTarget(self, action: #selector(FollowerDetailsVC.handleRefresh(_:)), for: .valueChanged)
    tableView.addSubview(refreshControl)
  }
  
  func handleRefresh(_ sender: Any) {
    user.tweets.removeAll()
    tableView.reloadData()
    loadTweets()
  }
  
  fileprivate func updateTable() {
    let indexes = user.tweets.count
    
    if indexes <= 0 {
      return
    }
    
    var indexPaths = [IndexPath]()
    for index in 0...(indexes - 1) {
      let indexPath = IndexPath(row: index, section: 0)
      indexPaths.append(indexPath)
    }
    tableView.insertRows(at: indexPaths, with: .fade)
    refreshControl.endRefreshing()
  }
  
  func loadTweets() {
    user.getTweets { (error: Error?) in
      if error != nil {
        HUD.flash(.labeledError(title: nil, subtitle: error?.localizedDescription), delay: 2.0)
      } else {
        self.updateTable()
      }
    }
  }
}

extension FollowerDetailsVC: UITableViewDelegate {
  
}

extension FollowerDetailsVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return user.tweets.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TweetCell {
      cell.configure(user.tweets[indexPath.row])
      return cell
    }
    return UITableViewCell()
  }
}
