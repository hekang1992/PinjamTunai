//
//  WebsiteViewController.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/9.
//

import UIKit
import WebKit
import SnapKit
import RxSwift
import RxCocoa
import StoreKit

// MARK: - Constants
private enum Constants {
    static let headerHeight: CGFloat = 40
    static let progressBarHeight: CGFloat = 2
    static let delayedRootChangeTime: DispatchTime = .now() + 0.25
    static let allowedCharacters: CharacterSet = .urlQueryAllowed
    
    enum ScriptMessageName {
        static let goBack = "IOf"
        static let changeRoot = "NoAnd"
        static let handleRoute = "FromMany"
        static let requestReview = "CrabtreeQuoth"
        static let customAction = "AbidingMistake"
    }
    
    enum NotificationName {
        static let changeRootVc = "changeRootVc"
    }
    
    enum Color {
        static let progressTint = "#6D95FC"
        static let trackTint = "#666666"
    }
}

class WebsiteViewController: BaseViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    var pageUrl: String = ""
    
    let locationManager = AppLocationManager()
    
    let trackingViewModel = TrackingViewModel()
    
    // MARK: - UI Components
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let scriptNames = [
            Constants.ScriptMessageName.goBack,
            Constants.ScriptMessageName.handleRoute,
            Constants.ScriptMessageName.changeRoot,
            Constants.ScriptMessageName.requestReview,
            Constants.ScriptMessageName.customAction
        ]
        
        scriptNames.forEach {
            configuration.userContentController.add(self, name: $0)
        }
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = UIColor(hex: Constants.Color.progressTint)
        progressView.trackTintColor = UIColor(hex: Constants.Color.trackTint)
        progressView.isHidden = true
        return progressView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        loadWebContent()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 清除脚本处理器避免循环引用
        webView.configuration.userContentController.removeScriptMessageHandler(forName: Constants.ScriptMessageName.goBack)
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        setupHeaderView()
        setupWebView()
        setupProgressView()
    }
    
    private func setupHeaderView() {
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constants.headerHeight)
        }
        
        headView.backBlock = { [weak self] in
            self?.handleBackAction()
        }
    }
    
    private func setupWebView() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupProgressView() {
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constants.progressBarHeight)
        }
    }
    
    private func setupBindings() {
        bindWebViewTitle()
        bindWebViewProgress()
    }
    
    // MARK: - Binding Methods
    private func bindWebViewTitle() {
        webView.rx.observe(String.self, "title")
            .compactMap { $0 }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] title in
                self?.headView.nameLabel.text = title
            })
            .disposed(by: disposeBag)
    }
    
    private func bindWebViewProgress() {
        webView.rx.observe(Double.self, "estimatedProgress")
            .compactMap { $0 }
            .map { Float($0) }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] progress in
                self?.updateProgress(progress)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateProgress(_ progress: Float) {
        progressView.isHidden = false
        progressView.setProgress(progress, animated: progress > 0.1)
        
        if progress >= 1.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.progressView.isHidden = true
                self?.progressView.setProgress(0.0, animated: false)
            }
        }
    }
    
    // MARK: - Web Content Loading
    private func loadWebContent() {
        guard let finalUrl = constructFinalURL() else {
            return
        }
        
        loadRequest(url: finalUrl)
    }
    
    private func constructFinalURL() -> URL? {
        guard let encodedUrlString = pageUrl.addingPercentEncoding(
            withAllowedCharacters: Constants.allowedCharacters
        ) else { return nil }
        
        let commonParams = ApiPeraConfig.getCommonPara()
        guard let finalUrlString = URLQueryHelper.appendQueries(
            to: encodedUrlString,
            parameters: commonParams
        ) else { return nil }
        
        return URL(string: finalUrlString)
    }
    
    private func loadRequest(url: URL) {
        let request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: 60
        )
        webView.load(request)
    }
    
    // MARK: - Action Handlers
    private func handleBackAction() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
}

// MARK: - WKScriptMessageHandler
extension WebsiteViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        handleScriptMessage(message)
    }
    
    private func handleScriptMessage(_ message: WKScriptMessage) {
        switch message.name {
        case Constants.ScriptMessageName.goBack:
            handleGoBack()
            
        case Constants.ScriptMessageName.changeRoot:
            handleChangeRoot()
            
        case Constants.ScriptMessageName.handleRoute:
            handleRoute(message.body)
            
        case Constants.ScriptMessageName.requestReview:
            handleAppReview()
            
        case Constants.ScriptMessageName.customAction:
            handleCustomAction()
            
        default:
            print("Unhandled script message: \(message.name)")
        }
    }
    
    private func handleGoBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func handleChangeRoot() {
        DispatchQueue.main.asyncAfter(deadline: Constants.delayedRootChangeTime) {
            NotificationCenter.default.post(
                name: Notification.Name(Constants.NotificationName.changeRootVc),
                object: nil
            )
        }
    }
    
    private func handleRoute(_ body: Any) {
        guard let params = body as? [String],
              let routeParam = params.first,
              routeParam.contains(scheme_url) else { return }
        
        AppRouteConfig.handleRoute(pageUrl: routeParam, viewController: self)
    }
    
    private func handleAppReview() {
        requestAppReview()
    }
    
    private func handleCustomAction() {
        locationManager.getCurrentLocation { model in
            LocationManagerModel.shared.model = model
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            Task {
                await self.trackeninemesageInfo()
            }
        }
    }
}

// MARK: - WKNavigationDelegate
extension WebsiteViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("WebView started loading: \(webView.url?.absoluteString ?? "unknown")")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView finished loading: \(webView.url?.absoluteString ?? "unknown")")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("WebView loading error: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView,
                 didFailProvisionalNavigation navigation: WKNavigation!,
                 withError error: Error) {
        print("WebView provisional navigation error: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}

// MARK: - App Review
extension WebsiteViewController {
    private func requestAppReview() {
        guard #available(iOS 14.0, *) else { return }
        
        guard let windowScene = UIApplication.shared
            .connectedScenes
            .first(where: { $0 is UIWindowScene }) as? UIWindowScene else {
            return
        }
        
        SKStoreReviewController.requestReview(in: windowScene)
    }
    
    private func trackeninemesageInfo() async {
        Task {
            do {
                let locationModel = LocationManagerModel.shared.model
                let ajson = ["sure": "9",
                             "thereafter": locationModel?.thereafter ?? "",
                             "leading": locationModel?.leading ?? "",
                             "aelfrida": String(Int(Date().timeIntervalSince1970)),
                             "hair": String(Int(Date().timeIntervalSince1970)),
                             "swear": ""]
                let _ = try await trackingViewModel.saveTrackingMessageIngo(json: ajson)
            } catch  {
                
            }
        }
    }
    
}
