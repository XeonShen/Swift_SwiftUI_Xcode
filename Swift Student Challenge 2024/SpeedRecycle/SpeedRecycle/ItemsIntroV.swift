import SwiftUI

struct ItemsIntroV: View {
    
//MARK: - Properties
    
    @ObservedObject private var itemsIntroVM = ItemsIntroVM()
    @Environment(\.dismiss) private var dismiss
    
    static let columnNum: CGFloat = 6
    static let columnSpacing: CGFloat = 10
    static let gridPadding: CGFloat = 16
    let itemSize: CGFloat = (UIScreen.main.bounds.width - (columnNum * columnSpacing) - gridPadding) / columnNum
    
    @State private var itemSelected: RecycleItemM.item?
    
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

    var body: some View {
        NavigationStack {
            ZStack {
                
//MARK: - Items Grid
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: .init(.fixed(itemSize)), count: Int(ItemsIntroV.columnNum)), spacing: ItemsIntroV.columnSpacing) {
                        ForEach(itemsIntroVM.items, id: \.self) { item in
                            GeometryReader { geometry in
                                @State var isCloseToCenter: Bool = (abs(itemsIntroVM.position.y - geometry.frame(in: .global).origin.y) < (itemSize / 2 + 3)) && (abs(itemsIntroVM.position.x - geometry.frame(in: .global).origin.x) < (itemSize / 2 + 3))
                                Image(item.imageName)
                                    .resizable()
                                    .frame(width: itemSize, height: itemSize)
                                    .scaleEffect(isCloseToCenter ? 1.15 : 0.65)
                                    .rotationEffect(.degrees(isCloseToCenter ? 25 : 0))
                                    .animation(.spring(response: 0.45, dampingFraction: 0.65, blendDuration: 0.5), value: isCloseToCenter)
                                    .cornerRadius(25)
                                    .shadow(color: Color.black.opacity(0.4), radius: 5, x: 7, y: 18)
                                    .onTapGesture {
                                        itemSelected = item
                                        itemsIntroVM.setPositionToItem(x: geometry.frame(in: .global).origin.x,
                                                                       y: geometry.frame(in: .global).origin.y)
                                    }
                                    .onChange(of: isCloseToCenter) {
                                        if isCloseToCenter == true {
                                            itemSelected = item
                                        }
                                    }
                            }
                            //when applying geometry reader to a grid view, a frame is a must, otherwise the geometry will take all the space
                            .frame(width: itemSize, height: itemSize)
                        }
                        //add blank items to the grid to maintain the grid shape
                        ForEach(0..<21) { _ in
                            Color.clear.frame(width: itemSize, height: itemSize)
                        }
                    }
                    .padding(.horizontal, (ItemsIntroV.gridPadding / 2))
                }
                .background(Image("BackgroundSand"))
                
//MARK: - Floating Window
                
                VStack(alignment: .center) {
                    if itemSelected != nil {
                        let itemCategory: (String, String) = itemsIntroVM.returnCategoryName(item: itemSelected!)
                        GeometryReader { geometry in
                            Text("Name: \(itemSelected!.name)\nCategory: \(itemCategory.0)\nSubCategory: \(itemCategory.1)\nDescription: \(itemSelected!.description)\nAdvice: \(itemSelected!.advise)")
                                .font(.system(size: 15))
                                .bold()
                                .italic()
                                .frame(maxWidth: UIScreen.main.bounds.width - 300)
                                .padding(20)
                                .background(BlurView(style: .systemMaterial, opacity: 0.60))
                                .foregroundColor(.secondary)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                                .shadow(color: Color.black.opacity(0.2), radius: 30, x: 0, y: 0)
                                .offset(y: UIScreen.main.bounds.height / 2 - 170)
                                //add category sign on upper right corner
                                .overlay {
                                    Image(itemsIntroVM.returnCategoryImage(category: itemSelected!.category))
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .offset(
                                            x: geometry.size.width / 2,
                                            y: UIScreen.main.bounds.height / 2 - 170 - 70
                                        )
                                }
                        }
                    }
                }
                .frame(maxWidth: UIScreen.main.bounds.width - 260)
                .offset(y: UIScreen.main.bounds.height / 2 - 170)
                
//MARK: - Gyro Point
                
                Circle()
                    .frame(width: 20, height: 20)
                    .opacity(0)
                    .position(itemsIntroVM.position)
                
            }
            .preferredColorScheme(.light)
            .statusBar(hidden: true)
            
            .navigationTitle("Items Introduction - Tilt your iPad to move around")
            .navigationBarTitleDisplayMode(.inline)
            
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backHomeButton)
        }
    }
}

#Preview {
    ItemsIntroV()
}
