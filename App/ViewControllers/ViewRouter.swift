//
//  ViewRouter.swift
//  WWDC22 Vincenzo Pascarella
//
//  Created by Vincenzo Pascarella on 20/04/22.
//

import SwiftUI

class ViewRouter: ObservableObject {
    
    @Published var currentPage: Page = .page1
    
}

enum Page {
    case page1
    case page2
    case page3
}
