//
//  WebViewController.swift
//  one
//
//  Created by sidney on 2021/7/4.
//

import UIKit
import WebKit

class WebViewController: BaseViewController, WKNavigationDelegate {

    var webView: WKWebView = WKWebView()
    var url: String = "" {
        didSet {
            self.webView.load(URLRequest(url: URL(string: url)!))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (maker) in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        print(Date())
    }

}
