import SwiftUI
import SpriteKit

struct MultiPlayerV: View {
    @ObservedObject var playerOneGameData = PlayerGameData()
    @ObservedObject var playerTwoGameData = PlayerGameData()

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    
//MARK: - 2 Game Scenes
                    
                    VStack {
                        SpriteView(scene: { let scene = PlayerGameScene()
                            scene.size = CGSize(width: geometry.size.width,
                                                height: geometry.size.height / 2)
                            scene.scaleMode = .fill
                            scene.playerGameData = playerOneGameData
                            return scene }())
                        .frame(width: geometry.size.width, height: geometry.size.height / 2)
                        .colorMultiply(playerOneGameData.gameIsStart ? .white : .red.opacity(0.6))
                        .disabled(!playerOneGameData.gameIsStart)
                        
                        SpriteView(scene: { let scene = PlayerGameScene()
                            scene.size = CGSize(width: geometry.size.width,
                                                height: geometry.size.height / 2)
                            scene.scaleMode = .fill
                            scene.playerGameData = playerTwoGameData
                            return scene }())
                        .frame(width: geometry.size.width, height: geometry.size.height / 2)
                        .colorMultiply(playerTwoGameData.gameIsStart ? .white : .blue.opacity(0.6))
                        .disabled(!playerTwoGameData.gameIsStart)
                    }
                    
//MARK: - Score Title
                    
                    Group {
                        Text(" \(playerOneGameData.score) ")
                            .font(.system(size: 35))
                            .foregroundColor(.red) +
                        Text(" <- Player One Score ") +
                        Text("| Player Two Score -> ") +
                        Text(" \(playerTwoGameData.score) ")
                            .font(.system(size: 35))
                            .foregroundColor(.red)
                    }
                    .font(.system(size: 30))
                    .bold()
                    .padding(15)
                    .foregroundStyle(.white)
                    .background(.yellow)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .rotationEffect(Angle(degrees: 90))
                    .offset(x: geometry.size.width / 2 - 100)

//MARK: - Buttons
                    
                    Button("Start Game") {
                        playerOneGameData.gameIsStart = true
                        playerTwoGameData.gameIsStart = true
                    }
                    .font(.system(size: 30))
                    .padding(18)
                    .foregroundStyle(.white)
                    .background((playerTwoGameData.gameIsStart || playerOneGameData.gameIsStart) ? .gray : .blue)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .rotationEffect(Angle(degrees: 90))
                    .offset(x: geometry.size.width / 2 - 100, y: -470)
                    .disabled(playerTwoGameData.gameIsStart || playerOneGameData.gameIsStart)
                }
                
//MARK: - Show Congrats Screen
                
                .fullScreenCover(isPresented: $playerOneGameData.playerWin) {
                    if playerTwoGameData.gameIsStart == true {
                        MultiPlayerWinV(congretsWord: "Congratulations, Player One!")
                    }
                    if playerTwoGameData.gameIsStart == false {
                        MultiPlayerWinV(isWin: false, congretsWord: "You can do it better Player One!")
                    }
                }
                .fullScreenCover(isPresented: $playerTwoGameData.playerWin) {
                    if playerOneGameData.gameIsStart == true {
                        MultiPlayerWinV(congretsWord: "Congratulations, Player Two!")
                    }
                    if playerOneGameData.gameIsStart == false {
                        MultiPlayerWinV(isWin: false, congretsWord: "You can do it better Player Two!")
                    }
                }
                
            }
            .edgesIgnoringSafeArea(.all)
        }
        .preferredColorScheme(.light)
        .statusBar(hidden: true)
    }
}

#Preview {
    MultiPlayerV()
}
