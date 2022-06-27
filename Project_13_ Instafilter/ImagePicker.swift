//
//  ImagePicker.swift
//  Project_13_ Instafilter
//
//  Created by KARAN  on 27/06/22.
//

import Foundation
import PhotosUI
import SwiftUI

struct ImagePicker : UIViewControllerRepresentable {
    
    @Binding var image : UIImage?
// Now, we just added that property to ImagePicker, but we need to access it inside our Coordinator class because that’s the one that will be informed when an image was selected.


    
    class Coordinator : NSObject , PHPickerViewControllerDelegate{
        
        //Rather than just pass the data down one level, a better idea is to tell the coordinator what its parent is, so it can modify values there directly. That means adding an ImagePicker property and associated initializer to the Coordinator class, like this:
        
        var parent : ImagePicker
        
        init(_ parent : ImagePicker){
            self.parent = parent
        }
        
//At long last we’re ready to actually read the response from our PHPickerViewController, which is done by implementing a method with a very specific name. Swift will look for this method in our Coordinator class, as it’s the delegate of the image picker, so make sure and add it there.
        
//That method receives two objects we care about: the picker view controller that the user was interacting with, plus an array of the users selections because it’s possible to let the user select multiple images at once.
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            // Tell the picker to go away

            picker.dismiss(animated: true)
            
            // Exit if no selection was made

            guard let provider = results.first?.itemProvider else { return }
            
            // If this has an image we can use, use it
            
            if provider.canLoadObject(ofClass: UIImage.self){
                provider.loadObject(ofClass : UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
            
        }
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
        
        
    }
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        //
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}


// 1. We created a SwiftUI view that conforms to UIViewControllerRepresentable.
// 2. We gave it a makeUIViewController() method that created some sort of UIViewController, which in our example was a PHPickerViewController.
// 3. We added a nested Coordinator class to act as a bridge between the UIKit view controller and our SwiftUI view.
// 4. We gave that coordinator a didFinishPicking method, which will be triggered by iOS when an image was selected.
// 5. Finally, we gave our ImagePicker an @Binding property so that it can send changes back to a parent view.

