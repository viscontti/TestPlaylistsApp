//
//  TracksRepository.swift
//  TestPlaylistsApp
//

import CoreData

final class TracksRepository {
    private let container: NSPersistentContainer

    init(container: NSPersistentContainer = CoreDataStack.shared.container) {
        self.container = container
    }

    func fetchTracks(completion: @escaping (Result<[TrackItem], Error>) -> Void) {
        container.performBackgroundTask { context in
            do {
                let request = NSFetchRequest<Track>(entityName: "Track")
                request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                request.relationshipKeyPathsForPrefetching = ["playlist"]

                let tracks = try context.fetch(request)
                let items = tracks.compactMap { track -> TrackItem? in
                    guard let id = track.id, let title = track.title else { return nil }
                    return TrackItem(id: id,
                                     title: title,
                                     duration: track.duration,
                                     playlistTitle: track.playlist?.title ?? "")
                }
                DispatchQueue.main.async { completion(.success(items)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
}
