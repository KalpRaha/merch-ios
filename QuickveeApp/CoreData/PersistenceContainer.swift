//
//  PersistenceContainer.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 02/01/26.
//


import CoreData

final class PersistenceContainer {
    
    static let shared = PersistenceContainer()
    private init() {
        configureContexts()
    }
    
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Quickvee") // Previous name : "MApp"
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    private func configureContexts() {
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // MARK: - Save

    func saveContext() {
        let context = container.viewContext
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
        }
    }

    // MARK: - Background Context

    func newBackgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
}
