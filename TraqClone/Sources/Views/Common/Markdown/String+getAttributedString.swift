import Foundation

public extension String {
    func getAttributedString() -> AttributedString {
        do {
            var attributedString: AttributedString
            if #available(iOS 16, *) {
                attributedString = try AttributedString(
                    markdown: self,
                    options: AttributedString.MarkdownParsingOptions(
                        allowsExtendedAttributes: true,
                        interpretedSyntax: .inlineOnlyPreservingWhitespace,
                        failurePolicy: .returnPartiallyParsedIfPossible,
                        languageCode: nil,
                        appliesSourcePositionAttributes: true
                    )
                )
            } else {
                attributedString = try AttributedString(markdown: self)
            }
            return attributedString
        } catch {
            print("Couldn't parse: \(error)")
        }
        return AttributedString("Error parsing markdown")
    }
}
