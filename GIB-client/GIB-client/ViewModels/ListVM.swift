//
//  ListVM.swift
//  GIB-client
//
//  Created by Pfriedrix on 01.04.2023.
//

import Foundation

class ListVM: ObservableObject {
    @Published var incidents = [Incident]()
    @Published var isLoading = false
    
    private let urlString = "http://localhost:8080/incidents"
    
    func getList() {
        guard !isLoading else {
            isLoading = true
            return
        }
        
        isLoading = true
        API.shared.get(url: urlString) {
            (result: Result<[Incident], Error>) in
            DispatchQueue.main.async {
                defer {
                    self.isLoading = false
                }
                switch result {
                case .success(let incidents):
                    self.incidents = incidents
                case .failure(let error):
                    print(error)
                }
                self.isLoading = false
            }
        }
    }
}
