import SwiftUI

extension View {
    func `if`(_ conditional: Bool, transform: (Self) -> some View) -> some View {
        Group {
            if conditional {
                transform(self)
            } else { self }
        }
    }
}
