//
//  ContentView.swift
//  Examples
//
//  Created by Yanis Plumit on 11.11.2022.
//

import SwiftUI
import HtmlText

enum FrontNames: String {
    case someSystem = "Copperplate"
    case regular = "Waltograph"
    case bold = "WaltographUI-Bold"
    
    var fontName: String { rawValue }
    var fileName: String? {
        switch self {
        case .someSystem: return nil
        case .regular: return "waltograph42.otf"
        case .bold: return "waltographUI.ttf"
        }
    }
}

extension HtmlText {
    init(body: String, font: FrontNames, size: CGFloat, lineHeight: CGFloat, textColor: Color) {
        self.init(body: body,
                  css: HtmlText.CSS(constructor: CSS.Constructor()
                    .text(fontName: font.fontName,
                          fileName: font.fileName,
                          size: size,
                          lineHeight: lineHeight,
                          letterSpacing: 0,
                          textIndent: 10,
                          color: textColor)
                        .link(color: .red, underlined: false)
                        .paragraph(padding: .init(top: 10, left: 0, bottom: 0, right: 0))
                        .list(padding: .init(top: 10, left: 24, bottom: 10, right: 0))
                        .customCSS("*{ }")
                  ),
                  linkTap: HtmlText.defaultLinkTapHandler(httpLinkTap: .openSFSafariModal))
    }
}


struct ContentView: View {
    
    var body: some View {
        ScrollView {
            Text("Example 1 (system font)").background(.black).foregroundColor(.white)
            HtmlText(body: Constants.demoHtml,
                     font: .someSystem,
                     size: 12,
                     lineHeight: 20,
                     textColor: Color.gray)

            Text("Example 2 (otf)").background(.black).foregroundColor(.white)
            HtmlText(body: Constants.demoHtml,
                     font: .regular,
                     size: 12,
                     lineHeight: 20,
                     textColor: Color.gray)

            Text("Example 3 (ttf)").background(.black).foregroundColor(.white)
            HtmlText(body: Constants.demoHtml,
                     font: .bold,
                     size: 12,
                     lineHeight: 20,
                     textColor: Color.gray)
        }
        .padding()
        .onAppear {
            printFonts()
        }
    }
    
    func printFonts() {
        for familyName in UIFont.familyNames {
            print("--- \(familyName)")
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print("   \(fontName)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
