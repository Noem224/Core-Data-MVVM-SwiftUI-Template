//
//  ContentViewModel.swift
//  CoreDataTemplate
//
//  Created by Daniel Wippermann on 20.02.23.
//

import Foundation
import Combine

extension ContentView {
    
    final class ContentViewModel: ObservableObject {
        
        @Published private var dataManager: DataManager
        
        var projects: [Project] {
            dataManager.projects
        }
        
        init(dataManager: DataManager = .shared) {
            self.dataManager = dataManager
            anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
                self?.objectWillChange.send()
            }
        }
        
        var anyCancellable: AnyCancellable?
        
        func createNewProject() {
            dataManager.createNewProject()
        }
        func deleteProject(at offsets: IndexSet) {
            dataManager.deleteProject(at: offsets)
        }
    }
}
