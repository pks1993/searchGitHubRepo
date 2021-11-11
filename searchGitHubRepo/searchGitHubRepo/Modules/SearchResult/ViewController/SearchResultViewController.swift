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
    var repositoryVo : RepositoryVO?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupTableView()
//        ApiClient.shared.getRepositoryList(parameters: ["q" : "hello"])
        ApiClient.shared.getRepositoryList(parameters: ["q" : "hello"]) { vo in
            print("Repository >>>>>> " ,vo)
            self.repositoryVo = vo
            DispatchQueue.main.async {
                self.tblRepository.reloadData()
            }
        } failure: { error in
            print(error.localizedDescription)
        }

    }
    
    private func setupTableView() {
        tblRepository.register(UINib(nibName: String(describing: SearchResultTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SearchResultTableViewCell.self))
        tblRepository.delegate = self
        tblRepository.dataSource = self
        tblRepository.reloadData()
    }

}

extension SearchResultViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryVo?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultTableViewCell.self)) as! SearchResultTableViewCell
        cell.setupCell(item: repositoryVo?.items?[indexPath.row])
        return cell
    }
    
}

