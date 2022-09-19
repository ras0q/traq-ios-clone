import Foundation
import Traq

extension TraqAPI.Message {
    var markdownContent: AttributedString {
        content.getAttributedString()
    }
}
