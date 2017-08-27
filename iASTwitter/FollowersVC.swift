//
//  FollowersVC.swift
//  iASTwitter
//
//  Created by Amr Salman on 8/26/17.
//  Copyright © 2017 Amr Salman. All rights reserved.
//

import UIKit
import Kingfisher
import PKHUD

class FollowersVC: BaseViewController {
  
  //MARK: - Outlets
  
  @IBOutlet weak var profileImg: UIImageView!
  @IBOutlet weak var usernameLbl: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  //MARK: - Properties
  
  var user: User!
  var refreshControl: UIRefreshControl!
  var skip = 0
  var selectedFollower: User!
  var selectedIndexPath: IndexPath!
  
  //MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.isHidden = true
    updateKilledFollowers()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.navigationBar.isHidden = false
  }
  
  //MARK: - Helpers
  
  func loadFollowers() {
    user.getFollowers { (error: Error?) in
      if error != nil {
        HUD.flash(.labeledError(title: nil, subtitle: error?.localizedDescription), delay: 2.0)
      } else {
        self.updateTable()
      }
    }
  }
  
  fileprivate func dispalyCurrentUserInfo() {
    guard let user = User.currentUser() else { return }
    self.user = user
    loadFollowers()
    usernameLbl.text = "@\(user.username)"
    profileImg.kf.setImage(with: URL(string: user.profileImageURL), placeholder: #imageLiteral(resourceName: "placeholder"), options: [.transition(ImageTransition.fade(1))])
  }
  
  override func setup() {
    super.setup()
    
    dispalyCurrentUserInfo()
    setupTableView()
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
    refreshControl.addTarget(self, action: #selector(FollowersVC.handleRefresh(_:)), for: .valueChanged)
    tableView.addSubview(refreshControl)
  }
  
  func handleRefresh(_ sender: Any) {
    skip = 0
    user.cursor = -1
    user.followers.removeAll()
    tableView.reloadData()
    tableView.tableFooterView?.isHidden = true
    loadFollowers()
  }
  
  fileprivate func updateKilledFollowers() {
    if selectedIndexPath != nil {
      let initialOffset = self.tableView.contentOffset
      tableView.beginUpdates()
      tableView.reloadRows(at: [selectedIndexPath], with: .fade)
      tableView.setContentOffset(initialOffset, animated: false)
      tableView.endUpdates()
    }
  }
  
  fileprivate func updateTable() {
    let indexes = user.followers.count - skip
    guard indexes > 0 else {
      self.tableView.tableFooterView?.isHidden = true
      return
    }
    
    var indexPaths = [IndexPath]()
    for index in 0...(indexes - 1) {
      let indexPath = IndexPath(row: index + skip, section: 0)
      indexPaths.append(indexPath)
    }
    
    skip = user.followers.count
    
    if tableView.contentOffset.y > tableView.estimatedRowHeight {
      let initialOffset = self.tableView.contentOffset
      
      tableView.beginUpdates()
      tableView.insertRows(at: indexPaths, with: .fade)
      tableView.setContentOffset(initialOffset, animated: false)
      tableView.endUpdates()
      
    } else {
      tableView.insertRows(at: indexPaths, with: .fade)
    }
    
    refreshControl.endRefreshing()

  }

   // MARK: - Navigation
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Storyboards.followerDetails {
      if let destination = segue.destination as? FollowerDetailsVC {
        destination.user = selectedFollower
      }
    }
   }
  
}

extension FollowersVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedFollower = user.followers[indexPath.row]
    selectedIndexPath = indexPath
    self.performSegue(withIdentifier: Storyboards.followerDetails, sender: self)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == skip - 1 {
      loadFollowers()
    }
    let lastSectionIndex = tableView.numberOfSections - 1
    let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
    if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
      // print("this is the last cell")
      let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
      spinner.startAnimating()
      spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
      spinner.activityIndicatorViewStyle = .white
      
      self.tableView.tableFooterView = spinner
      self.tableView.tableFooterView?.isHidden = false
    }
  }
}

extension FollowersVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return user.followers.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? FollowerCell {
      cell.configure(user.followers[indexPath.row])
      return cell
    }
    return UITableViewCell()
  }
}
