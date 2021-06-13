//
//  ExampleMusicKitApp.swift
//  ExampleMusicKit
//
//  Created by Shin Inaba on 2021/06/13.
//

import SwiftUI

@available(iOS 15.0, *)
@main
struct ExampleMusicKitApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Music())
        }
    }
}
