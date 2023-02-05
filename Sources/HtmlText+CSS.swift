//
//  HtmlText+CSS.swift
//  
//
//  Created by Yanis Plumit on 05.02.2023.
//

import Foundation
import SwiftUI

public extension HtmlText {
     init(body: String, css: CSS, linkTap: ((URL) -> Void)?) {
        self.init(html: css.makeHtml(bodyString: body), linkTap: linkTap)
    }
}

public extension HtmlText {
    struct FontFace {
        let fontName: String
        let fileName: String
        
        func fontFace() -> String {
            if fileName.lowercased().hasSuffix(".ttf") {
                return "@font-face { font-family: '\(fontName)'; src: url('\(fileName)') format('truetype'); }"
            }
            if fileName.lowercased().hasSuffix(".otf") {
                return "@font-face { font-family: '\(fontName)'; src: url('\(fileName)') format('opentype'); }"
            }
            assertionFailure("unknown font type")
            let fileExtension = String(fileName.split(separator: ".").last ?? "")
            return "@font-face { font-family: '\(fontName)'; src: url('\(fileName)') format('\(fileExtension)'); }"
        }
    }
}

public extension HtmlText {
    struct CSS {
        let fontFaces: [FontFace]
        let css: String
        
        public init(fontFaces: [FontFace], css: String) {
            self.fontFaces = fontFaces
            self.css = css
        }
        
        public func makeHtml(bodyString: String) -> String {
            let fontFaces: [String] = self.fontFaces.map { $0.fontFace() }
            let fullHTML = """
        <!doctype html>
         <html>
            <head>
              <meta name='viewport' content='width=device-width, shrink-to-fit=YES, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>
              <style>
                \(css)
                \(fontFaces.joined(separator: "\n"))
              </style>
            </head>
            <body>
              \(bodyString)
            </body>
          </html>
        """
            return fullHTML
        }
    }
}
