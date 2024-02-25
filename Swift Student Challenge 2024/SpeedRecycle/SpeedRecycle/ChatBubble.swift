import SwiftUI

struct ChatBubble: View {
    var itemDescription: String
    var bubbleColor: Color
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Text(itemDescription)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(bubbleColor)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(BubbleTail()
                            .fill(bubbleColor)
                            .frame(width: 25, height: 22)
                            .offset(x: 9, y: -18),
                         alignment: .bottomTrailing
                )
        }
    }
}

struct BubbleTail: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.maxY),
                      control1: CGPoint(x: rect.minX - 5, y: rect.maxY),
                      control2: CGPoint(x: rect.minX, y: rect.minY + 30))

        return path
    }
}

