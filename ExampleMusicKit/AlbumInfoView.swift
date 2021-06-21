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
                    ArtworkImage(artwork, width: Int(width), height: Int(width))
                        .clipShape(Circle())
                }
                else {
                    Image(systemName: "disc")
                        .clipShape(Circle())
                }
                Text(self.music.selectAlbum!.title)
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
                                Text("\(song.discNumber!)-\(song.trackNumber!) \(track.title)")
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
