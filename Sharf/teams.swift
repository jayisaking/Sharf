//
//  teams.swift
//  Sharf
//
//  Created by 孫揚喆 on 2022/3/24.
//

import Foundation
import Firebase
struct team: Identifiable{
    
    var leader:String
    var teammates:String
    var teacher:String
    var id:String
}
func getData()->[String]{
    var list:[String]=["11"]
    do{
        let db = Firestore.firestore()
        
        //Read the documents at a specific path
        db.collection("UserInformation").getDocuments { snapshot, error in
            if let error=error{
                list=["\(error)"]
                list=["1233"]
            }else{
                list=["12"]
                for document in snapshot!.documents{
                    list.append(document.data()["account"] as? String ?? "fff")
                }
            }
        }
    }catch{
        list=["\(error)"]
    }
    return list
}
func addData(){
    let db = Firestore.firestore()
    db.collection("UserInformation").addDocument(data: ["account":"we311311@gggg.com","firstName":"kevin","lastName":"carl","password":"root"]){
        error in
        if error == nil{
        }else{
            
        }
        
    }
    
}

class ViewModel: ObservableObject{
    
    @Published var list: [team] = []
    func updataData(teamupdate:team){
        let db = Firestore.firestore()
        
        
        db.collection("teams").document(teamupdate.id).setData(["leader":"344"]){
            error in
            if error == nil{
                DispatchQueue.main.async {
                    self.getData()
                }
            }
        } //merge :true to merge other than override
    }
    func deleteData(teamDelete:team){
        let db = Firestore.firestore()
        
        
        db.collection("teams").document(teamDelete.id).delete{
            error in
            if error == nil{
                DispatchQueue.main.async {
                    self.list.removeAll(){
                        team1 in
                        return team1.id == teamDelete.id
                        
                    }
                    
                }
            }else{
                
            }
        }
    }
    func addData(leader:String, teammates:String,teacher:String){
        let db = Firestore.firestore()
        db.collection("teams").addDocument(data: ["leader":leader,"teammates":teammates,"teacher":teacher]){
            error in
            if error == nil{
                self.getData()
            }else{
                
            }
            
        }
        
    } 
    
    
    func getData(){
        // Get a reference to the database
        let db = Firestore.firestore()
        
        //Read the documents at a specific path
        db.collection("teams").getDocuments { snapshot, error in
            if error == nil{
                // No errors
                if let snapshot = snapshot{
                    //Get all the document
                    //                    for doc in snapshot.documents{
                    //                    }
                    DispatchQueue.main.async {
                        self.list=snapshot.documents.map { d in
                            return team(leader: d["leader"] as? String ?? "", teammates: d["teammates"] as? String ?? "", teacher: d["teacher"] as? String ?? "", id: d.documentID)
                        }
                        
                    }
                    
                }
            }else{
                
            }
        }
    }
}

