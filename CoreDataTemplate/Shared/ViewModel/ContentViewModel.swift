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
        
        //MARK: - Properties
        @Published private var dataManager: DataManager
        
        ///anyCancellable is used to hold the subscription to the objectWillChange publisher of the dataManager
        var anyCancellable: AnyCancellable?
        
        var projects: [Project] {
            dataManager.projects
        }
        //MARK: - Initializers
        ///initializes the viewModel with the shared instance of the dataManager and subscriping to the objectWillChange publisher which is used to notify the view about changes in the dataManager
        init(dataManager: DataManager = .shared) {
            self.dataManager = dataManager
            anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
                self?.objectWillChange.send()
            }
        }
        //MARK: - Methods
        func createNewProject() {
            dataManager.createNewProject()
        }
        func deleteProject(at offsets: IndexSet) {
            dataManager.deleteProject(at: offsets)
        }
    }
}
