//
//  FBGText.swift
//  AttributedString
//
//  Created by Andrew Cunningham on 2/29/24.
//

import SwiftUI

struct FBGText: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Text("**Text in bold**")
        Text("*Text in italic*")
        Text("~This text is crossed out~")
        Text("Find out more about [this app here](http://www.google.com)")


        // Underline
        Text("Underlined").underline()

        CustomText(convertMarkdown("Find out more about \n \t [this app here](http://www.google.com)"))

        CustomText(convertMarkdown("^[custom](customColor: 'red') text"))
        CustomText(convertMarkdown("^[custom](customColor: 'green') text"))
        CustomText(convertMarkdown("^[custom](customColor: 'yellow') text"))
    }

    private func convertMarkdown(_ string: String) -> AttributedString {
        guard var attributedString = try? AttributedString(
            markdown: string,
            including: AttributeScopes.CustomAttributes.self,
            options: AttributedString.MarkdownParsingOptions(
                allowsExtendedAttributes: true,
                interpretedSyntax: .inlineOnlyPreservingWhitespace)) else {
            return AttributedString(string)
        }

        return attributedString
    }
}

#Preview {
    FBGText()
}

public struct CustomText: View {
    private var attributedString: AttributedString
    private var font: Font = .system(.body)

    @Environment(\.openURL) var openURL

    public var body: some View {
        Text(attributedString)
            .environment(\.openURL, OpenURLAction { url in
                  print("custom URL handling: \(url)") // do what you like
                  return .handled  // compiler won't launch Safari
           })
    }

    public init(_ attributedString: AttributedString) {
        self.attributedString = CustomText.annotateCustomAttributes(from: attributedString)
    }

    public init(_ localizedKey: String.LocalizationValue) {
        attributedString = CustomText.annotateCustomAttributes(
            from: AttributedString(localized: localizedKey, including: \.customAttributes))
    }

    public func font(_ font: Font) -> CustomText {
        var selfText = self
        selfText.font = font
        return selfText
    }

    private static func annotateCustomAttributes(from source: AttributedString) -> AttributedString {
        var attrString = source
        print(attrString)

        for run in attrString.runs {
            if let link = run.link {
                print(link)
                attrString[run.range].underlineStyle = Text.LineStyle(nsUnderlineStyle: .single)
                attrString[run.range].foregroundColor = .black
            }


            guard run.customColor != nil else {
                continue
            }
            let range = run.range
            if let value = run.customColor {
                if value == .yellow {
                    attrString[range].foregroundColor = .yellow
                } else if value == .green {
                    attrString[range].foregroundColor = .green
                } else if value == .red {
                    attrString[range].foregroundColor = .red
                }
            }
        }

        return attrString
    }
}
