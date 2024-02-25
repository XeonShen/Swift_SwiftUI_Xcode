import SwiftUI
import Vortex

struct AboutV: View {
    
//MARK: - Properties
    
    @ObservedObject var aboutVM = AboutVM()
    @Environment(\.dismiss) private var dismiss

    @State private var textViewAnimation = [Bool](repeating: false, count: 14)
    
//MARK: - Back Home Button
    
    var backHomeButton: some View {
        Button {
            dismiss()
        } label: {
            HStack {
                Image(systemName: "house")
                Text("Home")
            }
        }
    }
    
//MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                VortexView(.rain) {
                    Circle()
                        .fill(.white)
                        .frame(width: 32)
                        .tag("circle")
                }
                
                VStack {
                    Spacer()
                    Text("About")
                        .font(.system(size: 80))
                        .bold()
                        .foregroundStyle(.white)
                        .padding(30)
                        .opacity(0.7)
                    Spacer()
                    VStack(alignment: .leading) {
                        ForEach(Array(aboutVM.textArray.enumerated()), id:\.offset) { index, text in
                            Text(text)
                                .font(.system(size: 23))
                                .bold()
                                .foregroundStyle(.white)
                                .padding(3)
                                .opacity(textViewAnimation[index] ? 1 : 0)
                                .offset(y: textViewAnimation[index] ? 0 : (UIScreen.main.bounds.height / 10))
                                .onAppear {
                                    withAnimation(Animation.easeInOut(duration: 2).delay(3 * Double(index))) {
                                        textViewAnimation[index] = true
                                    }
                                }
                        }
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                }
            }
            .preferredColorScheme(.light)
            .statusBar(hidden: true)
            
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backHomeButton)
            
            .background(Image("BackgroundRain"))
        }
    }
}

#Preview {
    AboutV()
}
