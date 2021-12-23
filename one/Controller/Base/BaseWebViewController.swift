//
//  BaseWebViewController.swift
//  one
//
//  Created by sidney on 2021/4/24.
//

import UIKit
import WebKit

class BaseWebViewController: BaseViewController, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate, WKURLSchemeHandler {
    
    var url = "https://www.baidu.com"
    var urlSchemeTaskStatusDict: [String: Bool] = [:]
    
    lazy var webView: WKWebView = {
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = WKPreferences()
        configuration.preferences.minimumFontSize = 12.0
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.userContentController = WKUserContentController()
        if self.url == "https://www.baidu.com" {
            configuration.setURLSchemeHandler(self, forURLScheme: "http")
            configuration.setURLSchemeHandler(self, forURLScheme: "https")
        }
        if #available(iOS 13.0, *) {
            configuration.defaultWebpagePreferences.preferredContentMode = .mobile
        }
        let jsStr = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let wkUserScript = WKUserScript(source: jsStr, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(wkUserScript)
        let _webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        _webView.allowsBackForwardNavigationGestures = true
        _webView.backgroundColor = UIColor.clear
        _webView.navigationDelegate = self
        _webView.uiDelegate = self
        _webView.scrollView.delegate = self
        _webView.scrollView.pinchGestureRecognizer?.isEnabled = false
        
        return _webView
    }()
    
    lazy var progressView: UIProgressView = {
        let _progressView = UIProgressView(frame: .zero)
        _progressView.tintColor = UIColor(named: "#7977FF")     // 进度条颜色
        _progressView.trackTintColor = UIColor.white // 进度条背景色

        return _progressView
    }()
    
    class func create(with url: String) -> BaseWebViewController {
        let vc = BaseWebViewController()
        vc.url = url
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "浏览器页面"
        setCustomNav()
        setWebView()
        var url = self.url
        url = self.interceptUrl(url: url)
        webView.load(URLRequest(url: URL(string: url)!))
        print("didload: \(Date())")
        // Do any additional setup after loading the view.
    }

    func setWebView() {
        view.addSubview(webView)
        webView.snp.makeConstraints { (maker) in
            maker.top.equalTo(navigationView.snp.bottom)
            maker.leading.trailing.bottom.equalToSuperview()
        }
        view.addSubview(progressView)
        progressView.snp.makeConstraints { (maker) in
            maker.top.equalTo(navigationView.snp.bottom)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(2)
        }
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressView.alpha = 1.0
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }, completion: { (finish) in
                    self.progressView.setProgress(0.0, animated: false)
                })
            }
        }
    }
    
    // 拦截图片并替换为自定义图片
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        let requestUrlStr = urlSchemeTask.request.url!.absoluteString
        print(requestUrlStr)
        
        if let urlSchemeTaskStarted = self.urlSchemeTaskStatusDict[requestUrlStr] {
            if urlSchemeTaskStarted {
                return
            }
        }
        self.urlSchemeTaskStatusDict[requestUrlStr] = true
        let request = urlSchemeTask.request
        let url = request.url?.absoluteString
        if let url = url {
            if url.hasPrefix("https://www.baidu.com") && url.contains(".png") {
                print("enter start: \(String(describing: url))")
                urlSchemeTask.didReceive(URLResponse())
                do {
                    try urlSchemeTask.didReceive(Data(contentsOf: URL(string: MockService.shared.getRandomImg())!))
                } catch (_) {
                    
                }
                urlSchemeTask.didFinish()
                return
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) {[weak urlSchemeTask] data, response, error in
            guard let urlSchemeTask = urlSchemeTask else {
                return
            }
            if data == nil {
                urlSchemeTask.didReceive(URLResponse())
                do {
                    try urlSchemeTask.didReceive(Data(contentsOf: URL(string: MockService.shared.getRandomImg())!))
                } catch (_) {
                    
                }
            } else {
                if let response = response {
                    urlSchemeTask.didReceive(response)
                }
                if let data = data {
                    urlSchemeTask.didReceive(data)
                }
            }
            urlSchemeTask.didFinish()
        }
        task.resume()
    }
    
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        self.urlSchemeTaskStatusDict[urlSchemeTask.request.url!.absoluteString] = false
        let request = urlSchemeTask.request
        let url = request.url?.absoluteString
        print("enter stop url: \(String(describing: url))")
        return
    }
    
    func loadHTMLString(_ html: String) {
        let jsStr = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let wkUserScript = WKUserScript(source: jsStr, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(wkUserScript)
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    // 对webView的url进行黑名单替换拦截
    func interceptUrl(url: String) -> String {
        if WebService.shared.isUrlInBlackList(url: url) {
            return "https://www.baidu.com"
//            return "https://h5plus.dewu.com/post?postsId=66902177&477zitijianju=0"
        }
        return url
    }
}
