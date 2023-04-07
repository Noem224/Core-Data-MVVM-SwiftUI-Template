//
//  ContentView.swift
//  CoreDataTemplate
//
//  Created by Daniel Wippermann on 20.02.23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var contentViewModel = ContentViewModel()
    var body: some View {
        NavigationStack {
            List {
                ForEach(contentViewModel.projects) { project in
                    Text(project.title ?? "")
                }
                .onDelete(perform: contentViewModel.deleteProject)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            contentViewModel.createNewProject()
                        }
                        
                    } label: {
                        Label("Add Project", systemImage: "plus")
                    }
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView()
        }
    }
}
