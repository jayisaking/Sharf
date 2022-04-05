//
//  ContentView.swift
//  Sharf
//
//  Created by 孫揚喆 on 2022/3/23.
//

import SwiftUI
import Firebase
import UIKit


struct ContentView: View {
    private enum Field: Int, CaseIterable {
        case foodType
    }
    //    @ObservedObject var model = ViewModel()
    @State private var foodType:String = ""
    @FocusState private var focusedField: Field?
    @State private var isActive:Bool = false
    @ObservedObject private var user:User
    @ObservedObject private var postModels = PostModels()
    @State private var sheetIsPresent = false
    @State private var title = ""
    @State private var expirationDate = Date()
    @State private var description = ""
    @State private var location = ""
    @State private var postImageList:[Image] = []
    @State private var postsLoaded:Bool = false
    var body: some View {
        NoBarNavigationView{
            VStack{
                ZStack{
                    ScrollView {
                        VStack(spacing:20){
                            if postsLoaded{
                                ForEach(0 ..< postModels.postModels.count ,id:\.self){
                                    item in
                                    Button{
                                        self.location = postModels.postModels[item].location
                                        self.title = postModels.postModels[item].title
                                        self.description = postModels.postModels[item].description
                                        self.expirationDate = postModels.postModels[item].expirationDate
                                        self.postImageList = postModels.postModels[item].images
                                        self.sheetIsPresent = true
                                    }label:{
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(Color.white)
                                                .shadow(color: Color.black, radius: 1)
                                            VStack(alignment: .leading){
                                                HStack{
                                                    Text(postModels.postModels[item].title)
                                                        .fontWeight(.bold)
                                                        .font(.system(size:40))
                                                    Spacer()
                                                }.padding(.bottom,2)
                                                Text(postModels.postModels[item].location)
                                                    .font(.system(size:20))
                                                Spacer()
                                                Text(postModels.postModels[item].expirationDate,style: .date)
                                                    .foregroundColor(Color.blue)
                                            }.padding(24)
                                            HStack{
                                                Spacer()
//                                                Image(systemName: "chevron.right")
//                                                    .font(.system(size:40))
                                            }.padding(35)
                                        }.frame(width:360,height:150)
                                    }.buttonStyle(.plain)
                                }
                            }
                        }.offset(y:10)
                    }.padding(.top,90)
                        .refreshable {
                            postModels.getAllPosts {
                                postsLoaded = true
                            }
                        }
                    
                    
                    VStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 500, height: 140)
                                .foregroundColor(Color.white)
                                .offset(y:-40)
                            VStack {
                                TextField("foodType",text:$foodType,prompt:Text("What food do you prefer?"))
                                    .frame(width:340)
                                    .padding(.horizontal,10)
                                    .padding(.vertical,10)
                                    .focused($focusedField, equals: .foodType)
                                    .toolbar {
                                        ToolbarItem(placement: .keyboard) {
                                            Button("Done") {
                                                focusedField = nil
                                            }
                                        }
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.blue,lineWidth: 2)
                                        
                                    )
                                    .onTapGesture {
                                        self.overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.blue,lineWidth: 3)
                                        )
                                    }
                                    .offset(y:10)
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                            }
                        }
                        Divider()
                            .offset(y:-25)
                        Spacer()
                    }.ignoresSafeArea()
                    VStack{
                        Spacer()
                        HStack{
                            //                                NavigationLink(destination:(!user.isValidAccount ? AnyView(Profile()) : AnyView(AccountDetails(source: "ContentView").navigationBarHidden(true))),isActive: $isActive){
                            if !user.isValidAccount{
                                NavigationLink(destination:Profile(),isActive: $isActive){
                                    Button(action:{
                                        print("contentview profile triggered")
                                        isActive = true
                                        
                                    }){
                                        ZStack{
                                            Circle()
                                                .frame(width:58,height:58)
                                                .foregroundColor(Color.blue)
                                            Image(systemName: "person.crop.circle")
                                                .foregroundColor(Color.white)
                                                .font(.system(size:40))
                                            
                                        }
                                    }
                                }
                            }else{
                                NavigationLink(destination:(AccountDetails(source:"ContentView",user_:getUserDefaults()).navigationBarHidden(true)),isActive: $isActive){
                                    Button(action:{
                                        print("contentview AccountDetails triggered")
                                        isActive = true
                                        
                                    }){
                                        ZStack{
                                            Circle()
                                                .frame(width:58,height:58)
                                                .foregroundColor(Color.blue)
                                            Image(systemName: "person.crop.circle")
                                                .foregroundColor(Color.white)
                                                .font(.system(size:40))
                                            
                                        }
                                    }
                                }
                            }
                            Spacer()
                            if !user.isValidAccount{
                                NavigationLink(destination:Profile(to:"AddFood"),isActive: $isActive){
                                    Button(action:{
                                        print("contentview to Profile to Addfood")
                                        isActive = true
                                        
                                    }){
                                        ZStack{
                                            Circle()
                                                .frame(width:58,height:58)
                                                .foregroundColor(Color.blue)
                                            Image(systemName: "plus")
                                                .foregroundColor(Color.white)
                                                .font(.system(size:40))
                                            
                                        }
                                    }
                                }.frame(width: 70)
                            }else{
                                NavigationLink(destination:(AddFood(user_: getUserDefaults()).navigationBarHidden(true)),isActive: $isActive){
                                    Button(action:{
                                        print("contentview AddFood triggered")
                                        isActive = true
                                        
                                    }){
                                        ZStack{
                                            Circle()
                                                .frame(width:58,height:58)
                                                .foregroundColor(Color.blue)
                                            Image(systemName: "plus")
                                                .foregroundColor(Color.white)
                                                .font(.system(size:40))
                                            
                                        }
                                    }
                                }.frame(width: 70)
                            }
                        }
                    }.padding(.trailing,80)
                        .padding(.leading,80)
                }.padding(.horizontal,15)
                    .onAppear{
                        self.postModels.getAllPosts(loaded:{
                            postsLoaded = true
                        })
                    }
                
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .sheet(isPresented: $sheetIsPresent) {
                VStack{
                    ScrollView{
                        VStack(alignment: .leading, spacing: 5){
                            
                            Text(self.title)
                                .font(.system(size:45))
                                .fontWeight(.bold)
                            Text(self.location)
                            Text("Expiration Date")
                                .fontWeight(.heavy)
                                .font(.system(size:20))
                            Text(self.expirationDate,style: .date)
                                .foregroundColor(Color.blue)
                            VStack (alignment:.leading,spacing:5){
                                Text("Description")
                                    .fontWeight(.bold)
                                    .font(.system(size:20))
                                Text(self.description)
                            }.padding(.top)
                            
                            VStack{
                                ForEach(0 ..< self.postImageList.count,id:\.self){
                                    item in
                                    postImageList[item]
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 340)
                                }
                            }.padding(.top,20)
                        }.padding()
                            .frame(width: 360)
                            .padding(.top,15)
                    }
                }
            }
        }.navigationViewStyle(.stack)
    }
    init(user_:User){
        self.user = user_
        print("ContentView init : ContentVIew : "+String(user.isValidAccount))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(user_:getUserDefaults())
            .previewDevice("iPhone 13")
            .navigationBarHidden(true)
    }
}
