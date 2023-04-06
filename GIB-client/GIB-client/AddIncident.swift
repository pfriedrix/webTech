//
//  AddIncident.swift
//  GIB-client
//
//  Created by Pfriedrix on 01.04.2023.
//

import SwiftUI
import MapKit

struct AddIncident: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var incidentVM = IncidentVM()
    @State var image: UIImage?
    @State var selectedCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @State var sheet = false
    var body: some View {
        VStack {
            TextField("description", text: $incidentVM.incident.description)
                .textFieldStyle(.roundedBorder)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(maxHeight: 100)
                .padding()
            Button {
                sheet.toggle()
            } label: {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 200, height: 200)
                        .aspectRatio(contentMode: .fit)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.accentColor)
                        .frame(width: 200, height: 200)
                }
            }
            .sheet(isPresented: $sheet) {
                ImagePicker(image: $image)
            }
            MapView(selectedCoordinate: $selectedCoordinate)
                .cornerRadius(10)
                .padding()
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    print(selectedCoordinate)
                    guard let image = image?.pngData() else { return }
                    incidentVM.incident.file = image
                    incidentVM.incident.longitude = selectedCoordinate.longitude
                    incidentVM.incident.latitude = selectedCoordinate.latitude
                    incidentVM.create { result in
                        switch result {
                        case .success(let incident):
                            print(incident)
                        case .failure(let error):
                            print(error)
                        }
                        dismiss()
                    }
                } label: {
                    Text("Save")
                }
            }
        }
    }
}

struct AddIncident_Previews: PreviewProvider {
    static var previews: some View {
        AddIncident()
    }
}
