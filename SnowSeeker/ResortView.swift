//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Maks Winters on 09.09.2024.
//

import SwiftUI
import SwiftFlags


struct ResortView: View {
    let resort: Resort
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(Favorites.self) var favorites
    
    @State private var selectedFacility: Facility?
    @State private var isShowingFacility = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Image(decorative: resort.id)
                    .resizable()
                    .scaledToFit()
                    .overlay { imageCreditForCurrentResort() }
                
                HStack {
                    if horizontalSizeClass == .compact && dynamicTypeSize > .large {
                        VStack(spacing: 10) { ResortDetailsView(resort: resort) }
                        VStack(spacing: 10) { SkiDetailsView(resort: resort) }
                    } else {
                        ResortDetailsView(resort: resort)
                        SkiDetailsView(resort: resort)
                    }
                }
                .padding(.vertical)
                .background(.primary.opacity(0.1))
                
                VStack(alignment: .leading) {
                    Text("\(resort.name)")
                        .font(.title)
                    HStack {
                        Text(SwiftFlags.flag(for: resort.country) ?? "🏳️")
                        Text("\(resort.country)")
                            .font(.subheadline)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                Group {
                    Text(resort.description)
                        .padding(.vertical)
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text("Facilities")
                                .font(.headline)
                                .padding(.bottom)
                            HStack(spacing: 20) {
                                ForEach(resort.facilityTypes) { facility in
                                    Button {
                                        selectedFacility = facility
                                        isShowingFacility = true
                                    } label: {
                                        facility.icon
                                            .font(.title)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal)
            }
            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
        }
        .alert(selectedFacility?.name ?? "More information", isPresented: $isShowingFacility, presenting: selectedFacility) { _ in
        } message: { facility in
            Text(facility.description)
        }
        .toolbar {
            Button {
                if favorites.contains(resort) {
                    favorites.remove(resort)
                } else {
                    favorites.add(resort)
                }
            } label: {
                if favorites.contains(resort) {
                    Image(systemName: "heart.fill").foregroundStyle(.red)
                } else {
                    Image(systemName: "heart")
                }
            }
            .buttonStyle(.plain)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func imageCreditForCurrentResort() -> some View {
        VStack {
            Spacer()
            HStack {
                Group {
                    Image(systemName: "camera.circle")
                    Text(resort.imageCredit)
                        .font(.subheadline)
                }
                .padding(5)
                .background {
                    RoundedRectangle(cornerRadius: 10.0)
                        .foregroundStyle(.thinMaterial)
                }
                Spacer()
            }
        }
        .padding()
    }
}


#Preview {
    ResortView(resort: .example)
        .environment(Favorites())
}
