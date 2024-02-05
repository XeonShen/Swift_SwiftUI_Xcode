import SwiftUI
import Foundation

struct CardConstants {
    static let color = Color.red
    static let aspectRatio: CGFloat = 2 / 3
    static let dealDuration: Double = 0.5
    static let totalDealDuration: Double = 2
    static let undealtHeight: CGFloat = 90
    static let undealtWidth = undealtHeight * aspectRatio
}

struct DrawingConstants {
    static let fontScale: CGFloat = 0.7
    static let fontSize: CGFloat = 32
}

func scale(thatFits size: CGSize) -> CGFloat {
    min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
}

extension Array {
    var oneAndOnly: Element? {
        if self.count == 1 {
            return self.first
        } else {
            return nil
        }
    }
}
