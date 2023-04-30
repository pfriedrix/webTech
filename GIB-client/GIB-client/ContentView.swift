//
//  ContentView.swift
//  GIB-client
//
//  Created by Pfriedrix on 01.04.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var listVM = ListVM()
    
    var body: some View {
        NavigationView {
            ScrollView (showsIndicators: false) {
                VStack {
                    ForEach(listVM.incidents, id: \.self) { incident in
                        IncidentCard(incident: incident)
                    }
                }
            }
            .overlay {
                if listVM.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(uiColor: .label)))
                        .scaleEffect(2)
                }
            }
            .navigationTitle("Incidents")
            .toolbar {
                ToolbarItem (placement: .navigationBarTrailing) {
                    NavigationLink {
                        AddIncident()
                    } label: {
                        Image(systemName: "plus.message.fill")
                            .foregroundColor(Color(uiColor: .label))
                    }
                    .disabled(listVM.isLoading)
                    .tint(.red)
                }
            }
            .onAppear {
                listVM.getJSONRPCList()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
