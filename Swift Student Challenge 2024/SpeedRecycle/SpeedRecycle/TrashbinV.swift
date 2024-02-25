import SwiftUI

struct TrashbinV: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Image("BinRecyclable")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .padding(.trailing, 40)
                    Text("Recyclable Trashbin")
                        .font(.system(size: 30, design: .serif))
                        .padding(.horizontal,30)
                        .padding(.vertical, 12)
                        .foregroundColor(.white)
                        .background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                }
                .padding(.bottom, 50)
                
                HStack {
                    Image("BinNonrecyclable")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .scaleEffect(0.9)
                        .padding(.trailing, 40)
                    Text("Nonrecyclable Trashbin")
                        .font(.system(size: 30, design: .serif))
                        .padding(.horizontal,30)
                        .padding(.vertical, 12)
                        .foregroundColor(.white)
                        .background(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                }
                .padding(.bottom, 50)

                HStack {
                    Image("BinFood")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .scaleEffect(1.1)
                        .padding(.trailing, 40)
                    Text("Food Waste Trashbin")
                        .font(.system(size: 30, design: .serif))
                        .padding(.horizontal,30)
                        .padding(.vertical, 12)
                        .foregroundColor(.white)
                        .background(.yellow)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                }
                .padding(.bottom, 50)
                
                HStack {
                    Image("BinFluid")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .padding(.trailing, 40)
                    Text("Water Sink")
                        .font(.system(size: 30, design: .serif))
                        .padding(.horizontal,30)
                        .padding(.vertical, 12)
                        .foregroundColor(.white)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                }
                .padding(.bottom, 50)
                
                HStack {
                    Image("BinDonate")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .padding(.trailing, 40)
                    Text("Donate Bag")
                        .font(.system(size: 30, design: .serif))
                        .padding(.horizontal,30)
                        .padding(.vertical, 12)
                        .foregroundColor(.white)
                        .background(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                }
                .padding(.bottom, 50)
                
                HStack {
                    Image("BinBiodegradable")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .padding(.trailing, 40)
                    Text("Plant pot (Biodegradable)")
                        .font(.system(size: 30, design: .serif))
                        .padding(.horizontal,30)
                        .padding(.vertical, 12)
                        .foregroundColor(.white)
                        .background(.brown)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                }
                .padding(.bottom, 50)
            }
            .padding(50)
        }
    }
}

#Preview {
    TrashbinV()
}
