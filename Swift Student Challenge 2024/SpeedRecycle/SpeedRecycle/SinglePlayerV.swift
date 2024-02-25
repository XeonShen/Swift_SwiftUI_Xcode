import SwiftUI
import UniformTypeIdentifiers

struct SinglePlayerV: View {
    
    //view properties
    @ObservedObject private var singlePlayerVM = SinglePlayerVM()
    @Environment(\.dismiss) private var dismiss
    //scroll view properties
    let screenCenterY = UIScreen.main.bounds.height / 2 - 100
    let scrollViewSpacing: CGFloat = 3
    let scrollViewItemSize: CGFloat = 200
    //chat bubble property
    @State private var ChatBubbleItem: RecycleItemM.item?
    @State private var showBubbleItemAdvise: Bool = false
    //trashbin explaination
    @State private var showTrashbinExplaination = false

    
//MARK: - Body Component
    
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
                HStack {
                    
//MARK: - Scroll View on the left
                    
                    ScrollView(.vertical) {
                        VStack(alignment: .leading, spacing: scrollViewSpacing) {
                            ForEach(singlePlayerVM.items) { item in
                                GeometryReader { geometry in
                                    //calculate whether this item is close to center
                                    @State var isCloseToCenter: Bool = (abs(screenCenterY - geometry.frame(in: .global).origin.y) < 101)
                                    //show this item image
                                    Image(item.imageName)
                                        .resizable()
                                        .frame(width: scrollViewItemSize, height: scrollViewItemSize, alignment: .leading)
                                        //closest item to screen center will be magnified
                                        .scaleEffect(isCloseToCenter ? 1 : 0.4)
                                        .rotationEffect(.degrees(isCloseToCenter ? 20 : 0))
                                        .animation(.spring(response: 0.45, dampingFraction: 0.65, blendDuration: 0.5), value: isCloseToCenter)
                                        //gray this image before round start
                                        .colorMultiply(singlePlayerVM.disableComponent ? .gray.opacity(0.75) : .white)
                                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 7, y: 18)
                                        //drag this image
                                        .onDrag {
                                            let jsonData = try? JSONEncoder().encode(item)
                                            let jsonString = String(data: jsonData ?? Data(), encoding: .utf8) ?? ""
                                            return NSItemProvider(object: jsonString as NSString)
                                        }
                                        //when tapped, show detail in chat bubble
                                        .onTapGesture {
                                            ChatBubbleItem = item
                                            showBubbleItemAdvise = false
                                        }
                                        //when close to center, show detail in chat bubble
                                        .onChange(of: isCloseToCenter) {
                                            if isCloseToCenter == true {
                                                ChatBubbleItem = item
                                            }
                                            showBubbleItemAdvise = false
                                        }
                                }
                            }
                        }
                        //make all ScrollView items centered on the left of screen
                        .frame(width: scrollViewItemSize,
                               height: CGFloat(singlePlayerVM.items.count) * (scrollViewItemSize + scrollViewSpacing))
                    }
                    .scrollIndicators(.never)
                    .disabled(singlePlayerVM.disableComponent)
                    
//MARK: -
                    
                    Spacer()
                    
                    VStack {
                        Spacer()
                        
                        Group {
                            switch singlePlayerVM.roundIsOver {
                            //shows after playing
                            case true: Text("try again")
                            //shows when playing
                            case false: Text("common")
                            //shows when play first time
                            default: Text("👈 Scroll, Drag & Drop 👇")
                            }
                        }
                        .font(.system(size: 20))
                        .bold()
                        .italic()
                        .underline()
                        .foregroundColor(.secondary)
                        .padding(.top, 80)
                        .padding(.bottom, 10)
                                                
                        HStack {
                            Text("Time Left: \(singlePlayerVM.roundTimeLeft), score: \(singlePlayerVM.roundScore)")
                                .font(.system(size: 30))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 10)
                                .background(.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke((singlePlayerVM.roundTimeLeft < 10) ? .red : .blue, lineWidth: 3)
                                )
                        }
                        
                        Spacer()
                        
//MARK: - Trashbins on the right
                        
                        VStack {
                            HStack {
                                Image("BinRecyclable")
                                    .resizable()
                                    .frame(width: 220, height: 220)
                                    .scaleEffect(singlePlayerVM.trashbinScaleDictionary["recyclable"]! ? 0.9 : 0.7)
                                    .offset(x: singlePlayerVM.trashbinShakeDictionary["recyclable"]!)
                                    .padding(.horizontal, 40)
                                    .padding(.vertical, 15)
                                    .colorMultiply(singlePlayerVM.disableComponent ? .gray.opacity(0.75) : .white)
                                    .shadow(color: Color.black.opacity(0.7), radius: 5, x: 0, y: 10)
                                    .onDrop(of: [UTType.plainText.identifier], isTargeted: nil) { providers in
                                        providers.first?.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { (item, error) in
                                            singlePlayerVM.classifyTrash(item: item, category: .recyclable)
                                        }
                                        return true
                                    }
                                
                                Image("BinNonrecyclable")
                                    .resizable()
                                    .frame(width: 220, height: 220)
                                    .scaleEffect(singlePlayerVM.trashbinScaleDictionary["nonrecyclable"]! ? 1 : 0.8)
                                    .offset(x: singlePlayerVM.trashbinShakeDictionary["nonrecyclable"]!)
                                    .padding(.horizontal, 40)
                                    .padding(.vertical, 15)
                                    .colorMultiply(singlePlayerVM.disableComponent ? .gray.opacity(0.75) : .white)
                                    .shadow(color: Color.black.opacity(0.7), radius: 5, x: 0, y: 10)
                                    .onDrop(of: [UTType.plainText.identifier], isTargeted: nil) { providers in
                                        providers.first?.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { (item, error) in
                                            singlePlayerVM.classifyTrash(item: item, category: .nonrecyclable)
                                        }
                                        return true
                                    }
                            }
                            
                            HStack {
                                Image("BinFood")
                                    .resizable()
                                    .frame(width: 220, height: 220)
                                    .scaleEffect(singlePlayerVM.trashbinScaleDictionary["food"]! ? 1.1 : 0.9)
                                    .offset(x: singlePlayerVM.trashbinShakeDictionary["food"]!)
                                    .padding(.horizontal, 40)
                                    .padding(.vertical, 15)
                                    .colorMultiply(singlePlayerVM.disableComponent ? .gray.opacity(0.75) : .white)
                                    .shadow(color: Color.black.opacity(0.7), radius: 5, x: 0, y: 10)
                                    .onDrop(of: [UTType.plainText.identifier], isTargeted: nil) { providers in
                                        providers.first?.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { (item, error) in
                                            singlePlayerVM.classifyTrash(item: item, category: .food)
                                        }
                                        return true
                                    }
                                
                                Image("BinFluid")
                                    .resizable()
                                    .frame(width: 220, height: 220)
                                    .scaleEffect(singlePlayerVM.trashbinScaleDictionary["liquid"]! ? 1.1 : 0.9)
                                    .offset(x: singlePlayerVM.trashbinShakeDictionary["liquid"]!, y: 20)
                                    .padding(.horizontal, 40)
                                    .padding(.vertical, 15)
                                    .colorMultiply(singlePlayerVM.disableComponent ? .gray.opacity(0.75) : .white)
                                    .shadow(color: Color.black.opacity(0.7), radius: 5, x: 0, y: 10)
                                    .onDrop(of: [UTType.plainText.identifier], isTargeted: nil) { providers in
                                        providers.first?.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { (item, error) in
                                            singlePlayerVM.classifyTrash(item: item, category: .liquid)
                                        }
                                        return true
                                    }
                            }
                            
                            HStack {
                                Image("BinDonate")
                                    .resizable()
                                    .frame(width: 220, height: 220)
                                    .scaleEffect(singlePlayerVM.trashbinScaleDictionary["donate"]! ? 1 : 0.8)
                                    .offset(x: singlePlayerVM.trashbinShakeDictionary["donate"]!)
                                    .padding(.horizontal, 40)
                                    .padding(.vertical, 15)
                                    .colorMultiply(singlePlayerVM.disableComponent ? .gray.opacity(0.75) : .white)
                                    .shadow(color: Color.black.opacity(0.7), radius: 5, x: 0, y: 10)
                                    .onDrop(of: [UTType.plainText.identifier], isTargeted: nil) { providers in
                                        providers.first?.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { (item, error) in
                                            singlePlayerVM.classifyTrash(item: item, category: .donate)
                                        }
                                        return true
                                    }
                                
                                Image("BinBiodegradable")
                                    .resizable()
                                    .frame(width: 220, height: 220)
                                    .scaleEffect(singlePlayerVM.trashbinScaleDictionary["biodegradable"]! ? 1 : 0.8)
                                    .offset(x: singlePlayerVM.trashbinShakeDictionary["biodegradable"]!, y: 10)
                                    .padding(.horizontal, 40)
                                    .padding(.vertical, 15)
                                    .colorMultiply(singlePlayerVM.disableComponent ? .gray.opacity(0.75) : .white)
                                    .shadow(color: Color.black.opacity(0.7), radius: 5, x: 0, y: 10)
                                    .onDrop(of: [UTType.plainText.identifier], isTargeted: nil) { providers in
                                        providers.first?.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { (item, error) in
                                            singlePlayerVM.classifyTrash(item: item, category: .biodegradable)
                                        }
                                        return true
                                    }
                            }
                        }
                        .padding(.bottom, 20)
                        .disabled(singlePlayerVM.disableComponent)
                        
                                                                                                
//MARK: - Start game button
                        
                        Spacer()
                        
                        HStack(alignment: .center) {
                            Button((singlePlayerVM.roundIsOver == false) ? "Recycling..." : "Start Recycle") {
                                singlePlayerVM.disableComponent = false
                                singlePlayerVM.playerWin = false
                                singlePlayerVM.roundIsOver = false
                                singlePlayerVM.roundTimeLeft = 110
                                singlePlayerVM.roundScore = 0
                                singlePlayerVM.startTimer()
                            }
                            .font(.system(size: 20))
                            .bold()
                            .frame(width: 180, height: 50)
                            .background((singlePlayerVM.roundIsOver == false) ? .gray : .blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .padding(.trailing, 50)
                            .disabled(!(singlePlayerVM.roundIsOver ?? true)) //when playing, disabled
                            
                            Button("Bin Explaination") {
                                showTrashbinExplaination = true
                            }
                            .font(.system(size: 20))
                            .bold()
                            .frame(width: 190, height: 50)
                            .background(.orange)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                        }
                        .padding(.bottom, 20)

//MARK: -
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                }
                .preferredColorScheme(.light)
                .statusBar(hidden: true)
                
                .navigationTitle("Single Player")
                .navigationBarTitleDisplayMode(.inline)
                
                .toolbarBackground(.visible, for: .navigationBar) //always showing navi bar
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: backHomeButton)
                
                .background(Image("BackgroundWood"))
                
                .sheet(isPresented: $showTrashbinExplaination) {
                    TrashbinV()
                }
                //show this cover if win
                .fullScreenCover(isPresented: $singlePlayerVM.playerWin) { SinglePlayerWinV(congretsWord: "Congratulations, you did it!") }
                
//MARK: - Chat Bubble
                
                if ChatBubbleItem == nil {
                    ChatBubble(itemDescription: "Scroll on the left to see description", 
                               bubbleColor: .green)
                        .padding(.top, 30)
                        .padding(.trailing, 30)
                        .padding(.leading, 250)
                        .colorMultiply(singlePlayerVM.disableComponent ? .gray.opacity(0.75) : .white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .disabled(singlePlayerVM.disableComponent)
                } else {
                    ChatBubble(itemDescription: showBubbleItemAdvise ? ChatBubbleItem!.advise : ChatBubbleItem!.description,
                               bubbleColor: showBubbleItemAdvise ? .orange : .green)
                        .padding(.top, 30)
                        .padding(.trailing, 30)
                        .padding(.leading, 250)
                        .colorMultiply(singlePlayerVM.disableComponent ? .gray.opacity(0.75) : .white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .onTapGesture {
                            showBubbleItemAdvise = true
                        }
                        .disabled(singlePlayerVM.disableComponent)
                }
            }
        }
    }
}

//MARK: - Preview

#Preview {
    SinglePlayerV()
}
