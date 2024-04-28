import SwiftUI

struct CardV: View {
    
//MARK: - Constants & Vars
    
    //check whether the iOS accessibility is enabled
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    
    //card & card removal closure
    let card: Card
    var removal: (() -> Void)? = nil
     
    @State private var isShowingAnswer = false
    
    @State private var offset = CGSize.zero
    
//MARK: - Body
    
    var body: some View {
        ZStack {
            
            //create a card shape, optimized for color binding people
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    accessibilityDifferentiateWithoutColor
                    ? .white
                    : .white.opacity(1 - Double(abs(offset.width / 50)))
                )
                .background(
                    accessibilityDifferentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25).fill(offset.width > 0 ? .green : .red)
                )
                .shadow(radius: 10)
            
            //create card content
            VStack {
                if accessibilityVoiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                }
                else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
            
        }
        
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(offset.width / 5.0))
        .offset(x: offset.width * 5)
        .opacity(2 - Double(abs(offset.width / 50)))
        //if accessibility is enabled, prompt user the card can be tapped
        .accessibilityAddTraits(.isButton)
        
        //drag gesture
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        removal?()
                    } else {
                        offset = .zero
                    }
                }
        )
        
        //tap gesture
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        
        //add animation for card moving
        .animation(.default, value: offset)
    }
}

//MARK: - Preview

#Preview {
    CardV(card: .example)
}
