//
//  HistoryViewController.swift
//  ForaSoftEvaluationTestDemo
//
//  Created by Denis Sychev on 10/8/21.
//

import UIKit

protocol HistoryDataUserProtocol: class {
    var historyDataSource: HistoryDataSource? { get set }
}

struct HistoryData: Codable {
    let groupName: String
    let link: String
}

class HistoryViewController: UIViewController, HistoryDataUserProtocol {
    
    private struct Constants {
        static let sequeToSearch = "toMainTabBarController"
        static let cellIdentifier = "cell"
    }

    @IBOutlet weak var tableView: UITableView!
    var historyDataSource: HistoryDataSource?
    
    var history: [HistoryData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadHistory()
    }
    
    private func loadHistory() {
        let _ = historyDataSource?.fetchHistoryURLs(completion: { (urls) in
            DispatchQueue.main.async { [weak self] in
                self?.history = urls
                self?.tableView.reloadData()
            }
        })
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let historyData = history[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier)!
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = historyData.groupName
        return cell
    }
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCellIndex = tableView.indexPathForSelectedRow else { return }
        let historyData = history[selectedCellIndex.row]
        
        if let tabBarController = self.tabBarController {
            guard let viewControllers = tabBarController.viewControllers else { return }
            for vc in viewControllers {
                (vc as? SearchViewController)?.loadAlbums(for: historyData.groupName)
            }
            DispatchQueue.main.async {
                self.dismiss(animated: false, completion: {})
                tabBarController.selectedIndex = 0
            }
        }
    }
}
