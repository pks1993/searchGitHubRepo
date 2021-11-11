//
//  WebViewController.swift
//  searchGitHubRepo
//
//  Created by Phyo Kyaw Swar on 11/11/2021.
//

import UIKit
import WebKit
class WebViewController: UIViewController {
    
    @IBOutlet weak var webView : WKWebView?
    
    var navTitle = String()
    var url = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = navTitle
        webView?.load(URLRequest(url: URL(string: url)!))
    }

}

