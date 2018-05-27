//
//  SearchLocationViewController.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/23/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit
import SkeletonView
import CoreLocation

protocol SearchLocationDelegate {
    //    func
}

class SearchLocationViewController: UIViewController {
    
    @IBOutlet weak var searchTableView: UITableView!
    var searchDatasource: SearchLocationDatasource = SearchLocationDatasource()
    var currentDatasource: SearchLocationDatasource!
    let refreshControl = RefreshControl()
    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRect.zero)
    var searchQuery: String? = nil
    var cancelQuery: Bool = false
    var currentLocation: CLLocation!
    var selectMap: ((_ building: Building) -> Void)?
    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        searchTableView.isSkeletonable = true
        setupTableView()
        currentDatasource = searchDatasource
        loadFirstPage()
        UIApplication.shared.statusBarStyle = .lightContent
        searchBar.placeholder = "Enter location name"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshControl.beginRefreshing()
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        cancelSearch()
//        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func retryButtonClicked(_ sender: Any) {
        loadFirstPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailLocationViewController = segue.destination as? DetailLocationViewController {
            detailLocationViewController.building = sender as! Building
            detailLocationViewController.currentLocation = self.currentLocation
            detailLocationViewController.selectMap = selectMap
        }
    }
}

extension SearchLocationViewController {
    
    func reloadData(scrollToTop: Bool = false, invalidateLayout: Bool = false) {
        self.searchTableView.reloadData()
        if self.searchTableView.numberOfRows(inSection: 0) > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            self.searchTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func setMessageViewHidden(_ isMessageViewHidden: Bool, message: String? = nil, isButtonHidden: Bool = false) {
        messageContainer.isHidden = isMessageViewHidden
        messageLabel.text = message ?? ""
        messageButton.isHidden = isButtonHidden
        searchTableView.isHidden = !isMessageViewHidden
    }
    
    private func setupTableView() {
        searchTableView.register(UINib(nibName: "AccessibilityCell", bundle: nil), forCellReuseIdentifier: "accessibilityCell")
        searchTableView.addSubview(refreshControl)
        searchTableView.sendSubview(toBack: refreshControl)
    }
    
    func onRefresh() {
        self.refreshControl.endRefreshing()
        if self.currentDatasource.isLoading {
            return
        }
        if ReachabilityManager.shared.isReachable {
            if let _ = self.searchQuery , self.searchBar.text != "" {
                self.search()
            } else {
                self.currentDatasource.clearResults()
                self.searchQuery = ""
                self.loadFirstPage()
            }
        } else {
            print("Error")
        }
    }
    
    func cancelSearch() {
        searchBar.resignFirstResponder()
    }
    
    func loadMore() {

        currentDatasource.loadMore { [unowned self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(nil):
                    self.searchTableView.reloadData()
                    self.refreshControl.endRefreshing()
                    break
                case .failure(let error):
                    print(error?.localizedDescription ?? "No error")
                    break
                default:
                    break
                }
            }
        }
    }
    
    func loadFirstPage() {
        cancelSearch()
        setMessageViewHidden(true)
        searchBar.text = ""
        LoadingIndicator.shared.show()
        currentDatasource.loadFirstPage {  [unowned self] (result) in
            DispatchQueue.main.async {
                LoadingIndicator.shared.hide()
                switch result {
                case .success(nil):
                    if self.searchTableView.tableFooterView == nil {
                       self.searchTableView.tableFooterView = LoadMoreView()
                    }
                    
                    self.searchTableView.reloadData()
                    self.refreshControl.endRefreshing()
                    
                    if self.currentDatasource.buildings.count == 0 {
                        self.setMessageViewHidden(false, message: "There is no location", isButtonHidden: true)
                    }
                    break
                case .failure(let error):
                    print(error?.localizedDescription ?? "No error")
                    if (error?.localizedDescription != "cancelled") {
                        self.setMessageViewHidden(false, message: error?.localizedDescription, isButtonHidden: false)
                    }
                    
                    break
                default:
                    break
                }
            }
        }
    }
    
}

extension SearchLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetailViewController", sender: currentDatasource.buildings[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y
        let contenHeight = scrollView.contentSize.height
        // Load more media if user scroll past 2/3 of the images
        if scrollOffset > (contenHeight - scrollView.frame.height) * 2 / 3 && !currentDatasource.isLoading && scrollOffset > 0 {
            loadMore()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            self.onRefresh()
        }
    }
}

extension SearchLocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "accessibilityCell") as? AccessibilityCell else {
            return UITableViewCell()
        }
        cell.building = currentDatasource.buildings[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDatasource.buildings.count
    }
}

extension SearchLocationViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        showSearchResultOf(searchText)
    }
    
    func hideSearchResult() {
        cancelQuery = true
    }
    
    @objc func search() {
        setMessageViewHidden(true)
        view.showAnimatedGradientSkeleton()
        currentDatasource.loadFirstPage(searchQuery!) { [unowned self] (result) in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.view.hideSkeleton()
                switch result {
                case .success(nil):
                    if self.currentDatasource.buildings.count == 0 {
                        self.setMessageViewHidden(false, message: "There is no location", isButtonHidden: true)
                    }
                    self.reloadData(scrollToTop: true, invalidateLayout: true)
                    break
                case .failure(let error):
                    print(error?.localizedDescription ?? "empty")
                    if (error?.localizedDescription != "cancelled") {
                        self.setMessageViewHidden(false, message: error?.localizedDescription, isButtonHidden: false)
                    }
                    break
                default:
                    break
                }
            }
        }
    }
    
    func showSearchResultOf(_ query: String) {
        searchQuery = query
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(search), object: nil)
        perform(#selector(search), with: nil, afterDelay: 0.3)
    }
}
