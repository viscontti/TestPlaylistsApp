//
//  CoreDataStack.swift
//  TestPlaylistsApp
//
//  Created by n viscontti on 18.11.2026.
//
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "Model") 
        container.loadPersistentStores { _, error in
            if let error { fatalError("Store error: \(error)") }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
