import SwiftUI

extension View {
    func `if`<T: View>(_ conditional: Bool, transform: (Self) -> T) -> some View {
        Group {
            if conditional {
                transform(self)
            } else { self }
        }
    }
}
