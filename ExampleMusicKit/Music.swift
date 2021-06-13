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
    var player: MPMusicPlayerController? = nil
    var playerApl: ApplicationMusicPlayer? = nil
    @Published var albums: MusicItemCollection<Album> = []
    
    init() {
        self.player = MPMusicPlayerController.systemMusicPlayer
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
                response.albums.forEach({ album in
                    print(album.title)
                })
                DispatchQueue.main.async {
                    self.albums = response.albums
                }
            }
            catch {
                
            }
        }
    }
    
    func play(album: Album) {
        if let playerApl = self.playerApl {
            playerApl.setQueue(with: album)
            playerApl.play()
        }
    }
}
