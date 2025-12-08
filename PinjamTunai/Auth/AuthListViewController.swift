//
//  AuthListViewController.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/8.
//

import UIKit
import SnapKit
import MJRefresh

class AuthListViewController: BaseViewController {
    
    var productID: String = ""
    
    let viewModel = AuthListViewModel()
    
    lazy var listView: AuthListView = {
        let listView = AuthListView()
        return listView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        headView.backBlock = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        view.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(5)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.listView.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.refreshMessageInfo()
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            await refreshMessageInfo()
        }
    }

}

extension AuthListViewController {
    
    private func refreshMessageInfo() async {
        Task {
            do {
                let dict = ["shot": productID]
                let model = try await viewModel.productDetailInfo(json: dict)
                if model.token == 0 {
                    self.listView.model = model
                    self.headView.nameLabel.text = model.kindness?.pavement?.silently ?? ""
                }
                self.listView.tableView.reloadData()
                await self.listView.tableView.mj_header?.endRefreshing()
            } catch {
                await self.listView.tableView.mj_header?.endRefreshing()
            }
        }
    }
    
}
