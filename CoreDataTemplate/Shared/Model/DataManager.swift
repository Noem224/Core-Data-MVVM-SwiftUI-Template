//
//  DataManager.swift
//  CoreDataTemplate
//
//  Created by Daniel Wippermann on 20.02.23.
//

import CoreData

class DataManager: NSObject, ObservableObject {
    ///Single instance of the DataManager
    static let shared = DataManager()
    
    @Published var projects = [Project]()
    
    private var managedObjectContext: NSManagedObjectContext
    private var projectsFRC: NSFetchedResultsController<Project>
    
    private override init() {
        let persistenceController = PersistenceController()
        managedObjectContext = persistenceController.context
        
        let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        projectsFRC = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        projectsFRC.delegate = self
        try? projectsFRC.performFetch()
        projects = projectsFRC.fetchedObjects ?? []
    }
    
    func saveData() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
    
    //MARK: - Project Handling
    
    func createNewProject() {
        let newProject = Project(context: managedObjectContext)
        newProject.id = UUID()
        newProject.date = Date()
        newProject.title = "ExampleProject"
        
        saveData()
    }
    func deleteProject(at offsets: IndexSet) {
        for i in offsets {
            let projectToDelete = projects[i]
            managedObjectContext.delete(projectToDelete)
            saveData()
        }
    }
}

extension DataManager: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let newProjects = controller.fetchedObjects as? [Project] {
            print("new projects fetched...")
            projects = newProjects
        }
    }
}
