//
//  ViewController.swift
//  MyWebView
//
//  Created by MyeongJin on 2021/02/17.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    //MARK: - Properties
    //MARK: IBOutlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Methods
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.webView.navigationDelegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let firstPageURL: URL?
        
        if let lastURL: URL = UserDefaults.standard.url(forKey: lastPageURLDefaultKey){
            firstPageURL = lastURL
        } else {
            firstPageURL = URL(string: "https://www.google.com")
        }
        
        guard let pageURL: URL = firstPageURL else {
            return
        }
        
        let urlRequest: URLRequest = URLRequest(url: pageURL)
        self.webView.load(urlRequest)
    }
    
    // MARK: IBActions
    @IBAction func gobakck(_ sender: UIBarButtonItem) {
        self.webView.goBack()
    }
    
    @IBAction func goForward(_ sender: UIBarButtonItem) {
        self.webView.goForward()
    }
    
    @IBAction func goRefesh(_ sender: UIBarButtonItem) {
        self.webView.reload()
        
    }
    
    // MARK: Custom Methods
    func showNetworkingIndicators() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func hideNetworkingIndicators() {
        self.activityIndicator.isHidden = true
        self.activityIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension ViewController: WKNavigationDelegate {
    
    //MARK: WKNaviagtionDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("did finish navigation")
        
        if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.lastPageURL = webView.url
        }
        
        webView.evaluateJavaScript("document.title") { (value: Any?, error: Error?) in
            if let error: Error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let title: String = value as? String else {
                return
            }
            
            self.navigationItem.title = title
        }
        self.hideNetworkingIndicators()
    }
    
    func webView(_ webView: WKWebView, didFail navigatio: WKNavigation!, withError error: Error){
        print("did fail navigation")
        print("\(error.localizedDescription)")
        
        self.hideNetworkingIndicators()
        let message: String = "오류발생!\n" + error.localizedDescription
        
        let alert: UIAlertController
        alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        
        let okayAction: UIAlertAction
        okayAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        
        alert.addAction(okayAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
