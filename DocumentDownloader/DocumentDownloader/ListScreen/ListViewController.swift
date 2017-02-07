//
//  ViewController.swift
//  DocumentDownloader
//
//  Created by Rahul Narang on 2/4/17.
//  Copyright © 2017 rahul. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private weak var tblListView: UITableView!
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet private weak var lblNoData: UILabel!
    @IBOutlet private weak var activityView: UIActivityIndicatorView!
    private var arrayUsers: [User] = []
    private var isScrollingTop = false
    private var refreshControl: UIRefreshControl!
    /*
    let arrayImages: [String] = ["http://www.w3schools.com/css/trolltunga.jpg","http://assets.barcroftmedia.com.s3-website-eu-west-1.amazonaws.com/assets/images/recent-images-11.jpg","http://stories-and-trends.gettyimages.netdna-cdn.com/wp-content/uploads/2015/09/GettyImages-516422197.jpg","http://www.w3schools.com/css/trolltunga.jpg","http://www.planwallpaper.com/static/images/Jennifer-in-Paradi_3204219n.jpg","http://www.planwallpaper.com/static/images/image5_170127819.jpg","http://www.planwallpaper.com/static/images/foggygoldengatebridge.jpg","http://www.planwallpaper.com/static/images/wallpaper-sunset-images-back-217159.jpg","http://www.planwallpaper.com/static/images/Winter-Tiger-Wild-Cat-Images.jpg","http://www.planwallpaper.com/static/images/6986083-waterfall-images_Mc3SaMS.jpg","http://www.planwallpaper.com/static/images/9-credit-1.jpg","http://www.planwallpaper.com/static/images/canberra_hero_image_JiMVvYU.jpg","http://www.planwallpaper.com/static/images/434976-happy-valentines-day-timeline-cover.jpg","http://www.planwallpaper.com/static/images/6775415-beautiful-images.jpg","http://www.planwallpaper.com/static/images/6F0CE738-6419-4CF4-8E8878246C2D2569.jpg","http://www.planwallpaper.com/static/images/Child-Girl-with-Sunflowers-Images.jpg","http://www.planwallpaper.com/static/images/download-happy-janmashtami-hd-images.jpg","http://www.planwallpaper.com/static/images/beautiful-sunset-images-196063.jpg"]
    
     http://7-themes.com/data_images/out/66/6998241-nature-river-images.jpg
     */
    
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.innitialiseView()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Innitialize View
    private func innitialiseView(){
        self.addRefreshControlToTableView()
        self.callAPIToRefreshScreen()
    }
    
    // MARK: - Refresh View
    private func addRefreshControlToTableView() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(ListViewController.refreshTableView), for: .valueChanged)
        self.tblListView.addSubview(refreshControl)
    }
    
    func refreshTableView() {
        self.callAPIToRefreshScreen()
    }
    
    // MARK: - Call API
    func callAPIToRefreshScreen() {
        let isRefreshing = refreshControl.isRefreshing
        self.customiseTheViewBeforeAPICall()
        User.callAPIToFetchUsers {[unowned self] (users:[User]?) in
            if let tempUsers = users {
                if(isRefreshing){
                    
                    self.arrayUsers.removeAll()
                }
                
                self.arrayUsers.append(contentsOf: tempUsers)
            }
            self.customiseTheViewAfterAPICall()
        }
    }
    
    // MARK: - Customise View Before API Call
    private func customiseTheViewBeforeAPICall() {
        let isRefreshing = refreshControl.isRefreshing
        if(arrayUsers.count == 0){
            activityView.isHidden = false
        }
        else if(!isRefreshing) {
            viewFooter.isHidden = false
        }
    }
    
    // MARK: - Customise After API Call
    private func customiseTheViewAfterAPICall() {
        DispatchQueue.main.async {
            if(self.refreshControl.isRefreshing) {
                self.refreshControl.endRefreshing()
                self.tblListView.reloadData()
            }
            else{
                self.viewFooter.isHidden = true
                self.activityView.isHidden = true
                if(self.arrayUsers.count > 0) {
                    self.tblListView.isHidden = false
                    self.lblNoData.isHidden = true
                    if (self.arrayUsers.count > 10) {
                        let startIndex: Int = self.arrayUsers.count - 10
                        let endIndex: Int = self.arrayUsers.count - 1
                        self.insertNewCellsInTableView(startIndex: startIndex, lastIndex: endIndex)
                    }
                    else {
                        self.tblListView.reloadData()
                    }
                }
                else{
                    self.lblNoData.isHidden = false
                    self.tblListView.isHidden = true
                }
            }
        }
    }
    // MARK: - TableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayUsers.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserCustomCell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserCustomCell.self)) as! UserCustomCell
        
        let objUser: User = arrayUsers[indexPath.row]
        cell.configureCell(objUser: objUser)
        cell.animateCells(objUser: objUser, isScrollingUp: isScrollingTop)
        if(indexPath.row == arrayUsers.count - 1) {
            self.callAPIToRefreshScreen()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    // MARK: - TableViewDelegate Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        isScrollingTop = scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0

    }
    
    // MARK: - Insert Cells in UITableView
    private func insertNewCellsInTableView(startIndex: Int, lastIndex: Int) {
        var arrayIndexPaths: [IndexPath] = []
        for index in startIndex...lastIndex {
            arrayIndexPaths.append(IndexPath(row: index, section: 0))
        }
        self.tblListView.insertRows(at: arrayIndexPaths, with: .automatic)
    }
    
}
