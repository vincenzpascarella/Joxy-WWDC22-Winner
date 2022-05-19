//
//  MainView.swift
//  WWDC22 Vincenzo Pascarella
//
//  Created by Vincenzo Pascarella on 20/04/22.
//

import SwiftUI
import AVFoundation

struct MainView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var planetRouter: PlanetRouter
    @State var backgroundSound: AVAudioPlayer?
    
    var body: some View {
        switch viewRouter.currentPage {
        case .page1:
            StartView()
                .onAppear(perform: {
                if let audioURL = Bundle.main.url(forResource: "StartSound", withExtension: "mp3"){
                    do {
                        try backgroundSound = AVAudioPlayer(contentsOf: audioURL)
                        backgroundSound?.numberOfLoops = .max
                        backgroundSound?.play()
                        backgroundSound?.setVolume(0.1, fadeDuration: 0)
                    }catch{
                        print("Couldn't play audio. Error: \(error)")
                    }
                }else{
                    print("No audio file found")
                }
            })
            
        case .page2:
            GalaxyView()
                .onAppear{
                    backgroundSound?.setVolume(0.05, fadeDuration: 0.5)
                }
            
        case .page3:
            GravityView()
                .transition(.scale)
                .onAppear{
                    backgroundSound?.setVolume(0.02, fadeDuration: 0.5)
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ViewRouter())
            .environmentObject(PlanetRouter())
    }
}
