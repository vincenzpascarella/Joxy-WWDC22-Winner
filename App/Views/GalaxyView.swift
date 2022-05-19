//
//  GalaxyView.swift
//  WWDC22 Vincenzo Pascarella
//
//  Created by Vincenzo Pascarella on 23/04/22.
//


import SwiftUI
import AVFoundation

struct GalaxyView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var planetRouter: PlanetRouter
    
    @State var animatedRotation: Double = 0
    @State var starAnimation = false
    @State var planetShadows = false
    
    
    let planets: [Planet] = [
        Planet(name: "Mercury", rotation: 0, selectionName: .mercury),
        Planet(name: "Venus", rotation: 30, selectionName: .venus),
        Planet(name: "Earth", rotation: -90, selectionName: .earth),
        Planet(name: "Mars", rotation: 60, selectionName: .mars),
        Planet(name: "Jupiter", rotation: -45, selectionName: .jupiter),
        Planet(name: "Saturn", rotation: 50, selectionName: .saturn),
        Planet(name: "Uranus", rotation: -30, selectionName: .uranus),
        Planet(name: "Neptune", rotation: 10, selectionName: .neptune)]
    
    var body: some View {
        
        GeometryReader { geo in
            
            let isPortrait: Bool = (geo.size.height > geo.size.width)
            
            ZStack{
                
                Image("ColoredBackground")
                    .resizable()
                    .ignoresSafeArea()
                
                
                Image("Stars")
                    .resizable(resizingMode: .tile)
                    .ignoresSafeArea()
                    .opacity(starAnimation ? 0.4 : 0.1)
                    .onAppear{
                        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                            starAnimation.toggle()
                        }
                    }
                
                
                HStack {
                    
                    autoScalingImage(named: "Sun")
                        .padding(.leading, isPortrait ? -32 : 0)

                    
                    Spacer()
                }//Hstack Sun
                .frame(width: geo.size.width, height: geo.size.height)
                
                HStack{
                    Spacer()
                    
                    ForEach(planets, id: \.self){ planet in
                        VStack{
                            Spacer()
                            if(planet.rotation > 0){
                                Spacer()
                                
                            }
                            
                            autoScalingImage(named: planet.name)
                                .rotation3DEffect(.degrees(-planet.rotation + animatedRotation), axis: (x: 0, y: 0, z: 1))
                                .rotationEffect(.degrees(planet.rotation), anchor: .leading)
                                .shadow(color: .white.opacity(planetShadows ? 0 : 0.5), radius: planetShadows ? 1 : 30, x: 0, y: 0)
                                .onTapGesture {
                                    DispatchQueue.main.async{
                                        withAnimation(.linear) {
                                            animatedRotation = 360
                                        }
                                    }
                                    
                                    DispatchQueue.main.async{
                                        withAnimation(.linear.delay(1)){
                                            viewRouter.currentPage = .page3
                                            planetRouter.currentPlanet = planet.selectionName
                                        }
                                    }
                                    
                                    AudioServicesPlaySystemSound(1103)
                                }
                                .onAppear{
                                    withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                        planetShadows.toggle()
                                    }
                                }
                            
                            
                            
                            if(planet.rotation < 0){
                                Spacer()
                            }
                            
                            if(planet.rotation > 50){
                                Spacer()
                            }
                            
                            Spacer()
                        }
                    }
                    
                }//HStack planets
                .padding(.horizontal)
                .padding(.leading, 32)
                
            }//ZStack
            .background(Color.black.opacity(0.95))
            .frame(width: geo.size.width, height: geo.size.height)
            
        }//GeometryReader
        
    }//body
    
}//ContentView

struct GalaxyView_Previews: PreviewProvider {
    static var previews: some View {
        GalaxyView()
            .previewInterfaceOrientation(.portraitUpsideDown)
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
            .environmentObject(ViewRouter())
            .environmentObject(PlanetRouter())
    }
}
