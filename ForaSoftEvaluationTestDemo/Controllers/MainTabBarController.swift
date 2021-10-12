//
//  MainTabBarController.swift
//  ForaSoftEvaluationTestDemo
//
//  Created by Denis Sychev on 10/9/21.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let dataController: DataController
    
    required init?(coder: NSCoder, dataController: DataController) {
        self.dataController = dataController
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        self.dataController = DataController()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        injectDataController()
    }
    
    private func injectDataController() {
        guard let viewControllers = viewControllers else { return }
        for viewController in viewControllers {
            if let dataUser = viewController as? AlbumDataUserProtocol {
                dataUser.dataSource = dataController
                if let dataUserDelegate = dataUser as? DataUserDelegate {
                    dataController.dataUser = dataUserDelegate
                }
            }
            (viewController as? HistoryDataUserProtocol)?.historyDataSource = dataController
        }
    }
}
