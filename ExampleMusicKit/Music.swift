//
//  MusicData.swift
//  ExampleMusicKit
//
//  Created by Shin Inaba on 2021/06/13.
//

import SwiftUI
import MediaPlayer
import MusicKit

@available(iOS 15.0, *)
class Music: ObservableObject {
    var status: MusicAuthorization.Status = MusicAuthorization.Status.notDetermined
    var player: SystemMusicPlayer? = nil
    var playerApl: ApplicationMusicPlayer? = nil
    @Published var albums: [Album] = []
    
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
                var offset = 0
                var next = true
                while next {
                    request.offset = offset
                    let response = try await request.response()
                    self.printMusicCatalogSearchResponse(response: response)
                    DispatchQueue.main.async {
                        for album in response.albums {
                            self.albums.append(album)
                        }
                    }
                    if response.albums.count < 25 {
                        next = false
                    }
                    offset = offset + 25
                }

//                response.albums.forEach({ album in
//                    print(album.title)
//                })

                var requestArtist = MusicCatalogSearchRequest(term: searchKey, types: [Artist.self])
                requestArtist.limit = 25
                let responseArtist = try await requestArtist.response()
                self.printMusicCatalogSearchResponse(response: responseArtist)
                
                if let artist = responseArtist.artists.first {
                    let artist3 = try await artist.with([.albums])
                    print(artist3.debugDescription)
                    print(artist3.albums?.count)


                    var req3 = MusicCatalogResourceRequest<Artist>(matching: \.id, equalTo: artist.id)
                    let res3 = try await req3.response()
                    print(res3.debugDescription)


                }
            }
            catch {
                
            }
        }
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
