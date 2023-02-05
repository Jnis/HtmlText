//
//  HtmlText.swift
//  
//
//  Created by Yanis Plumit on 05.02.2023.
//

import SwiftUI
import WebKit

public struct HtmlText: View {
    @State private var dynamicHeight: CGFloat = .zero
    let html: String
    let linkTap: ((URL) -> Void)?
    
    @available(*, deprecated, message: "Use HtmlText(body:css:linkTap:). Or be careful to use this method. You must configure html header, otherwise size of view will getting bigger all the time.")
    public init(html: String, linkTap: ((URL) -> Void)?) {
        self.html = html
        self.linkTap = linkTap
    }
    
    public var body: some View {
        HtmlTextWebView(dynamicHeight: $dynamicHeight, html: html, linkTap: linkTap)
            .frame(height: dynamicHeight)
    }
}

struct HtmlTextWebView: UIViewRepresentable {
    @Binding var dynamicHeight: CGFloat
    let html: String
    let linkTap: ((URL) -> Void)?
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.bounces = false
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.scrollView.backgroundColor = UIColor.clear
        DispatchQueue.main.async {
            let bundleURL = Bundle.main.bundleURL
            webView.loadHTMLString(html, baseURL: bundleURL)
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        DispatchQueue.main.async {
            let bundleURL = Bundle.main.bundleURL
            uiView.loadHTMLString(html, baseURL: bundleURL)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension HtmlTextWebView {
    class Coordinator: NSObject, WKNavigationDelegate {
        let criticalHeight: CGFloat = 99999
        var parent: HtmlTextWebView
        
        init(_ parent: HtmlTextWebView) {
            self.parent = parent
        }
        
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, _) in
                DispatchQueue.main.async {
                    let scrollHeight = height as! CGFloat
                    if scrollHeight < self.criticalHeight {
                        self.parent.dynamicHeight = scrollHeight
                    } else {
                        assertionFailure("Can you check you CSS and HTML? Looks like it's getting bigger all the time. If you use HtmlText(html:), I recommend to use HtmlText(body:css:) from HtmlText+CSS")
                    }
                }
            })
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard navigationAction.navigationType == WKNavigationType.linkActivated,
                  var url = navigationAction.request.url else {
                decisionHandler(WKNavigationActionPolicy.allow)
                return
            }
            
            if url.scheme == nil {
                guard let httpsURL = URL(string: "https://\(url.absoluteString)") else { return }
                url = httpsURL
            }
            
            self.parent.linkTap?(url)
            decisionHandler(WKNavigationActionPolicy.cancel)
        }
    }
}
