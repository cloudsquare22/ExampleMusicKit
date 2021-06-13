//
//  ContentView.swift
//  ExampleMusicKit
//
//  Created by Shin Inaba on 2021/06/13.
//

import SwiftUI
import MusicKit

@available(iOS 15.0, *)
struct ContentView: View {
    @EnvironmentObject var music: Music
    @State var searchKey: String = ""
    
    var body: some View {
        VStack {
            TextField("Key", text: self.$searchKey)
                .textFieldStyle(.roundedBorder)
            Button(action: {
                self.music.searchAlbum(searchKey: self.searchKey)
            }, label: {
                Label("Search Albums", systemImage: "opticaldisc")
            })
                .buttonStyle(.bordered)
            List {
                ForEach(self.music.albums) { album in
                    Label(album.title, systemImage: "opticaldisc")
                        .onTapGesture {
                            self.music.play(album: album)
                        }
                }
            }
        }
        .padding(8.0)
    }
    
}

@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
