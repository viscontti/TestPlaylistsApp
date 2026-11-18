//
//  Generator.swift
//  TestPlaylistsApp
//
//  Created by n viscontti on 18.11.2026.
//

import CoreData

final class Generator {
    private let container: NSPersistentContainer

    init(container: NSPersistentContainer = CoreDataStack.shared.container) {
        self.container = container
    }

    func generateIfNeeded(playlists: Int = 1_000,
                          tracksPerPlaylist: Int = 100,
                          completion: @escaping (Result<Void, Error>) -> Void) {
        container.performBackgroundTask { context in
            do {
                let countRequest = NSFetchRequest<Track>(entityName: "Track")
                if try context.count(for: countRequest) > 0 {
                    DispatchQueue.main.async { completion(.success(())) }
                    return
                }

                for index in 0..<playlists {
                    let playlist = Playlist(context: context)
                    playlist.id = UUID()
                    playlist.title = "Playlist \(index + 1)"

                    for _ in 0..<tracksPerPlaylist {
                        let track = Track(context: context)
                        track.id = UUID()
                        track.title = Self.randomTitle()
                        track.duration = Double.random(in: 60...600)
                        track.playlist = playlist
                    }

                    if (index + 1) % 50 == 0 {
                        try context.save()
                        context.reset()
                    }
                }
                try context.save()
                DispatchQueue.main.async { completion(.success(())) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }

    private static let words = ["Calm", "Deep", "Morning", "Ocean", "Forest",
                                "Breath", "Night", "Focus", "Rain", "Light"]

    private static func randomTitle() -> String {
        let first = words.randomElement() ?? ""
        let second = words.randomElement() ?? ""
        return "\(first) \(second) #\(Int.random(in: 1...9_999))"
    }
}
