//
//  AlbumInfoView.swift
//  ExampleMusicKit
//
//  Created by Shin Inaba on 2021/06/19.
//

import SwiftUI
import MusicKit

@available(iOS 15.0, *)
struct AlbumInfoView: View {
    @EnvironmentObject var music: Music
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width / 2.0
            VStack {
                if let artwork = self.music.selectAlbum!.artwork {
                    let rate = self.music.artworkRate(artwork: artwork)
                    ZStack {
                        if let cgcolor = artwork.backgroundColor {
                            Color(cgColor: cgcolor)
                        }
                        else {
                            Color(uiColor: .systemGray4)
                        }
                        ArtworkImage(artwork, width: Int(width * rate.0), height: Int(width * rate.1))
                    }
                    .frame(width: width, height: width)
                    .clipShape(Circle())
                }
                else {
                    Image(systemName: "disc")
                        .clipShape(Circle())
                }
                Text(self.music.selectAlbum!.title)
                Text(self.music.selectAlbum!.artistName)
                Text(self.music.getReleaseDate(album: self.music.selectAlbum!))
                Button(action: {
                    self.music.play(album: self.music.selectAlbum!)
                }) {
                    Image(systemName: "play.circle")
                        .font(.largeTitle)
                }
                List {
                    if let tracks = self.music.selectAlbum?.tracks {
                        ForEach(tracks) { track in
                            if let song = self.music.trackToSong(track: track) {
                                Text("\(song.title)")
                            }
                        }
                    }
                }
            }
        }
        .task {
            await self.music.withTeacks()
        }
    }
}

struct AlbumInfoView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Album Inof View")

        //        AlbumInfoView()
    }
}
