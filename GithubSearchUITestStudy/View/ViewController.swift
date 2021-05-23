//
//  ViewController.swift
//  GithubSearchUITestStudy
//
//  Created by 60080252 on 2021/05/20.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let networkManager = SearchNetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.keyboardDismissMode = .onDrag
        networkManager.delegate = self
    }
    
   @objc func searchUser(_ searchBar: UISearchBar) {
    guard let query = searchBar.text else { return }
    if (networkManager.search(query: query, page: 1) {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }) {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
        }
    }
}

extension ViewController: ViewControllerDelegate {
    func dataSourceChanged() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchUser(_:)), object: searchBar)
            perform(#selector(self.searchUser(_:)), with: searchBar, afterDelay: 0.5)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < networkManager.users.count else { return }
        
        if let urlStr = networkManager.users[indexPath.row].htmlUrl,
           let url = URL(string: urlStr) {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastestCell = (networkManager.users.endIndex - 1) == indexPath.row
        if isLastestCell && networkManager.paginationAvailable {
            if networkManager.searchNextPage(completion: {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }) {
                DispatchQueue.main.async {
                    self.activityIndicator.startAnimating()
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkManager.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < networkManager.users.count else {
            return UITableViewCell()
        }
        
        let user = networkManager.users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
        cell.user = user
        cell.accessoryType = user.htmlUrl != nil ? .disclosureIndicator : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

