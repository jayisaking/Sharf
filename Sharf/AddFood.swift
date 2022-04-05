//
//  AddFood.swift
//  Sharf
//
//  Created by 孫揚喆 on 2022/3/28.
//

import SwiftUI
import MapKit
import UIKit
//struct ImagePicker: UIViewControllerRepresentable {
//    var sourceType: UIImagePickerController.SourceType = .photoLibrary
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
//        let imagePicker = UIImagePickerController()
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = sourceType
//        return imagePicker
//    }
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
//    }
//}

struct AddFood: View {
    @State private var isShowPhotoLibrary = false
    @ObservedObject private var user:User
    @State private var inputImage: UIImage?
    @State private var userLocation = ""
    @State private var submitIsactive = false
    @State private var description = ""
    @State private var title = ""
    @State private var photoQuantity = 0
    @State private var image : Image?
    @State private var isChoosingLocation = false
    @State private var expirationDate = Date()
    @ObservedObject private var imageModels = ImageHandlers()
    init(user_:User = getUserDefaults()){
        user = user_
        print("AddFood init : AddFoodView with user account \(user.account)")
        
    }
    func loadImage() {
        guard let inputImage = inputImage else { return }
        imageModels.append(image: ImageHandler(account: user.account, number: photoQuantity, image: inputImage))
        photoQuantity+=1
        //        imageModels.imageModels[imageModels.imageModels.count-1].imageUpload(processer: {
        //        })
        //        user.updateUploadedImageCount()
    }
    var body: some View {
        NavigationView{
            ScrollView{
                //            VStack{
                //                            ForEach(0 ..< imageModels.imageModels.count, id:\.self){ item in
                //                                Image(uiImage: imageModels.imageModels[item].image)
                //                                    .resizable()
                //                                    .scaledToFit()
                //                            }
                //                image?
                //                    .resizable()
                //                    .scaledToFit()
                //                Button {
                //
                //                    isShowPhotoLibrary = true
                //                } label: {
                //                    Text("select pic")
                //                }
                VStack{
                    Text("ADD FOOD SUPPLY POST")
                        .font(.system(size:25))
                        .fontWeight(.bold)
                    Divider()
                    
                    VStack{
                        VStack{
                            HStack{
                                Image(systemName: "mail")
                                    .font(.system(size:22))
                                Text("Title")
                                    .font(.system(size:23))
                            }.padding()
                            TextField("Type in the title",text: $title)
                                .padding(.vertical,9)
                                .padding(.leading,15)
                                .frame(width:300)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lineWidth: 1)
                                )
                        }
                        Divider()
                            .background(Color.black)
                            .padding(.leading,15)
                            .padding(.trailing,10)
                        
                        VStack{
                            Button{
                                isShowPhotoLibrary = true
                            }
                        label:{
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color.blue)
                                    .frame(width: 240)
                                HStack{
                                    Image(systemName: "photo")
                                        .padding(.trailing,3)
                                        .font(.system(size:22))
                                        .foregroundColor(Color.white)
                                    Text("Add Photos")
                                        .foregroundColor(Color.white)
                                        .font(.system(size:23))
                                    //                            Spacer()
                                    //                            Image(systemName: "chevron.right")
                                    //                                .font(.system(size:20))
                                }.padding()
                            }
                        }
                            ScrollView(.horizontal){
                                HStack(alignment:.center){
                                    ForEach(0 ..< imageModels.imageModels.count, id:\.self){ item in
                                        ZStack{
                                            
                                            Image(uiImage: imageModels.imageModels[item].image)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height:120)
                                            Button{
                                                imageModels.imageModels.remove(at: item)
                                            }label:{
                                                Image(systemName: "xmark")
                                                    .foregroundColor(.white)
                                                    .font(.system(size:40))
                                            }
                                        }
                                    }
                                }
                            }.frame(width: 320, height: 150)
                        }.padding(.top)
                        
                        Divider()
                            .background(Color.black)
                            .padding(.leading,15)
                            .padding(.trailing,10)
                        VStack{
                            HStack{
                                Image(systemName: "signature")
                                    .font(.system(size:22))
                                Text("Description")
                                    .font(.system(size:23))
                            }.padding()
                            TextEditor(text: $description)
                                .frame(width:340,height:150)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lineWidth: 1)
                                )
                            
                        }
                        Divider()
                            .background(Color.black)
                            .padding(.leading,15)
                            .padding(.trailing,10)
                        VStack{
                            HStack{
                                Image(systemName: "location")
                                    .font(.system(size:22))
                                Text("Add Location")
                                    .font(.system(size:23))
                            }.padding()
                            TextField("Type in your address",text: $userLocation)
                                .padding(.vertical,10)
                                .padding(.leading,15)
                                .frame(width:340)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lineWidth: 1)
                                )
                        }
                        Divider()
                            .background(Color.black)
                            .padding(.leading,15)
                            .padding(.trailing,10)
                        HStack{
                            DatePicker(selection: $expirationDate,displayedComponents: .date, label: {
                                Image(systemName: "calendar")
                                    .font(.system(size:25))
                                Text("Expiration Date")
                                    .font(.system(size:23))
                                Spacer()
                            })
                        }.padding()
                        Divider()
                            .background(Color.black)
                            .padding(.leading,15)
                            .padding(.trailing,10)
                    }.padding(.trailing,20)
                        .padding(.leading,7)
                        .foregroundColor(Color.black)
                    
                    NavigationLink(destination:ContentView(user_: getUserDefaults()).navigationBarHidden(true), isActive: $submitIsactive) {
                        Button{
                            submitPost(ImageModels: self.imageModels, date: self.expirationDate, account: self.user.account, location: self.userLocation, description: self.description, title: self.title, userId: self.user.userId){
                                submitIsactive = true
                            }
                            
                        }label:{
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color.blue)
                                    .frame(width: 220,height:55)
                                HStack{
                                    Text("Submit")
                                        .foregroundColor(Color.white)
                                        .font(.system(size:23))
                                        .fontWeight(.bold)
                                    //                            Spacer()
                                    //                            Image(systemName: "chevron.right")
                                    //                                .font(.system(size:20))
                                }
                            }
                        }
                        .padding(.top,15)
                    }
                        
                    
                }.onChange(of: inputImage) { _ in loadImage() }
                    .sheet(isPresented: $isShowPhotoLibrary) {
                        ImagePicker(image: $inputImage)
                    }
                
            }.navigationBarHidden(true)
        }.navigationViewStyle(.stack)
    }
}

struct AddFood_Previews: PreviewProvider {
    static var previews: some View {
        AddFood()
    }
}
