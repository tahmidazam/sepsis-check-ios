//
//  ContentView.swift
//  SepsisCheck
//
//  Created by Tahmid Azam on 09/02/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var checks: [Check]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(checks) { check in
                    NavigationLink {
                        CheckDetail(check: check)
                    } label: {
                        CheckThumbnail(check: check)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem(placement: .bottomBar) {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Check()
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(checks[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Check.self, inMemory: true)
}
