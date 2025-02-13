//
//  AuthViewController.swift
//  TuneSphere
//
//  Created by Srilu Rao on 1/29/25.
//

import UIKit
import WebKit// to embed a webbrowser

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    private let webView:WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let wkwebView = WKWebView(frame: .zero, configuration: config)
        
        return wkwebView
    }()
    
    public var completionHandler : ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "SignIn"
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        guard let url = AuthManager.shared.signInURL else{
            return
        }
        webView.load(URLRequest(url:url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
        
    }
    
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        guard let url = webView.url else {
//            print("No URL found")
//            return
//        }
//        
//        // Print the URL for debugging purposes
//        print("URL: \(url.absoluteString)")
//        
//        // Parse the URL to extract query items
//        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
//           let queryItems = components.queryItems {
//            
//            // Find the 'code' query item
//            if let code = queryItems.first(where: { $0.name == "code" })?.value {
//                print("Code: \(code)")
//            } else {
//                print("No code found in the URL")
//            }
//        } else {
//            print("Failed to parse URL components")
//        }
//    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // Get the URL from the navigation action
        if let url = navigationAction.request.url {
            // Check if this is the redirect URL
            if url.scheme == "spotify-ios-quick-start" && url.host == "spotify-login-callback" {
                // Parse the URL to extract the 'code' parameter
                if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                   let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                    webView.isHidden = true
                    print("Code: \(code)")
                    AuthManager.shared.exchangeCodeForToken(code: code) { [weak self]sucess in
                        DispatchQueue.main.async{
                            self?.navigationController?.popToRootViewController(animated: true)
                            self?.completionHandler?(sucess)
                        }
                        
                    }
                    // Handle the code (e.g., exchange it for an access token)
                } else {
                    print("No code found in the redirect URL")
                }
                // Prevent the web view from loading the redirect URL
                decisionHandler(.cancel)
                return
            }
        }
        // Allow the web view to load other URLs
        decisionHandler(.allow)
    
    }
    

}
