//
//  IncidentCard.swift
//  GIB-client
//
//  Created by Pfriedrix on 01.04.2023.
//

import SwiftUI
import MapKit
import Combine

struct IncidentCard: View {
    @State var incident: Incident
    
    @State var coordinateRegion = MKCoordinateRegion()
    
    var body: some View {
        VStack {
            HStack {
                // with pin to map
                Map(coordinateRegion: $coordinateRegion, annotationItems: [incident]) { i in
                    MapPin(coordinate: CLLocationCoordinate2D(latitude: incident.latitude, longitude: incident.longitude))
                }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 150)
                    .cornerRadius(10)
                    .onTapGesture {
                        print("click")
                    }
                if let image = UIImage(data: incident.file) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 150)
                }
            }
            Text(incident.description)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color.accentColor)
        .cornerRadius(10)
        .padding()
        .onReceive(Just(incident)) { value in
            coordinateRegion = value.coordinateRegion
        }
    }
}


// preview provider
struct IncidentCard_Previews: PreviewProvider {
    static var previews: some View {
        IncidentCard(incident: Incident(id: UUID(), description: "dalfjasldfs", latitude: 0, longitude: 0, file: Data()))
    }
}

