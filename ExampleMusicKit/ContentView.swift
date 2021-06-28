//
//  ContentView.swift
//  ExampleMusicKit
//
//  Created by Shin Inaba on 2021/06/13.
//

import SwiftUI
import MusicKit

struct ContentView: View {
    @EnvironmentObject var music: Music
    @State var searchKey: String = ""
    
    var body: some View {
        VStack {
            TextField("Key", text: self.$searchKey)
                .textFieldStyle(.roundedBorder)
            Button(action: {
                UIApplication.shared.closeKeyboard()
                self.music.searchAlbum(searchKey: self.searchKey)
            }, label: {
                Label("Search Albums", systemImage: "opticaldisc")
            })
                .buttonStyle(.bordered)
            List {
                ForEach(self.music.albums) { album in
                    HStack {
                        if let artwork = album.artwork {
                            ArtworkImage(artwork, width: 50, height: 50)
                        }
                        else {
                            Image(systemName: "opticaldisc")
                        }
                        Text(album.title)
                    }
                    .onTapGesture {
                        self.music.play(album: album)
                    }
                }
            }
        }
        .padding(8.0)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Music())
    }
}

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
