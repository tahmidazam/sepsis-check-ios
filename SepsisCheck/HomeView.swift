//
//  HomeView.swift
//  SepsisCheck
//
//  Created by Tahmid Azam on 15/02/2024.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var appModel: AppModel = .init()
    @Query(sort: \Check.timestamp, order: .reverse) private var checks: [Check]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(checks) { check in
                    NavigationLink {
                        CheckDetail(check: .constant(check))
                    } label: {
                        CheckThumbnail(check: check)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("History")
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    
                    Button("New Check", systemImage: "plus") {
                        appModel.sheet = .newCheck
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .sheet(item: $appModel.sheet) { sheet in
                switch sheet {
                case .newCheck:
                    AgeBandView()
                        .environmentObject(appModel)
                }
            }
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
    HomeView()
        .modelContainer(for: Check.self, inMemory: true)
}
