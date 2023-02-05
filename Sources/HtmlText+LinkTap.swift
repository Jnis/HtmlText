//
//  HtmlText+LinkTap.swift
//  
//
//  Created by Yanis Plumit on 05.02.2023.
//

import SafariServices

public extension HtmlText {
    enum HttpLinkTap {
        case openSafariApp
        case openSFSafariModal
    }
    
    static func defaultLinkTapHandler(httpLinkTap: HttpLinkTap) -> ((URL) -> Void) {
        return { url in
            switch url.scheme {
            case "mailto", "tel":
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            case "http", "https":
                switch httpLinkTap {
                case .openSafariApp:
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                case .openSFSafariModal:
                    let safari = SFSafariViewController(url: url)
                    let vc = UIApplication.topModalViewController
                    vc?.present(safari, animated: true, completion: nil)
                }
            default:
                return
            }
        }
    }
}
