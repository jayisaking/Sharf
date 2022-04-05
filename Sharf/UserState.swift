//
//  UserState.swift
//  Sharf
//
//  Created by 孫揚喆 on 2022/3/25.
//

import Foundation
import Firebase
import SwiftUI

class User :ObservableObject{
    @Published var password:String
    @Published var account:String
    @Published var lastName:String
    @Published var firstName:String
    @Published var userId:String
    @Published var isValidAccount:Bool=true
    @Published var uploadedImageCount:Int = 0
    func getUploadedImageCount(){
        let db = Firestore.firestore()
        DispatchQueue.main.async {
            db.collection("UserInformation").getDocuments { snapshot, error in
                if error == nil{
                    // No errors
                    if let snapshot = snapshot{
                        for doc in snapshot.documents{
                            if doc.data()["account"]as? String ?? "" == self.account{
                                self.uploadedImageCount = doc.data()["uploadedImageCount"] as? Int ?? 0
                            }
                        }
                    }
                }else{
                    print(error?.localizedDescription)
                }
            }
        }
    }
    func updateUploadedImageCount(){
        let db = Firestore.firestore()
        let user_ = db.collection("UserInformation").document(self.userId)
        DispatchQueue.main.async {
            user_.updateData(["uploadedImageCount":self.uploadedImageCount+1]){
                error in
                if let error = error{
                    print("\(error)")
                }else{
                    self.getUploadedImageCount()
                }
            }
        }
        
    }
    func isValidAccount(account_:String,password_:String, alterUI:@escaping ()->()){
        let db = Firestore.firestore()
        var password = password_.trimmingLeadingAndTrailingSpaces()
        var account = account_.trimmingLeadingAndTrailingSpaces()
        var returnedList:[[String]] = []
        var userValid = false
        DispatchQueue.main.async {
            
            db.collection("UserInformation").getDocuments { snapshot, error in
                if error == nil{
                    // No errors
                    if let snapshot = snapshot{
                        returnedList = snapshot.documents.map { d in
                            return [d["account"] as? String ?? "" , d["password"] as? String ?? "" , d["firstName"] as? String ?? "" , d["lastName"] as? String ?? "" , d.documentID]
                            //                        return team(leader: d["leader"] as? String ?? "", teammates: d["teammates"] as? String ?? "", teacher: d["teacher"] as? String ?? "", id: d.documentID)
                            
                        }
                        self.returnCounterUser(returnedList: returnedList, account: account, password: password,alterUI:alterUI)
                    }
                }else{
                    print(error?.localizedDescription)
                }
            }
        }
    }
    func returnCounterUser(returnedList:[[String]],account:String,password:String,alterUI:@escaping ()->()){
        print(returnedList.count)
        if returnedList.contains(where: { item -> Bool in
            item[0]==account && item[1]==password
        }){
            if let foo = returnedList.first(where:{ item -> Bool in
                item[0]==account && item[1]==password
            }){
                if foo[0]==""{
                    self.setUser(user: User(password: "",account: "",lastName: "",firstName: "",userId:"",isValidAccount: false))
                    
                    return
                }
                self.setUser(user: User(password: foo[1], account:foo[0], lastName:foo[3], firstName: foo[2],userId: foo[4], isValidAccount: true))
                setUserDefaults(account: self.account, password: self.password, lastName: self.lastName, firstName: self.firstName, userId: self.userId)
                print(self.userId)
                alterUI()
                print(self.userId)
                return
            }
            
        }else{
            self.setUser(user: User(password: "",account: "",lastName: "",firstName: "",userId: "",isValidAccount: false))
            alterUI()
            return
        }
        self.setUser(user: User(password: "",account: "",lastName: "",firstName: "",userId:"",isValidAccount: false))
        alterUI()
        return
    }
    func register(registerDone:()->() = {}){
        let db = Firestore.firestore()
        DispatchQueue.main.async {
            var ref: DocumentReference? = nil
            ref = db.collection("UserInformation").addDocument(data: ["account":self.account,"firstName":self.firstName,"password":self.password,"lastName":self.lastName,"uploadedImageCount":self.uploadedImageCount]){
                err in
                if let err = err{
                    print("create new user error \(err)")
                }else{
                    print("successfully create a new user with id = \(ref!.documentID)")
                    self.userId = ref!.documentID
                    setUserDefaults(account: self.account, password: self.password, lastName: self.lastName, firstName: self.firstName, userId: self.userId)
                }
                
            }
        }
    }
    func setUser(user:User){
        self.password = user.password
        self.account = user.account
        self.lastName = user.lastName
        self.firstName = user.firstName
        self.userId = user.userId
        self.isValidAccount = user.isValidAccount
    }
    init(password:String,account:String,lastName:String,firstName:String,userId:String = "",isValidAccount:Bool = true){
        self.password = password
        self.userId = userId
        self.account = account
        self.lastName = lastName
        self.firstName = firstName
        self.isValidAccount = isValidAccount
        self.getUploadedImageCount()
    }
}


func getName(account:String,password:String){
    
}
func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}


// Set and Get User Default Information
struct DefaultKeys{
    static let account = "account"
    static let password = "password"
    static let lastName = "lastName"
    static let firstName = "firstName"
    static let userId = "userId"
}

func setUserDefaults(account:String,password:String,lastName:String, firstName:String, userId:String){
    let defaults = UserDefaults.standard
    DispatchQueue.main.async {
        defaults.set(userId, forKey: DefaultKeys.userId)
        defaults.set(firstName, forKey: DefaultKeys.firstName)
        defaults.set(lastName, forKey: DefaultKeys.lastName)
        defaults.set(account, forKey: DefaultKeys.account)
        defaults.set(password ,forKey: DefaultKeys.password)
    }
    
}

func getUserDefaults()->User{
    let defaults = UserDefaults.standard
    var failedUser = User(password: "",account: "",lastName: "",firstName: "",userId:"",isValidAccount: false)
    var userInformation = User(password: "", account: "", lastName: "", firstName: "",userId:"", isValidAccount: true)
    do{
        if let account = defaults.string(forKey: DefaultKeys.account) {
            if account != "" && account != " "{
                userInformation.account = account
            }
            else{
                return failedUser
            }
        }else{
            return failedUser
        }
        if let password = defaults.string(forKey: DefaultKeys.password) {
            userInformation.password = password // Another String Value
        }else{
            return failedUser
        }
        if let firstName = defaults.string(forKey: DefaultKeys.firstName){
            print("Get First Name " + firstName)
            userInformation.firstName = firstName
        }else{
            return failedUser
        }
        if let lastName = defaults.string(forKey: DefaultKeys.lastName){
            userInformation.lastName = lastName
        }else{
            return failedUser
        }
        if let userId = defaults.string(forKey: DefaultKeys.userId){
            userInformation.userId = userId
        }else{
            return failedUser
        }
        print("useInformation : "+String(userInformation.isValidAccount))
        return userInformation
    }
    catch{
        return failedUser
    }
}
class UserContainer : ObservableObject{
    @Published var user:User
    init(user_:User){
        self.user = user_
    }
}







extension String {
    func trimmingLeadingAndTrailingSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        return trimmingCharacters(in: characterSet)
    }
}
