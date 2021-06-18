//
//  AlbumShuffle.swift
//  ExampleMusicKit
//
//  Created by Shin Inaba on 2021/06/18.
//

import SwiftUI

@available(iOS 15.0, *)
struct AlbumShuffle: View {
    @EnvironmentObject var music: Music
    @State var searchText: String = ""
        
    var body: some View {
        NavigationView {
            List {                
                ForEach(self.music.artists) { artist in
                    NavigationLink(artist.name, destination: {
                        AlbumView(artist: artist)
                    })
                }
            }
            .navigationTitle("Artis Search")
        }
        .searchable("Artist", text: self.$searchText)
        .onSubmit(of: .search) {
            print(self.searchText)
            self.music.searchArtists(searchText: self.searchText)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

@available(iOS 15.0, *)
struct AlbumShuffle_Previews: PreviewProvider {
    static var previews: some View {
        AlbumShuffle()
            .environmentObject(Music())
    }
}
