//
//  SharfApp.swift
//  Sharf
//
//  Created by 孫揚喆 on 2022/3/23.
//

import SwiftUI
import Firebase

@main
struct SharfApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView(user_:getUserDefaults())

        }
    }
}
