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
    
    func getJSONRPCList() {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        let jsonrpcURL = urlString + "/jsonrpc"
        
        let body: [String: Any] = [
            "jsonrpc": "2.0",
            "method": "getAll",
            "params": [:],
            "id": 1
        ]
        
        API.shared.post(url: jsonrpcURL, body: body) { [weak self ] (resp: Result<JSONRPCResponse, Error>) in
            guard let self = self else { return }
            defer {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
            switch resp {
            case .success(let response):
                switch response.result {
                case .success(let result):
                    self.incidents = result as? [Incident] ?? []
                case .failure(let error):
                    print(error.message)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
