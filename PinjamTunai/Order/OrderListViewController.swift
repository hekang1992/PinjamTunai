//
//  OrderListViewController.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/6.
//

import UIKit
import SnapKit
import MJRefresh

class OrderListViewController: BaseViewController {
    
    lazy var orderListView: OrderListView = {
        let orderListView = OrderListView()
        return orderListView
    }()
    
    let viewModel = OrderListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(orderListView)
        orderListView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
        
        
        self.orderListView.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.getListInfo()
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.getListInfo()
        }
    }

}

extension OrderListViewController {
    
    private func getListInfo() async {
        Task {
            do {
                let json = ["sweetly": "4"]
                let model = try await viewModel.getOrderListInfo(json: json)
                if model.token == 0 {
                    self.orderListView.modelArray = model.kindness?.flew ?? []
                }
                self.orderListView.tableView.reloadData()
                await self.orderListView.tableView.mj_header?.endRefreshing()
            } catch {
                await self.orderListView.tableView.mj_header?.endRefreshing()
            }
        }
    }
    
}
