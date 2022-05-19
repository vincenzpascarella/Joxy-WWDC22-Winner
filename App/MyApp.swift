import SwiftUI

@main
struct MyApp: App {
    
    @StateObject var viewRouter = ViewRouter()
    @StateObject var planetRouter = PlanetRouter()

    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(viewRouter)
                .environmentObject(planetRouter)
        }
    }
}
