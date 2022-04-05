//
//  Profile.swift
//  Sharf
//
//  Created by 孫揚喆 on 2022/3/25.
//

import SwiftUI
import Firebase
struct Profile: View {
    @State private var enteredPassword: String = ""
    @State private var enteredAccount: String = ""
    @ObservedObject private var user=User(password: "", account: "", lastName: "", firstName: "", userId:"",isValidAccount: true)
    @State private var navigationlinkIsActive:Bool = false
    @State private var to:String
    @State private var toAddFoodNavigationIsActive:Bool = false
    @State private var backToHome = false
    @State private var toRegister = false
    var body: some View {
        NoBarNavigationView{
            ZStack{
            VStack{
//                if self.user.account != "" && self.user.account != " " && self.user.password != ""{
//                    VStack{
//                        Text(user.account)
//                    }
//                }else{
                    VStack{
                        Spacer()
                        Spacer()
                        Text("Log In")
                            .font(.system(size:40))
                            .fontWeight(.heavy)
                            .foregroundColor(Color.blue)
                            .padding(.vertical,9)
                            .padding(.horizontal,9)
                            .overlay(
                                RoundedRectangle(cornerRadius: 9)
                                    .stroke(Color.blue,lineWidth: 5)
                            )
                        Spacer()
                        if !user.isValidAccount{
                        Text("Your Email or Password seems to be wrong.\nPlease sign up or enter them correctly again. ")
                            .foregroundColor(Color.red)
                        }
                        TextField("Email",text:$enteredAccount)
                            .padding(EdgeInsets(top: 13, leading: 16, bottom: 13, trailing: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(Color.blue)
                            )
                            .font(.system(size:18))
                            .shadow(radius: 1)
                            .padding(.horizontal,20)
                            .padding(.bottom,15)
                            .autocapitalization(.none)
                        SecureField("Password",text:$enteredPassword)
                            .padding(EdgeInsets(top: 13, leading: 16, bottom: 13, trailing: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(Color.blue)
                            )
                            .font(.system(size:18))
                            .shadow(radius: 1)
                            .padding(.horizontal,20)
                            .autocapitalization(.none)
                        Spacer()
                        if self.to == "AddFood"{
                            NavigationLink(destination:
                                            AddFood(user_:self.user).navigationBarHidden(true)
                                           , isActive: $toAddFoodNavigationIsActive){
                                Button(action: {
                                    user.isValidAccount(account_: enteredAccount, password_: enteredPassword){
                                        print("navigationlinkIsAcitve : "+getUserDefaults().lastName)
                                        self.toAddFoodNavigationIsActive = true
                                    }
    //                                print(enteredAccount+" "+enteredPassword)
                                    print("from profile to addfood")
                                  
                                }) {
                                    Text("Let's Go")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                        .font(.title)
                                }
                                .frame(width:230,height: 65)
                                .background(Color.blue)
                                .cornerRadius(20)
                                .shadow(radius: 5)
                                //                .offset(y:-10)
                            }
                        }else{
                        NavigationLink(destination:
                                        AccountDetails(source: "Profile",user_:self.user).navigationBarHidden(true)
                                       , isActive: $navigationlinkIsActive){
                            Button(action: {
                                user.isValidAccount(account_: enteredAccount, password_: enteredPassword){
                                    print("navigationlinkIsAcitve : "+getUserDefaults().lastName)
                                    navigationlinkIsActive = true
                                }
//                                print(enteredAccount+" "+enteredPassword)
                                
                              
                            }) {
                                Text("Let's Go")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .font(.title)
                            }
                            .frame(width:230,height: 65)
                            .background(Color.blue)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            //                .offset(y:-10)
                        }
                        }
                        Spacer()
                    }.padding(.horizontal)
                        .ignoresSafeArea()
                        .offset(y:-50)
            }.navigationBarHidden(true)
                
                VStack{
                    Spacer()
                    NavigationLink(destination: Register(), isActive: $toRegister){
                        Button {
                            toRegister = true
                        } label: {
                            Text("Register")
                                .foregroundColor(Color.white)
                                .font(.system(size:22))
                                .fontWeight(.bold)
                        }.frame(width: 120, height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }

                }.padding()
                    .padding(.bottom,60)
                VStack{
                    Spacer()
                    NavigationLink(destination: ContentView(user_: getUserDefaults()), isActive: $backToHome){
                        Button {
                            backToHome = true
                        } label: {
                            Text("Home")
                                .foregroundColor(Color.white)
                                .font(.system(size:22))
                                .fontWeight(.bold)
                        }.frame(width: 120, height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }

                }.padding()
            }
        }.navigationViewStyle(.stack)
    }
//    init(){
//        self.user.setUser(user: getUserDefaults())
//        self.navigationlinkActive=isValidAccount
//        let userInfoArray = getUserDefaults()
//        self.account = userInfoArray[0]
//        self.password = userInfoArray[1]
//    }
//    init(account:String,password:String){
//        self.account = account
//        self.password = password
//    }
    init(to:String = "AccountDetails"){
        self.to = to
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
            .previewDevice("iPhone 13")
        NavigationView{
            Profile()
        }
    }
}
