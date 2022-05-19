//
//  PlanetARDescription.swift
//  WWDC22 Vincenzo Pascarella
//
//  Created by Vincenzo Pascarella on 23/04/22.
//

import SwiftUI

struct PlanetARDescription: View {
    let planetName: String
    let planetGravity: Double
    init(_ name: String,gravity: Double ){
        planetName = name
        planetGravity = gravity
    }
    var body: some View {
        HStack{
            Image(planetName)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text(planetName + (planetName == "Uranus" ? "'" : "'s") + " gravity: \(planetGravity) m/s\u{00B2}")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
                .shadow(color: .black, radius: 1, x: 0, y: 0)
                .shadow(color: .black, radius: 4, x: 0, y: 0)
                .scaleEffect(1.2, anchor: .leading)
            
        }
    }
}

struct PlanetARDescription_Previews: PreviewProvider {
    static var previews: some View {
        PlanetARDescription("Jupiter",gravity: 9.8)
    }
}
