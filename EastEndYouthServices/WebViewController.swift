//
//  WebViewController.swift
//  EastEndYouthServices
//
//  Created by Southampton Dev on 9/14/16.
//  Copyright © 2016 TOS. All rights reserved.
//

import UIKit
import WebKit


class WebViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let fileURL = NSBundle.mainBundle().URLForResource("hotline", withExtension: "html") {
            let request = NSURLRequest(URL: fileURL)
            webView.loadRequest(request)
        }

    }
    
    @IBAction func doRefresh(_: AnyObject) {
        
        webView.reload()
        
    }
    
    
    
    @IBAction func goBack(_: AnyObject) {
        
        webView.goBack()
        
    }
    
    
    
    @IBAction func goForward(_: AnyObject) {
        
        webView.goForward()
        
    }
    
    
    
    @IBAction func stop(_: AnyObject) {
        
        webView.stopLoading()
    }
    
    
    

}