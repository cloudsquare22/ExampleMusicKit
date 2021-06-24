//
//  MusicData.swift
//  ExampleMusicKit
//
//  Created by Shin Inaba on 2021/06/13.
//

import SwiftUI
import MediaPlayer
import MusicKit
import Algorithms

@available(iOS 15.0, *)
class Music: ObservableObject {
    var status: MusicAuthorization.Status = MusicAuthorization.Status.notDetermined
    var player: SystemMusicPlayer? = nil
    var playerApl: ApplicationMusicPlayer? = nil
    @Published var albums: [Album] = []
    @Published var artists: MusicItemCollection<Artist> = []
    @Published var selectAlbum: Album? = nil
    
    init() {
        self.player = SystemMusicPlayer.shared
        self.playerApl = ApplicationMusicPlayer.shared
        async {
            await self.authotizationRequest()
        }
    }

    func authotizationRequest() async {
        self.status = await MusicAuthorization.request()
        print(self.status)
    }
    
    func searchAlbum(searchKey: String) {
        guard searchKey.isEmpty == false else {
            return
        }
        async {
            do {
                DispatchQueue.main.async {
                    self.albums = []
                }
                var request = MusicCatalogSearchRequest(term: searchKey, types: [Album.self])
                request.limit = 25
                let response = try await request.response()
                DispatchQueue.main.async {
                    self.albums += response.albums
                }
                var albums = response.albums
                while albums.hasNextBatch == true {
                    if let nextAlbums = try await albums.nextBatch(limit: 25) {
                        print(nextAlbums.count)
                        albums = nextAlbums
                        DispatchQueue.main.async {
                            self.albums += nextAlbums
                        }
                    }
                }

//                response.albums.forEach({ album in
//                    print(album.title)
//                })

                var requestArtist = MusicCatalogSearchRequest(term: searchKey, types: [Song.self])
                requestArtist.limit = 25
                let responseArtist = try await requestArtist.response()
                self.printMusicCatalogSearchResponse(response: responseArtist)
                print(responseArtist.debugDescription)
                
//                if let artist = responseArtist.artists.first {
//                    let artist3 = try await artist.with([.albums])
//                    print(artist3.debugDescription)
//                    print(artist3.albums?.count)
//                    if let albums = artist3.albums {
//                        var next = albums.hasNextBatch
//                        while next == true {
//                            let nextAlbums = try await albums.nextBatch(limit: 25)
//                            print(nextAlbums?.count)
//                            next = nextAlbums!.hasNextBatch
//                        }
//                    }


//                    var req3 = MusicCatalogResourceRequest<Artist>(matching: \.id, equalTo: artist.id)
//                    let res3 = try await req3.response()
//                    print(res3.debugDescription)
//
//
//                }
            }
            catch {
                
            }
        }
    }
    
    func searchAlbum(artist: Artist) async {
        do {
            self.albums = []
            let artistWith = try await artist.with([.albums])
            var searchAlbums: MusicItemCollection<Album> = []
            if let albumsWith = artistWith.albums {
                searchAlbums = albumsWith
                var albums = albumsWith
                while albums.hasNextBatch == true {
                    if let nextAlbums = try await albums.nextBatch(limit: 25) {
                        print(nextAlbums.count)
                        albums = nextAlbums
                        searchAlbums += nextAlbums
                    }
                }
                self.albums = searchAlbums.randomSample(count: searchAlbums.count)
                print(self.albums.debugDescription)
            }
        }
        catch {
            
        }
    }
    
    func searchArtists(searchText: String) {
        guard searchText.isEmpty == false else {
            return
        }
        async {
            do {
                DispatchQueue.main.async {
                    self.artists = []
                }
                var request = MusicCatalogSearchRequest(term: searchText, types: [Artist.self])
                request.limit = 25
                let response = try await request.response()
                DispatchQueue.main.async {
                    self.artists += response.artists
                }
                var artists = response.artists
                while artists.hasNextBatch == true {
                    if let nextArtists = try await artists.nextBatch(limit: 25) {
                        print(nextArtists.count)
                        artists = nextArtists
                        DispatchQueue.main.async {
                            self.artists += nextArtists
                        }
                    }
                }
            }
            catch {
                
            }
        }
    }
    
    func withTeacks() async {
        do {
            selectAlbum = try await self.selectAlbum?.with([.tracks])
            print(selectAlbum?.tracks?.count)
        }
        catch {
            
        }
        
    }
    
    func trackToSong(track: Track) -> Song? {
        var result: Song? = nil
        switch(track) {
        case .song(let song):
            result = song
//            print(song.debugDescription)
        default:
            break
        }
        return result
    }
    
    func artworkRate(artwork: Artwork) -> (Double, Double) {
        var result = (1.0, 1.0)
//        print(artwork.maximumWidth)
//        print(artwork.maximumHeight)
        if artwork.maximumWidth > artwork.maximumHeight {
            result.0 = 1.0
            result.1 = Double(artwork.maximumHeight) / Double(artwork.maximumWidth)
        }
        else {
            result.0 = Double(artwork.maximumWidth) / Double(artwork.maximumHeight)
            result.1 = 1.0
        }
//        print(result)
        return result
    }
    
    func getReleaseDate(album: Album) -> String {
        print(#function)
        print(album.debugDescription)
        var result: String = ""
     
        let pattern = ".*releaseDate: ($1).*"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return result }
        let matches = regex.matches(in: album.debugDescription, range: NSRange(location: 0, length: album.debugDescription.count))
        print("matches:\(matches)")
        
        return result
    }
    
    func play(album: Album) {
        if let player = self.player {
            player.setQueue(with: album)
            player.play()
        }
    }
    
    func printMusicCatalogSearchResponse(response: MusicCatalogSearchResponse) {
        print(response.debugDescription)
        print("Artist count:\(response.artists.count)")
        for artist in response.artists {
            if let albums = artist.albums {
                print("- Album count:\(albums.count)")
            }
            else {
                print("- Album count:nil")
            }
        }
        print("Album count:\(response.albums.count)")
        print("Playlists count:\(response.playlists.count)")
        print("Songs count:\(response.songs.count)")
    }
    
}
