import SwiftUI

enum ShowGuideOrHome: String {
    case ShowGuide
    case ShowHome
}

struct ShowGuideOrHomeV: View {
    @State var showGuideOrHome = ShowGuideOrHome.ShowGuide
    
    var body: some View {
        switch showGuideOrHome {
        case .ShowGuide:
            GuideV(showGuideOrHome: $showGuideOrHome)
        case .ShowHome:
            HomeV()
        }
    }
}

struct GuideV: View {
    @Binding var showGuideOrHome: ShowGuideOrHome
    @State var guidePage: Int = 1
    
    var body: some View {
        ZStack {
            TabView(selection: $guidePage) {
                
//MARK: - First Guide Page
                
                VStack(alignment: .center) {
                    VStack(alignment: .center) {
                        Group {
                            Text("Hi, welcome to Speed Recycle! I'm the author Xeon 👨🏻‍💻")
                            Text("I made this app to help people take better care of the environment.")
                            Text("To give you a better idea of the app, here are some brief descriptions:")
                                .padding(.bottom, 20)
                            Text("=== Use iPad Pro 12.9 inch for best experience ===")
                                .font(.system(size: 20, design: .serif))
                                .italic()
                        }
                        .font(.system(size: 22, design: .serif))
                    }
                    .padding(20)
                        
                    VStack(alignment: .leading) {
                        Text("Why I made this App?")
                            .font(.system(size: 45))
                            .bold()
                            .padding(.bottom, 20)
                        Group {
                            Text("In the country where I live, the waste separation system has just been introduced and many residents haven't realize the importance of it yet. They tend to mix their garbage, which not only creates problems for the staff involved, but also creates impact on our environment in the long run.\n")
                            Text("As a matter of fact, bins of different categories have long been deployed in the community where I live, and the community even also gives marks to each household per month in order to encourage residents to practise waste separation.\n")
                            Text("But even so, there are still many residents who do not have the awareness of garbage classification, which leads to community workers to door-to-door persuasion from time to time.\n")
                            Text("After learning more from my neighbors, I found that many residents are unable to separate garbage properly because they still lack the knowledge to do so, not because they do it on purpose. To make it easier for them to learn those knowledge, I made this app.")
                        }
                        .font(.system(size: 18, design: .serif))
                    }
                    .padding(40)

                }
                .tag(1)
                
//MARK: - Second Guide
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Group {
                            Text("What this App is about?")
                                .font(.system(size: 45))
                                .bold()
                                .padding(.bottom, 20)
                            Text("In this app, you will learn to sort trash by playing games. There are more than 40 different garbage created within the game and you need to sort them into different categories. (Some of the garbage can be sorted into many categories, and if it is sorted correctly, there will be bonus points.)\n")
                            Text("This app includes single player & multiplayer modes, so have fun with your friends together! Also in the game there are real time advice given by a chat bubble on how to dispose of garbage, which can be realistically applied to your life, so remember to read it.")
                        }
                        .font(.system(size: 20, design: .serif))
                        .padding(.bottom, 20)
                        
                        
                        Text("Key features in the App")
                            .font(.system(size: 45))
                            .bold()
                            .padding(.bottom, 20)
                        
                        HStack(alignment: .top) {
                            Image("Screenshot1")
                                .resizable()
                                .frame(width: 400, height: 540)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.trailing, 20)
                            Text("A Home Screen with an animated title and button, 4 buttons with custom gaussian blur as background. Not only the background leaf image is generated by Stable Diffusion, all the assets in this App was generated by SD by myself!")
                                .font(.system(size: 20, design: .serif))
                        }
                        .padding(.bottom, 40)
                        
                        HStack(alignment: .top) {
                            Image("Screenshot2")
                                .resizable()
                                .frame(width: 400, height: 540)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.trailing, 20)
                            Text("Single player mode with butter smooth animation all around, in this view you need to drag trash icon from the left than drop on the 6 corresponding trashbins on the right.\nThe center item in the left scroll view will be magnified to show more detail. This enlarged item's name will be shown on the upper right corner.\nWhen you tap on any item, the green chat bubble will show it's name, the bubble can also be tapped again to reveal advice for the chosen item.")
                                .font(.system(size: 20, design: .serif))
                        }
                        .padding(.bottom, 40)

                        HStack(alignment: .top) {
                            Image("Screenshot5")
                                .resizable()
                                .frame(width: 400, height: 540)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.trailing, 20)
                            Text("Multi player mode built by SpriteKit, two players can play side by side. Trash can be classified by tapping the bottom trashbin icons, the first finished player will win the game.\nThose sprites in this scene can be controlled by the Gyroscope and Accelerometer censor, you can have a better experience running this app on iPad!")
                                .font(.system(size: 20, design: .serif))
                        }
                        .padding(.bottom, 40)
                        
                        HStack(alignment: .top) {
                            Image("Screenshot4")
                                .resizable()
                                .frame(width: 400, height: 540)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.trailing, 20)
                            Text("A showing place for all the items used in the game, tilt your iPad to move around the items and feel the awesome animation. Click on an item can also reveal the details.")
                                .font(.system(size: 20, design: .serif))
                        }
                        .padding(.bottom, 40)
                        
                        HStack(alignment: .top) {
                            Image("Screenshot3")
                                .resizable()
                                .frame(width: 400, height: 540)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.trailing, 20)
                            Text("Check this page yourself ;)")
                                .font(.system(size: 20, design: .serif))
                        }
                        .padding(.bottom, 40)
                    }
                }
                .padding(40)
                .tag(2)
                
//MARK: - Future Plans
                
                VStack(alignment: .leading) {
                    Group {
                        Text("Flaws & Future Plans")
                            .font(.system(size: 45))
                            .bold()
                            .padding(.bottom, 20)
                        
                        Text("Limited time was the biggest difficulty in the development of this app, in fact for this app I had so many ideas left unfinished. If these can be filled in, I will definitly try to land this app on the App Store.")
                        Text("Beyond that, there are many places in the UI that still could be polished, and without listing them all here, here are some future plans:\n")
                        
                        Text("\u{2022} ").bold() + Text("Add a scene powered by ARKit, use the iPad camera to detect which category an item is belong to.")
                        Text("\u{2022} ").bold() + Text("Let user add items into the database by allowing them taking photos, so players can make their own level.")
                        Text("\u{2022} ").bold() + Text("Make a window for editing items details directly.")
                        Text("\u{2022} ").bold() + Text("Add Level 2 for single player mode in a fruit ninja style.")
                        Text("\u{2022} ").bold() + Text("Player can tilt the iPad to pour the liquid into the sink.")
                        Text("\u{2022} ").bold() + Text("Modify the item showing place, when entering, all items should gather up like an old iOS unlock animation.")
                    }
                    .font(.system(size: 25, design: .serif))
                }
                .padding(50)
                .tag(3)
            }
            
//MARK: - Buttons
            
            HStack(alignment: .center) {
                Spacer()
                
                Button("Skip >>") {
                    showGuideOrHome = .ShowHome
                }
                .font(.system(size: 30))
                .bold()
                .padding(.horizontal, 45)
                .padding(.vertical, 10)
                .foregroundColor(.white)
                .background(.orange)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                
                Spacer()
                
                Button(guidePage == 3 ? "Finish" : "Next ->") {
                    if guidePage == 3 {
                        showGuideOrHome = .ShowHome
                    }
                    if guidePage < 3 {
                        guidePage += 1
                    }
                }
                .font(.system(size: 30))
                .bold()
                .padding(.horizontal, 45)
                .padding(.vertical, 10)
                .foregroundColor(.white)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                
                Spacer()
            }
            .offset(y: UIScreen.main.bounds.height / 2 - 120)
        }
    }
}

#Preview {
    GuideV(showGuideOrHome: .constant(.ShowGuide))
}
