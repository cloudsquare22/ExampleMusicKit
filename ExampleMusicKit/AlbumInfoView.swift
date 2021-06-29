//
//  AlbumInfoView.swift
//  ExampleMusicKit
//
//  Created by Shin Inaba on 2021/06/19.
//

import SwiftUI
import MusicKit

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
                    .font(.title2)
                    .padding(8.0)
                Text(self.music.selectAlbum!.artistName)
                    .padding(2.0)
                if let releaseDate = self.music.getReleaseDate(album: self.music.selectAlbum!) {
                    Label(releaseDate, systemImage: "calendar.circle")
                        .padding(2.0)
                        .symbolRenderingMode(.hierarchical)
                }
                Button(action: {
                    self.music.play(album: self.music.selectAlbum!)
                }) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Play")
                    }
                    .frame(maxWidth: 200)
                }
                .buttonStyle(ProminentButtonStyle())
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

/// `ProminentButtonStyle` is a custom button style that encapsulates
/// all the common modifiers for prominent buttons shown in the UI.
struct ProminentButtonStyle: ButtonStyle {
    
    /// The app-wide color scheme.
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    /// Applies relevant modifiers for this button style.
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.title3.bold())
            .foregroundColor(.accentColor)
            .padding()
            .background(backgroundColor.cornerRadius(8))
    }
    
    /// The background color appropriate for the current color scheme.
    private var backgroundColor: Color {
        return Color(uiColor: .systemGray4)
//        return Color(uiColor: (colorScheme == .dark) ? .secondarySystemBackground : .systemBackground)
    }
}
