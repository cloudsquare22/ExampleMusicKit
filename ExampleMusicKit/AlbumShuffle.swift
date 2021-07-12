//
//  AlbumShuffle.swift
//  ExampleMusicKit
//
//  Created by Shin Inaba on 2021/06/18.
//

import SwiftUI

struct AlbumShuffle: View {
    @EnvironmentObject var music: Music
    @State var searchText: String = ""
    @State var selection: Int = 0
    
    var body: some View {
        NavigationView {
            List {
                Section("Search") {
//                    Picker("Type", selection: self.$selection) {
//                        Text("Artist")
//                        Text("Album")
//                    }
//                    .pickerStyle(.segmented)
                    TextField("Search Text", text: self.$searchText)
                }
                Section("Result") {
                    ForEach(self.music.artists) { artist in
                        NavigationLink(artist.name, destination: {
                            AlbumView(artist: artist)
                                .environmentObject(self.music)
                        })
                    }

                }
            }
            .navigationTitle("Search")
        }
//        .searchable(text: self.$searchText, placement: .automatic, prompt: "Artist")
        .onSubmit(of: .text) {
            print(self.searchText)
            self.music.searchArtists(searchText: self.searchText)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AlbumShuffle_Previews: PreviewProvider {
    static var previews: some View {
        AlbumShuffle()
            .environmentObject(Music())
    }
}
