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
    @State private var rotation: Double = 0
    @State private var isPlay: Bool = false
    @State private var isPlay1st: Bool = true
    @State private var isAnnimation: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width / 2.0
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle")
                            .font(.largeTitle)
                    }
                }

                AlbumArtwork(width: width, rotation: self.rotation, isPlay: self.$isPlay)
                AlbumText()

                Button(action: {
                    if self.isPlay == false {
                        if self.isPlay1st == true {
                            self.music.play(album: self.music.selectAlbum!)
                            self.isPlay1st = false
                            self.isAnnimation = true
                        }
                        else {
                            self.music.play()
                            self.isAnnimation = true
                        }
                        withAnimation(Animation.linear(duration: 5.0).repeatForever(autoreverses: false)) {
                            self.rotation = 360
                        }
                    }
                    else {
                        self.music.pause()
                        self.isAnnimation = false
                    }
                    self.isPlay.toggle()
                }) {
                    HStack {
                        if self.isPlay == false {
                            Image(systemName: "play.fill")
                        }
                        else {
                            Image(systemName: "playpause.fill")
                        }
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
        .onAppear {
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

struct AlbumArtwork: View {
    @EnvironmentObject var music: Music
    let width: Double
    let rotation: Double
    @Binding var isPlay: Bool
    
    var body: some View {
        if let artwork = self.music.selectAlbum!.artwork {
            let rate = self.music.artworkRate(artwork: artwork)
            ZStack {
                if let cgcolor = artwork.backgroundColor {
                    Color(cgColor: cgcolor)
                }
                else {
                    Color(uiColor: .systemGray4)
                }
                ArtworkImage(artwork, width: width * rate.0, height: width * rate.1)
                    .opacity(self.isPlay == false ? 1.0 : 0.0)
                ArtworkImage(artwork, width: width * rate.0, height: width * rate.1)
                    .rotationEffect(.degrees(rotation))
                    .opacity(self.isPlay == false ? 0.0 : 1.0)
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
    
struct AlbumText: View {
    @EnvironmentObject var music: Music
    
    var body: some View {
        VStack {
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
        }
    }
}
