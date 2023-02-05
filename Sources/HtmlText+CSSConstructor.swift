//
//  HtmlText+CSSConstructor.swift
//  
//
//  Created by Yanis Plumit on 05.02.2023.
//

import Foundation
import UIKit
import SwiftUI

public extension HtmlText.CSS {
    class Constructor {
        var fontFaces: [HtmlText.FontFace] = []
        var fontFamily = ""
        var fontSize = ""
        var lineHeight = ""
        var letterSpacing = ""
        var textIndent = ""
        var textColor = ""
        var paragraphPadding = ""
        var linkColor = ""
        var linkDecoration = ""
        var listPadding = ""
        
        public init() {}
        
        public func text(fontName: String, fileName: String?, size: CGFloat, lineHeight: CGFloat, letterSpacing: CGFloat, textIndent: CGFloat, color: Color) -> Constructor {
            self.fontFamily = "font-family: \(fontName);"
            self.fontSize = "font-size: \(size)px;"
            self.lineHeight = "line-height: \(lineHeight)px;"
            self.textColor = "color:#\(color.toHex(alpha: true) ?? "");"
            self.letterSpacing = "letter-spacing: \(letterSpacing)px;"
            self.textIndent = "text-indent: \(textIndent)px;"
            self.fontFaces = {
                guard let fileName = fileName else { return [] }
                return [.init(fontName: fontName, fileName: fileName)]
            }()
            return self
        }
        
        public func link(color: Color, underlined: Bool) -> Constructor {
            self.linkColor = "color:#\(color.toHex(alpha: true) ?? "");"
            self.linkDecoration = underlined ? "" : "a {text-decoration: none;}"
            return self
        }
        
        public func list(padding: UIEdgeInsets) -> Constructor {
            listPadding =
            """
            padding-left: \(padding.left)px;
            padding-top: \(padding.top)px;
            padding-right: \(padding.right)px;
            padding-bottom: \(padding.bottom)px;
            """
            return self
        }
        public func paragraph(padding: UIEdgeInsets) -> Constructor {
            paragraphPadding =
            """
            padding-left: \(padding.left)px;
            padding-top: \(padding.top)px;
            padding-right: \(padding.right)px;
            padding-bottom: \(padding.bottom)px;
            """
            return self
        }
    }
    
    init(constructor: Constructor) {
        self.init(fontFaces: constructor.fontFaces, css:
            """
            * {
                padding: 0px;
                margin: 0px;
                \(constructor.fontFamily)
                \(constructor.fontSize)
                \(constructor.lineHeight)
                \(constructor.textColor)
                \(constructor.letterSpacing)
                \(constructor.textIndent)
            }
            p {
                \(constructor.paragraphPadding)
            }
            ul, ol {
                \(constructor.listPadding)
                text-indent: 0px;
            }
            li {
                text-indent: 0px;
            }
            \(constructor.linkDecoration)
            a:link {\(constructor.linkColor);}
            a:visited {\(constructor.linkColor);}
            a:active {color:#000000;}
            """
        )
    }
    
}
