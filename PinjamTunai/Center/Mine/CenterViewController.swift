//
//  CenterViewController.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/6.
//

import UIKit
import SnapKit
import MJRefresh

class CenterViewController: BaseViewController {
    
    lazy var centerView: CenterView = {
        let centerView = CenterView(frame: .zero)
        return centerView
    }()
    
    let viewModel = CenterViewModel()
    
    var model: BaseModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.centerView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.getMineInfo()
            }
        })
        
        self.centerView.cellBlock = { [weak self] model in
            guard let self = self else { return }
            let pageUrl = model.whistling ?? ""
            if pageUrl.contains(scheme_url) {
                AppRouteConfig.handleRoute(pageUrl: pageUrl, viewController: self)
            }else {
                let webVc = WebsiteViewController()
                webVc.pageUrl = pageUrl
                self.navigationController?.pushViewController(webVc, animated: true)
            }
        }
        
        self.centerView.mentBlock = { [weak self] in
            guard let self = self else { return }
            let webVc = WebsiteViewController()
            let pageUrl = self.model?.kindness?.other_url?.service_url ?? ""
            webVc.pageUrl = pageUrl
            self.navigationController?.pushViewController(webVc, animated: true)
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.getMineInfo()
        }
    }
    
}

extension CenterViewController {
    
    private func getMineInfo() async {
        Task {
            do {
                let json = ["spot" : "1"]
                let model = try await viewModel.centerInfo(json: json)
                if model.token == 0 {
                    self.model = model
                    self.centerView.phoneLabel.text = model.kindness?.userInfo?.lose ?? ""
                    self.centerView.modelArray = model.kindness?.flew ?? []
                }
                self.centerView.tableView.reloadData()
                await self.centerView.scrollView.mj_header?.endRefreshing()
            } catch {
                await self.centerView.scrollView.mj_header?.endRefreshing()
            }
        }
    }
    
}
