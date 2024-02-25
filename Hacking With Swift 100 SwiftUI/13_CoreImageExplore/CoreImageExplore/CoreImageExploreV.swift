import SwiftUI
import PhotosUI //this helps loading image
import CoreImage // this helps modifying image
import CoreImage.CIFilterBuiltins
import StoreKit //this helps user leave a review of this App

struct CoreImageExploreV: View {
    
//MARK: - Constants and Vars
    
    @State private var selectedImage: PhotosPickerItem?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.5
    @State private var filterScale = 0.5
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let ciContext = CIContext()
    @State private var processedImage: Image?
    
    @State private var showingChangeFilters = false
    
    @AppStorage("timesFilterBeenUsed") var timesFilterBeenUsed = 0
    @Environment(\.requestReview) var requestReview
    
//MARK: - Functions
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedImage?.loadTransferable(type: Data.self) else { return }
            guard let uiImage = UIImage(data: imageData) else { return }
            
            let ciImage = CIImage(image: uiImage)
            currentFilter.setValue(ciImage, forKey: kCIInputImageKey)
            filterImage()
        }
    }
    
    func filterImage() {
        //different filter have different inputKeys, thus we choose inputKeys accordingly
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterScale * 10, forKey: kCIInputScaleKey) }
        
        guard let ciImage = currentFilter.outputImage else { return }
        guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else { return }
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    
    @MainActor func changeFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
        
        timesFilterBeenUsed += 1
        if timesFilterBeenUsed == 3 { requestReview() } //requestReview will pop up a window when main view is runing, which is forbiddened, thus @MainActor should be added before func
    }
    
//MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
//MARK: - PhotoPicker
                
                PhotosPicker(selection: $selectedImage) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: selectedImage, loadImage)
                
                Spacer()
                
//MARK: - Sliders
                
                VStack {
                    HStack {
                        Text("Intensity: ")
                        Slider(value: $filterIntensity)
                            .onChange(of: filterIntensity, filterImage)
                    }
                    HStack {
                        Text("Radius:    ")
                        Slider(value: $filterRadius)
                            .onChange(of: filterRadius, filterImage)
                    }
                    HStack {
                        Text("Scale:      ")
                        Slider(value: $filterScale)
                            .onChange(of: filterScale, filterImage)
                    }
                }
                .disabled({ selectedImage == nil ? true : false }())
                
//MARK: - Change Filter and ShareLink
                
                HStack {
                    Button("Change Filter") { showingChangeFilters = true }
                    Spacer()
                    if let processedImage {
                        ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
                    }
                }
                .disabled({ selectedImage == nil ? true : false }())
            }
            .navigationTitle("Instafilter")
            .padding([.horizontal, .bottom])
            .confirmationDialog("Select a filter", isPresented: $showingChangeFilters) {
                Button("Crystallize") { changeFilter(CIFilter.crystallize()) }
                Button("Edges") { changeFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { changeFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { changeFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { changeFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { changeFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { changeFilter(CIFilter.vignette()) }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
}

//MARK: - Preview

#Preview {
    CoreImageExploreV()
}
