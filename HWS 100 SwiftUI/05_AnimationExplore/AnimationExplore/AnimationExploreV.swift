import SwiftUI

struct AnimationExploreV: View {
    
//MARK: - Constants and Vars
    
    @State private var buttonEnable = false
    
    let letters = Array("Hello SwiftUI")
    @State private var textEnable = false
    @State private var dragAmount = CGSize.zero
    @State private var isHodingText = false
    
    @State private var isTappedSquare = false
    
//MARK: - Body components
    
    var aButton: some View {
        Button("Tap me") {
            buttonEnable.toggle()
        }
        .frame(width: 200, height: 100)
        .background(buttonEnable ? .blue : .red)
        .foregroundStyle(.white)
        .animation(.default, value: buttonEnable)
        .clipShape(RoundedRectangle(cornerRadius: buttonEnable ? 80 : 20))
        .animation(.spring(response: 1, dampingFraction: 1), value: buttonEnable)
    }
    
    var aText: some View {
        HStack(spacing: 0) {
            ForEach(0..<letters.count, id: \.self) { index in
                Text(String(letters[index]))
                    .padding(3)
                    .font(.headline)
                    .background(textEnable ? .blue : .red)
                    .offset(dragAmount)
                    .animation(.linear.delay(Double(index) / 20), value: dragAmount)
                    
            }
        }
        .gesture(
            DragGesture()
                .onChanged {
                    withAnimation {
                        isHodingText = true
                    }
                    dragAmount = $0.translation
                }
                .onEnded { _ in
                    withAnimation {
                        isHodingText = false
                    }
                    dragAmount = .zero
                    textEnable.toggle()
                }
        )
    }
    
    var aSquare: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 100, height: 100)
            if isTappedSquare {
                Rectangle()
                    .fill(.red)
                    .frame(width: 100, height: 100)
                    .transition(.pivot)
            }
        }
        .onTapGesture {
            withAnimation {
                isTappedSquare.toggle()
            }
        }
    }
    
//MARK: - Body
    
    var body: some View {
        VStack {
            Spacer()
            if !isHodingText { aButton }
            Spacer()
            aText
            Spacer()
            aSquare
            Spacer()
        }
    }
}

//MARK: - ViewModifiers

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(active: CornerRotateModifier(amount: -90, anchor: .topLeading),
                  identity: CornerRotateModifier(amount: 0, anchor: .topLeading))
    }
}

//MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AnimationExploreV()
    }
}
