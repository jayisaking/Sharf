//
//  Register.swift
//  Sharf
//
//  Created by 孫揚喆 on 2022/4/4.
//

import SwiftUI

struct Register: View {
    @ObservedObject private var user:User = User(password: "", account: "", lastName: "", firstName: "")
    @State private var enteredLastName = ""
    @State private var enteredFirstName = ""
    @State private var enteredEmail = ""
    @State private var enteredPassword = ""
    @State private var registerCompleted = false
    var body: some View {
        NavigationView{
            VStack(spacing:20){
                ZStack{
                Text("Sign Up")
                    .font(.system(size:40))
                    .fontWeight(.bold)
                }.overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth: 5)
                    .frame(width: 180,height:70)
                    
                )
                    Spacer()
                
                TextField("Email", text: $enteredEmail)
                    .font(.system(size:20))
                    .padding(.vertical,15)
                    .padding(.leading,20)
                    .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black,lineWidth: 3)
                    )
                SecureField("password", text: $enteredPassword)
                    .font(.system(size:20))
                    .padding(.vertical,15)
                    .padding(.leading,20)
                    .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black,lineWidth: 3)
                    )
                TextField("firstname",text: $enteredFirstName)
                    .font(.system(size:20))
                    .padding(.vertical,15)
                    .padding(.leading,20)
                    .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black,lineWidth: 3)
                    )
                TextField("lastname",text : $enteredLastName)
                    .font(.system(size:20))
                    .padding(.vertical,15)
                    .padding(.leading,20)
                    .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black,lineWidth: 3)
                    )
                Spacer()
                NavigationLink(destination: ContentView(user_: getUserDefaults()), isActive: $registerCompleted) {
                    Button {
                        user.account = enteredEmail
                        user.lastName = enteredLastName
                        user.firstName = enteredFirstName
                        user.password = enteredPassword
                        user.register(registerDone: {
                            self.registerCompleted = true
                        })
                    } label: {
                        Text("Register")
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .font(.system(size:25))
                    }
                    .frame(width: 180, height: 70)
                    .background(Color.blue)
                    .cornerRadius(15)

                }
                Spacer()
            }.padding()
        }
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
    }
}
