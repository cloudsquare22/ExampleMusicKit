//
//  ExampleMusicKitApp.swift
//  ExampleMusicKit
//
//  Created by Shin Inaba on 2021/06/13.
//

import SwiftUI

@main
struct ExampleMusicKitApp: App {
    var body: some Scene {
        WindowGroup {
            AlbumShuffle()
                .environmentObject(Music())
//            ContentView()
//                .environmentObject(Music())
        }
    }
}
