//
//  AlbumView.swift
//  ExampleMusicKit
//
//  Created by Shin Inaba on 2021/06/18.
//

import SwiftUI
import MusicKit

@available(iOS 15.0, *)
struct AlbumView: View {
    @EnvironmentObject var music: Music
    var artist: Artist

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width / 3
            ScrollView {
                LazyVGrid(columns: Array(repeating: .init(.adaptive(minimum: width, maximum: width)), count: 3)) {
                    ForEach(self.music.albums) { album in
                        if let artwork = album.artwork {
                            ArtworkImage(artwork, width: Int(width), height: Int(width))
                                .onTapGesture {
                                    self.music.play(album: album)
                                }
                        }
                        else {
                            Image(systemName: "disc")
                        }
                    }
                }

            }
        }
        .task {
            await self.music.searchAlbum(artist: self.artist)
        }
        .navigationBarTitle(self.artist.name, displayMode: .inline)
    }
}

@available(iOS 15.0, *)
struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Album View")
//        AlbumView()
    }
}
