//
//  TestView.swift
//  Sharf
//
//  Created by 孫揚喆 on 2022/4/4.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        VStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 5){
                    
                    VStack{
                    Text("Title")
                            .font(.system(size:45))
                            .fontWeight(.bold)
                    Text("location")
                            .offset(y:-5)
                    }.padding(.bottom)
                    Text("Expiration Date")
                        .fontWeight(.heavy)
                        .font(.system(size:20))
                    Text(Date(),style: .date)
                        .foregroundColor(Color.blue)
                        .offset(x:15)
                    VStack (alignment:.leading,spacing:5){
                        Text("Description")
                            .fontWeight(.bold)
                        .font(.system(size:20))
                        Text("thisfklasdjflkdsajfklasdjkf l;askdjflka;sdfj a;lsdkfjasl;kdfj asdlkfjaslkdf asd;lfkj")
                    }.padding(.top)
                    
                    VStack{
                    Image("testPic")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 340)
                    Image("testPic")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 340)
                    Image("testPic")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 340)
                    Image("testPic")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 340)
                    }.padding(.top,20)
                }.padding()
                .frame(width: 360)
                .padding(.top,15)
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
            .previewDevice("iPhone 13")
    }
}
