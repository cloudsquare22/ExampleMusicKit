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
        VStack {
            if let artwork = self.music.selectAlbum!.artwork {
                ArtworkImage(artwork, width: 200, height: 200)
                    .clipShape(Circle())
            }
            else {
                Image(systemName: "disc")
                    .clipShape(Circle())
            }
            Text(self.music.selectAlbum!.title)
            List {
                if let tracks = self.music.selectAlbum?.tracks {
                    ForEach(tracks) { track in
                        Text(track.title)
                    }
                }
                else {
                    Text("none")
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
