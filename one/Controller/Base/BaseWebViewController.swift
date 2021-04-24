//
//  BaseWebViewController.swift
//  one
//
//  Created by sidney on 2021/4/24.
//

import UIKit
import WebKit

class BaseWebViewController: BaseViewController, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {
    
    var url = "https://www.baidu.com"
    
    lazy var webView: WKWebView = {
        let _webView = WKWebView()
        _webView.allowsBackForwardNavigationGestures = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = WKPreferences()
        configuration.preferences.minimumFontSize = 12.0
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.userContentController = WKUserContentController()
        if #available(iOS 13.0, *) {
            configuration.defaultWebpagePreferences.preferredContentMode = .mobile
        }
        let jsStr = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let wkUserScript = WKUserScript(source: jsStr, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(wkUserScript)
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
        webView.load(URLRequest(url: URL(string: url)!))
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

    
    func loadHTMLString(_ html: String) {
        let jsStr = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let wkUserScript = WKUserScript(source: jsStr, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(wkUserScript)
        webView.loadHTMLString(html, baseURL: nil)
    }
    
}
