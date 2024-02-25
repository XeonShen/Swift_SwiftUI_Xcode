import SwiftUI

struct HomeV: View {
    @State private var buttonIsGlowing = false
    @State private var titleIsShowing = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                
//MARK: - Background Image
                
                Image("BackgroundLeaf")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
//MARK: - spacer
                
                VStack {
                    Spacer()
                    Spacer()
                    
//MARK: - App Title
                    
                    Image("AppTitle")
                        .resizable()
                        .frame(width: 600, height: 100)
                        .opacity(titleIsShowing ? 1 : 0)
                        .offset(x: titleIsShowing ? 0 : 400)
                        .onAppear {
                            withAnimation(Animation.spring(response: 0.45, dampingFraction: 0.65, blendDuration: 0.5).delay(1)) {
                                titleIsShowing = true
                            }
                        }
                    
//MARK: - Spacer
                    
                    Spacer()
                    
//MARK: - Single Player View
                    
                    NavigationLink(destination: SinglePlayerV()) {
                        Text("Single Player")
                            .font(.title)
                            .bold()
                            //make button glowing
                            .foregroundStyle(buttonIsGlowing ? .green.opacity(0.2) : .green.opacity(1))
                            .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: buttonIsGlowing)
                            .onAppear{ buttonIsGlowing = true }
                    }
                    .padding(.horizontal, 80)
                    .padding(.vertical, 20)
                    //make button blur
                    .background(BlurView(style: .systemMaterial, opacity: 0.75))
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .overlay(
                        Text("🙋‍♀️")
                            .font(.system(size: 85))
                            .offset(x: -140, y: -6)
                    )
                    
//MARK: - Spacer
                    
                    Spacer()
                    
//MARK: - Multi Player View
                    
                    NavigationLink(destination: MultiPlayerV()) {
                        Text("Multi Player")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.blue)
                    }
                    .padding(.horizontal, 80)
                    .padding(.vertical, 20)
                    .background(BlurView(style: .systemMaterial, opacity: 0.75))
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .overlay(
                        ZStack {
                            Text("🙋‍♀️")
                                .font(.system(size: 85))
                                .offset(x: -120, y: -6)
                            Text("🙋")
                                .font(.system(size: 85))
                                .offset(x: -155, y: -6)
                        }
                    )
                    
//MARK: - Spacer
                    
                    Spacer()
                    
//MARK: - Items Intro View
                    
                    NavigationLink(destination: ItemsIntroV()) {
                        Text("Items Intro")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.blue)
                    }
                    .padding(.horizontal, 80)
                    .padding(.vertical, 20)
                    .background(BlurView(style: .systemMaterial, opacity: 0.75))
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .overlay(
                        Text("📦")
                            .font(.system(size: 85))
                            .offset(x: -140, y: 0)
                    )
                    
                    
//MARK: - Spacer
                    
                    Spacer()
                    
//MARK: - About View
                    
                    NavigationLink(destination: AboutV()) {
                        Text("About")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.blue)
                    }
                    .padding(.horizontal, 80)
                    .padding(.vertical, 20)
                    .background(BlurView(style: .systemMaterial, opacity: 0.75))
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .overlay(
                        Text("👨🏻‍💻")
                            .font(.system(size: 85))
                            .offset(x: -120, y: -6)
                    )
                    
//MARK: - Spacer
                    
                    Spacer()
                    Spacer()
                }
            }
            .preferredColorScheme(.light)
            .statusBar(hidden: true)
        }
    }
}

//MARK: - Make a Gaussian Blur effect; adjust blur intensity by an opacity layer

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    var opacity: CGFloat
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        view.alpha = opacity
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
        uiView.alpha = opacity
    }
}

#Preview {
    HomeV()
}
