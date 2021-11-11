//
//  ViewController.swift
//  searchGitHubRepo
//
//  Created by Phyo Kyaw Swar on 09/11/2021.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblRepository: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var items = [Item]()
    var currentPage = 1
    var searchText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupTableView()
        
        self.title = "Search Github Repository"
        searchBar.delegate = self
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        
        self.tblRepository.keyboardDismissMode = .onDrag
    }
    
    private func setupTableView() {
        tblRepository.register(UINib(nibName: String(describing: SearchResultTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SearchResultTableViewCell.self))
        tblRepository.delegate = self
        tblRepository.dataSource = self
        tblRepository.reloadData()
    }
    
    private func showErrorMessage(message : String) {
        let alert = UIAlertController(title: "Information", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func searchRepo(params : [String : String]) {
        ApiClient.shared.getRepositoryList(parameters: params) { repositoryVo in
            // get data from api and append in items
            self.items.append(contentsOf: repositoryVo?.items ?? [])
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
                self.tblRepository.reloadData()
            }
            
        } failure: { error in
            self.showErrorMessage(message: error.localizedDescription)
        }
        
    }
    
}
// MARK: - UItableViewDelegate & UITableViewDataSource
extension SearchResultViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultTableViewCell.self)) as! SearchResultTableViewCell
        cell.selectionStyle = .none
        cell.setupCell(item: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.items.count - 2 {
            self.currentPage += 1
            self.activityIndicator.startAnimating()
            let params = ["q" : self.searchText , "page" : "\(currentPage)"]
            self.searchRepo(params: params)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repoVoItem = items[indexPath.row]
        if let url = repoVoItem.owner?.htmlURL ,
           let title = repoVoItem.owner?.login{
            let webController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: WebViewController.self)) as! WebViewController
            webController.navTitle = title
            webController.url = url
            self.navigationController?.pushViewController(webController, animated: true)
        }
    }
    
}

// MARK: - UISearchBarDelegate
extension SearchResultViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.searchTextField.resignFirstResponder()
        if Reachability.isConnectedToNetwork(){
            if let text = searchBar.text, text != "" {
                self.items.removeAll()
                self.activityIndicator.startAnimating()
                self.searchText = text
                let params = ["q" : text , "page" : "\(currentPage)"]
                self.searchRepo(params: params)
                
            }
        }
        else {
            self.showErrorMessage(message: "No Internet Connection")
        }
        
        
    }
}



