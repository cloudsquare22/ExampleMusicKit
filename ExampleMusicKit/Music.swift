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
    @Published var albums: MusicItemCollection<Album> = []
    
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
                var request = MusicCatalogSearchRequest(term: searchKey, types: [Album.self])
                request.limit = 25
                let response = try await request.response()
//                response.albums.forEach({ album in
//                    print(album.title)
//                })
                self.printMusicCatalogSearchResponse(response: response)
                DispatchQueue.main.async {
                    self.albums = response.albums
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
        print("Artist count:\(response.artists.count)")
        print("Album count:\(response.albums.count)")
        print("Playlists count:\(response.playlists.count)")
        print("Songs count:\(response.songs.count)")
    }
    
}
