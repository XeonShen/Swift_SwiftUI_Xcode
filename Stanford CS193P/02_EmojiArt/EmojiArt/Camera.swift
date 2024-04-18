import SwiftUI

struct Camera: UIViewControllerRepresentable {
    
//MARK: - Constants and Vars

    var handlePickedImage: (UIImage?) -> Void
    static var isAvailable: Bool { UIImagePickerController.isSourceTypeAvailable(.camera) }

//MARK: - Conform to the UIViewControllerRepresentable protocal

    typealias UIViewControllerType = UIImagePickerController

    //create a camera by using UIKit
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        //create a delegate for image picker controller, so it receives message when user hit shot button
        picker.delegate = context.coordinator
        return picker
    }
    
    //the camera will not affect the View, so it's unnecessary to put code here
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    //create a Coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(handlePickedImage: handlePickedImage)
    }
    
//MARK: - Coordinator
    
    //always create the delegate by a class named Coordinator
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var handlePickedImage: (UIImage?) -> Void
        
        init(handlePickedImage: @escaping (UIImage?) -> Void) {
            self.handlePickedImage = handlePickedImage
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            handlePickedImage(nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            handlePickedImage((info[.editedImage] ?? info[.originalImage]) as? UIImage)
        }
    }
}

