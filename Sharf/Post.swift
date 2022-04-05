//
//  Post.swift
//  Sharf
//
//  Created by 孫揚喆 on 2022/4/4.
//

import Foundation
import SwiftUI
import Firebase
class PostModels: ObservableObject{
    @Published var postModels:[PostModel] = []
    func getAllPosts(loaded:@escaping ()->())->(){
        let db = Firestore.firestore()
        var returnedPostIdList:[String] = []
        var returnedPhotoQuantityList:[Int] = []
        DispatchQueue.main.async {
            db.collection("posts").getDocuments { snapshot, err in
                if let err = err{
                    print("download post document error \(err)")
                }else{
                    if let snapshot = snapshot{
                        returnedPostIdList = snapshot.documents.map{ d in
                            print("returning postId... with postId : \(d.documentID)")
                            returnedPhotoQuantityList.append(d["photoQuantity"] as? Int ?? 0)
                            return d.documentID
                        }
                        self.postModels = []
                        for item in 0 ..< returnedPostIdList.count{
                            self.postModels.append(PostModel(postId: returnedPostIdList[item],photoQuantity: returnedPhotoQuantityList[item],loaded:loaded))
                        }
                    }
                }
            }
            
        }
    }
}
class PostModel{
    var postId:String = ""
    var account:String = ""
    var description:String = ""
    var expirationDate:Date = Date()
    var location:String = ""
    var images:[Image] = []
    var title:String = ""
    init(postId:String,photoQuantity:Int,loaded:@escaping ()->()){
        self.postId = postId
        DispatchQueue.main.async {
            let db = Firestore.firestore()
            let post = db.collection("posts").document(postId)
            post.getDocument { document, err in
                if let document = document,document.exists{
                    let data = document.data()
                    self.account = data?["account"] as? String ?? ""
                    self.description = data?["description"] as? String ?? ""
                    self.expirationDate = (data?["expirationDate"] as? Timestamp ?? Timestamp()).dateValue()
                    self.location = data?["location"] as? String ?? ""
                    self.title = data?["title"] as? String ?? ""
                    print("post loading with account: \(self.account) postId: \(postId)")
                    var count = 0
                    var loopValid = true
                    var path = ""
                    let storageRef = Storage.storage().reference()
                    while loopValid{
                        if count>=photoQuantity{
                            loaded()
                            break
                        }
                        print("downloading with item\(String(count))")
                        storageRef.child("images/\(self.account)/\(self.postId)/item\(String(count)).jpg").getData(maxSize: 20*1024*1024) { data, error in
                            if let error = error{
                                print("Download Data Error \(error)")
                                loopValid = false
                            }else{
                                self.images.append(Image(uiImage: UIImage(data: data!) ?? UIImage()))
                            }
                        }
                        count+=1
                    }
                }
            }
        }
    }
}
