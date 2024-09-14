//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Maks Winters on 09.09.2024.
//

import SwiftUI

struct ContentView: View {
    
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    let sortOptions = ["Default", "A-Z", "Country"]
    
    @State private var favorites = Favorites()
    @State private var searchText = ""
    @State private var selectedSortOption = "Default"
    
    var resortsSorted: [Resort] {
        switch selectedSortOption {
        case "A-Z":
            resorts.sorted()
        case "Country":
            resorts.sorted(by: { $0.country < $1.country })
        default:
            resorts
        }
    }
    
    var searchFiltered: [Resort] {
        if searchText.isEmpty {
            return resortsSorted
        } else {
            return resortsSorted.filter { $0.name.localizedStandardContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List {
                Section {
                    Picker("Sort by...", selection: $selectedSortOption) {
                        ForEach(sortOptions, id: \.self) { opt in
                            Text(opt)
                        }
                    }
                }
                ForEach(searchFiltered) { resort in
                NavigationLink(value: resort) {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(
                                .rect(cornerRadius: 5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundStyle(.secondary)
                        }
                        
                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
        }
            .navigationTitle("Resorts")
            .navigationDestination(for: Resort.self) { resort in
                ResortView(resort: resort)
            }
            .searchable(text: $searchText, prompt: "Search for resorts...")
        } detail: {
            WelcomeView()
        }
        .environment(favorites)
    }
}

#Preview {
    ContentView()
}
