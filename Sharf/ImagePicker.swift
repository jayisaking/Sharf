//
//  ImagePicker.swift
//  Sharf
//
//  Created by 孫揚喆 on 2022/3/29.
//

import Foundation
import SwiftUI
import UIKit
import PhotosUI
import Firebase

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}
class ImageHandlers: ObservableObject{
    @Published var imageModels: [ImageHandler] = []
    func append(image:ImageHandler){
        self.imageModels.append(image)
    }
}
class ImageHandler :ObservableObject{
    @Published var image:UIImage
    @Published var account:String
    @Published var errorDescription:String = "no errors"
    var id:Int
    func imageUpload(processer:@escaping ()->(), id_:Int,postId:String){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let url_ = "images/\(account)/\(postId)/item\(String(id_)).jpg"
        let item = storageRef.child(url_)

        guard let imageData = self.image.jpegData(compressionQuality: 0.7)
        else {
            self.errorDescription = "jpegData went wrong"
            return
        }
        DispatchQueue.main.async {
            let uploadTask = item.putData(imageData, metadata: nil){ metadata, error in
                if error == nil {
                    item.downloadURL(completion: { URL, error in
                        if error == nil{
                            self.errorDescription = URL?.absoluteString ?? "URL download error"
                            let db_ = Firestore.firestore()
                            db_.collection("posts").document(postId).collection("imageUrls").addDocument(data: ["url":url_]){
                                err in
                                if let err = err{
                                    print("image url upload error \(err)")
                                }else{
                                    
                                }
                            }
                        }else{
                            self.errorDescription = error?.localizedDescription ?? "download URL error"
                        }
                    })
                    processer()
                }else{
                    self.errorDescription = error?.localizedDescription ?? "put data wrong"
                }
                
            }
        }
        
    }
    init(account:String,number:Int,image:UIImage){
        self.account = account
        self.id = number
        self.image = image
    }
}
func submitPost(ImageModels:ImageHandlers,date:Date,account:String,location:String,description:String,title:String,userId:String,isSubmit:@escaping ()->()){
    var ref:DocumentReference? = nil
    let db = Firestore.firestore()
    var postId = ""
    ref = db.collection("posts").addDocument(data: [
        "expirationDate":Timestamp(date: date),
        "account":account,
        "location":location,
        "description":description,
        "title":title,
        "photoQuantity":ImageModels.imageModels.count
    ]){
        err in
        if let err = err{
            print("Error adding document: \(err)")
                } else {
                    postId = ref!.documentID
                    var count_:Int = ImageModels.imageModels.count
                    let db_ = Firestore.firestore()
                    db_.collection("UserInformation").document(userId).collection("posts").addDocument(data: ["id" : postId]){
                        error_ in
                        if let error_ = error_{
                            print("Error adding document: \(error_)")
                        }else{
                            for item in 0..<count_{
                                ImageModels.imageModels[item].imageUpload(processer: {
                                    
                                }, id_: item, postId: postId)
                            }
                            isSubmit()
                        }
                    }
                    
        }
    }
    
}
