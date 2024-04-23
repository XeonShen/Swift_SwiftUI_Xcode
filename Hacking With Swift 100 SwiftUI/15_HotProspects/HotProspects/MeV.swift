import SwiftUI
import CoreImage.CIFilterBuiltins

struct MeV: View {
    
//MARK: - Constants & Vars
    
    @AppStorage("name") private var name = "Anonymous"
    @AppStorage("emailAddress") private var emailAddress = "you@yoursite.com"
    @State private var QRCode = UIImage()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
//MARK: - Functions
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    func updataQRCode() {
        QRCode = generateQRCode(from: "\(name)\n\(emailAddress)")
    }
    
//MARK: - Body
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title)
                TextField("Email Address", text: $emailAddress)
                    .textContentType(.emailAddress)
                    .font(.title)
                Image(uiImage: QRCode)
                    //disable Image Interpolation which smoothen the image
                    .interpolation(.none)
                
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                    //add contextMenu for QRCode
                    .contextMenu {
                        ShareLink(item: Image(uiImage: QRCode),
                                  preview: SharePreview("My QR Code", image: Image(uiImage: QRCode)))
                    }
            }
            
            //navigation title setting
            .navigationTitle("Your Code")
            
            //update QRCode when necessary
            .onAppear(perform: updataQRCode)
            .onChange(of: name, updataQRCode)
            .onChange(of: emailAddress, updataQRCode)
            
        }
    }
}

//MARK: - Preview

#Preview {
    MeV()
}
