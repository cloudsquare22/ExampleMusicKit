//
//  AlbumView.swift
//  ExampleMusicKit
//
//  Created by Shin Inaba on 2021/06/18.
//

import SwiftUI
import MusicKit

struct AlbumView: View {
    @EnvironmentObject var music: Music
    var artist: Artist
    @State var onAlbumInfoView = false

    var body: some View {
        GeometryReader { geometry in
            let lineCount = Int(geometry.size.width / 100)
            let width = geometry.size.width / CGFloat(lineCount) - 4.0
            ScrollView {
                LazyVGrid(columns: Array(repeating: .init(.adaptive(minimum: width, maximum: width)), count: lineCount), alignment: .center, spacing: 4.0) {
                    ForEach(self.music.albums) { album in
                        if let artwork = album.artwork {
                            let rate = self.music.artworkRate(artwork: artwork)
                            ZStack {
                                if let cgcolor = artwork.backgroundColor {
                                    Color(cgColor: cgcolor)
                                }
                                else {
                                    Color(uiColor: .systemGray4)
                                }
                                ArtworkImage(artwork, width: width * rate.0, height: width * rate.1)
                                    .onTapGesture(count: 2) {
                                        self.music.play(album: album)
                                    }
                                    .onTapGesture {
                                        print("tap 1")
                                        self.music.selectAlbum = album
                                        self.onAlbumInfoView.toggle()
    //                                    self.music.play(album: album)
                                    }

                            }
                            .frame(width: width, height: width)
                            .clipShape(Circle())
                        }
                        else {
                            Image(systemName: "disc")
                                .clipShape(Circle())
                        }
                    }
                }

            }
            .fullScreenCover(isPresented: self.$onAlbumInfoView, onDismiss: {}) {
                AlbumInfoView()
            }
//            .sheet(isPresented: self.$onAlbumInfoView, onDismiss: {}) {
//                AlbumInfoView()
//            }
        }
        .task {
            await self.music.searchAlbum(artist: self.artist)
        }
        .navigationBarTitle(self.artist.name, displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.music.selectAlbum = self.music.playingAlbum
            self.onAlbumInfoView.toggle()
        }, label: {Image(systemName: "play.rectangle.on.rectangle").font(.title)}))
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Album View")
//        AlbumView()
    }
}
