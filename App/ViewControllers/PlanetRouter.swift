//
//  PlanetRouter.swift
//  WWDC22 Vincenzo Pascarella
//
//  Created by Vincenzo Pascarella on 23/04/22.
//

import SwiftUI

class PlanetRouter: ObservableObject{
    
    @Published var currentPlanet: selectedPlanet = .earth
}

enum selectedPlanet {
    case mercury
    case venus
    case earth
    case mars
    case jupiter
    case saturn
    case uranus
    case neptune
}
