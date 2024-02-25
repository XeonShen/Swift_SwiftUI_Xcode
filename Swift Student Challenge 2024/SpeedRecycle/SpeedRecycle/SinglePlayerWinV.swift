import SwiftUI
import Vortex

struct SinglePlayerWinV: View {
    @Environment(\.dismiss) private var dismiss
    var congretsWord: String

    var body: some View {
        ZStack {
            Color.yellow.opacity(0.1)
                .ignoresSafeArea()
            
            Text("🤩")
                .font(.system(size: 700))
                .offset(x: -UIScreen.main.bounds.width / 2,
                        y: UIScreen.main.bounds.width / 2 - 150)
                .opacity(0.75)
            
            Text("😎")
                .font(.system(size: 700))
                .offset(x: UIScreen.main.bounds.width / 2,
                        y: -(UIScreen.main.bounds.width / 2 - 100))
                .opacity(0.75)
            
            VortexView(.fireworks) {
                Circle()
                    .fill(.white)
                    .blendMode(.plusLighter)
                    .frame(width: 64)
                    .tag("circle")
            }
            
            VStack {
                Text(congretsWord)
                    .font(.system(size: 60))
                    .bold()
                    
                Button("Return") {
                    dismiss()
                }
                .frame(width: 300, height: 80)
                .font(.system(size: 55))
                .bold()
                .foregroundColor(.white)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 35))
                .padding(30)
            }
        }
    }
}

#Preview {
    SinglePlayerWinV(congretsWord: "Congratulations, you did it!")
}
