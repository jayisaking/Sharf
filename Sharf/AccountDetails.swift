//
//  AccountDetails.swift
//  Sharf
//
//  Created by 孫揚喆 on 2022/3/28.
//

import SwiftUI
import Firebase
import Introspect
struct AccountDetails: View {
    @ObservedObject private var user:User
    @State private var isActive = false
    @State private var backToHome = false
    @ObservedObject private var containUser = UserContainer(user_:getUserDefaults())
    var body: some View {
        NoBarNavigationView{
            ZStack{
            VStack{
                Text("\(user.lastName)  \(user.firstName)")
                    .font(.system(size:30))
                    .fontWeight(.bold)
                    .padding(.bottom,18)
                    .foregroundColor(Color.black)
                Divider()
                    .background(Color.black)
                VStack{
                    VStack{
                        Button{}
                    label:{
                        HStack{
                            Image(systemName: "list.bullet.rectangle.portrait")
                                .padding(.trailing,3)
                                .font(.system(size:22))
                            Text("Post Management")
                                .font(.system(size:23))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size:20))
                        }.padding()
                    }
                        Divider()
                            .background(Color.black)
                            .padding(.leading,15)
                            .padding(.trailing,10)
                        Button{}
                    label:{
                        HStack{
                            Image(systemName: "mail")
                                .font(.system(size:22))
                            Text("Email Settings")
                                .font(.system(size:23))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size:20))
                        }.padding()
                    }
                        Divider()
                            .background(Color.black)
                            .padding(.leading,15)
                            .padding(.trailing,10)
                        Button{}
                    label:{
                        HStack{
                            Image(systemName: "p.circle")
                                .font(.system(size:25))
                            Text("Reset Password")
                                .font(.system(size:23))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size:20))
                        }.padding()
                    }
                        Divider()
                            .background(Color.black)
                            .padding(.leading,15)
                            .padding(.trailing,10)
                        Button{}
                    label:{
                        HStack{
                            Image(systemName: "signature")
                                .font(.system(size:19))
                            Text("Name change")
                                .font(.system(size:23))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size:20))
                        }.padding()
                    }
                        Divider()
                            .background(Color.black)
                            .padding(.leading,15)
                            .padding(.trailing,10)
                        Button{}
                    label:{
                        HStack{
                            Image(systemName: "phone")
                                .font(.system(size:25))
                            Text("Contact Us")
                                .font(.system(size:23))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size:20))
                        }.padding()
                    }
                        Divider()
                            .background(Color.black)
                            .padding(.leading,15)
                            .padding(.trailing,10)
                    }.padding(.trailing,20)
                        .padding(.leading,7)
                        .foregroundColor(Color.black)
                    Spacer()
                    NavigationLink(destination: ContentView(user_:self.containUser.user).navigationBarHidden(true).navigationBarBackButtonHidden(true), isActive: $isActive, label: {
                        Button {
                            setUserDefaults(account: "", password: "", lastName: "", firstName: "", userId:  "")
                            self.containUser.user = getUserDefaults()
                            print("log out : container : "+String(self.containUser.user.isValidAccount))
                            isActive = true
                        } label: {
                            Text("Log Out")
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                                .font(.system(size:27))
                            
                        }.frame(width: 200, height: 70)
                            .background(Color.blue)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                    })
                    
                }.navigationTitle("")
                .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
            }
                VStack{
                    Spacer()
                    NavigationLink(destination: ContentView(user_: getUserDefaults()), isActive: $backToHome){
                        Button {
                            backToHome = true
                        } label: {
                            Text("Home")
                                .foregroundColor(Color.white)
                                .font(.system(size:30))
                                .fontWeight(.bold)
                        }.frame(width: 200, height: 70)
                            .background(Color.blue)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                    }

                }.padding(.bottom,100)
            }
        }.navigationViewStyle(.stack)
    }
    init(source:String,user_:User
    ){
        print("AccountDetailes init : from "+source)
        user = user_
        print("AccountDetailes init : init lastName : "+user.lastName)
    }
}

struct AccountDetails_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetails(source:"PreView",user_:getUserDefaults())
        NavigationView{
            AccountDetails(source:"PreView",user_:getUserDefaults()).navigationBarHidden(true)
        }
    }
}

struct NoBarNavigationView<Content: View>: View {

    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        NavigationView {
            content
                .introspectNavigationController { (UINavigationController) in
                    NavigationControllerDelegate.shared.becomeDelegate(of: UINavigationController)
                }
        }
    }
}

class NavigationControllerDelegate: NSObject {

    static let shared = NavigationControllerDelegate()

    func becomeDelegate(of navigationController: UINavigationController) {
        navigationController.isNavigationBarHidden = true
        navigationController.navigationBar.isHidden = true
        navigationController.navigationBar.addObserver(self, forKeyPath: "alpha", options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // This is necessary to ensure the UINavigationBar remains hidden
        if let navigationBar = object as? UINavigationBar {
            navigationBar.isHidden = true
        }
    }

}
