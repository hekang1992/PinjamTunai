//
//  OrderListViewController.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/6.
//

import UIKit
import SnapKit
import MJRefresh
import RxSwift
import RxCocoa
import RxGesture

class OrderListViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    lazy var orderListView: OrderListView = {
        let orderListView = OrderListView()
        return orderListView
    }()
    
    let viewModel = OrderListViewModel()
    
    var sweetly: String = "4"
    
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
        
        self.orderListView.clickBlock = { [weak self] type in
            guard let self = self else { return }
            self.sweetly = type
            Task {
                await self.getListInfo()
            }
        }
        
        self.orderListView.emptyView.twoLabel
            .rx
            .tapGesture()
            .when(.recognized)
            .bind(onNext: { _ in
                NotificationCenter.default.post(name: NSNotification.Name("changeRootVc"), object: nil)
            })
            .disposed(by: disposeBag)
        
        self.orderListView.cellTapBlock = { [weak self] pageUrl in
            guard let self = self else { return }
            if pageUrl.contains(scheme_url) {
                AppRouteConfig.handleRoute(pageUrl: pageUrl, viewController: self)
            }else {
                let webVc = WebsiteViewController()
                webVc.pageUrl = pageUrl
                self.navigationController?.pushViewController(webVc, animated: true)
            }
        }
        
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
                let json = ["sweetly": sweetly]
                let model = try await viewModel.getOrderListInfo(json: json)
                if model.token == 0 {
                    let modelArray = model.kindness?.flew ?? []
                    self.orderListView.modelArray = modelArray
                    if modelArray.count > 0 {
                        self.showtabView()
                    }else {
                        self.showEmputView()
                    }
                }else {
                    self.showEmputView()
                }
                self.orderListView.tableView.reloadData()
                await self.orderListView.tableView.mj_header?.endRefreshing()
            } catch {
                await self.orderListView.tableView.mj_header?.endRefreshing()
            }
        }
    }
    
    private func showEmputView() {
        self.orderListView.tableView.isHidden = true
        self.orderListView.emptyView.isHidden = false
    }
    
    private func showtabView() {
        self.orderListView.tableView.isHidden = false
        self.orderListView.emptyView.isHidden = true
    }
    
}
