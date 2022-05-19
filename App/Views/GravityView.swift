//
//  GravityView.swift
//  WWDC22 Vincenzo Pascarella
//
//  Created by Vincenzo Pascarella on 23/04/22.
//

import SwiftUI
import ARKit
import RealityKit
import AVFoundation

struct GravityView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var planetRouter: PlanetRouter
    
    
    @State var place = false
    @State var numberOfBoxes = 0
    @State var tapOpacity = false
    @State var firstTap = false
    static var coachIsNotActive = false
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        
        let numberOfBoxesCheck = (numberOfBoxes > 0) && (numberOfBoxes < 50)
        
        let selectedPlanet: String = { switch planetRouter.currentPlanet {
        case .mercury:
            return "Mercury"
        case .venus:
            return "Venus"
        case .earth:
            return "Earth"
        case .mars:
            return "Mars"
        case .jupiter:
            return "Jupiter"
        case .saturn:
            return "Saturn"
        case .uranus:
            return "Uranus"
        case .neptune:
            return "Neptune"
        }
            
        }()
        
        let planetGravity: Double = { switch planetRouter.currentPlanet {
        case .mercury:
            return 3.70
        case .venus:
            return 8.87
        case .earth:
            return 9.81
        case .mars:
            return 3.72
        case .jupiter:
            return 24.79
        case .saturn:
            return 10.44
        case .uranus:
            return 8.87
        case .neptune:
            return 11.15
        }
            
        }()
        
        GeometryReader{ geo in
            
            ZStack{
                                
                ARViewContainer(place: $place, check: numberOfBoxesCheck).edgesIgnoringSafeArea(.all)
                
                VStack{
                    HStack{
                        PlanetARDescription(selectedPlanet,gravity: planetGravity)
                        Spacer()
                    }//HStack Planet description
                    .frame(height: geo.size.height / 5)
                    
                    Spacer()
                    
                    HStack{
                        Button{
                            withAnimation {
                                viewRouter.currentPage = .page2
                            }
                        } label: {
                            Text("Back")
                                .font(.largeTitle.bold())
                                .foregroundColor(.black)
                                .shadow(color: .white, radius: 1, x: 0, y: 0)
                                .shadow(color: .white, radius: 4, x: 0, y: 0)
                                .scaleEffect(1.35, anchor: .leading)
                                .padding(.horizontal,32)
                                .padding(.vertical)
                                .contentShape(Rectangle())
                        }
                        
                        Spacer()
                        
                        if numberOfBoxes >= 50 {
                            Text("Max number of balls reached.\nTry the gravity on another planet!")
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 1, x: 0, y: 0)
                                .shadow(color: .black, radius: 4, x: 0, y: 0)
                                .padding(.horizontal,32)
                                .padding(.vertical)
                                .contentShape(Rectangle())
                            
                        }
                        
                    }//Hstack Back
                    
                }//VStack
                
                Text("Tap the screen to test the gravity \nwith falling rubber balls")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 1, x: 0, y: 0)
                    .shadow(color: .black, radius: 4, x: 0, y: 0)
                    .scaleEffect(1.5)
                    .multilineTextAlignment(.center)
                    .opacity(tapOpacity ? 1 : 0)
                    .onReceive(timer) { timer in
                        if !firstTap{
                            withAnimation(.easeInOut(duration: 1)) {
                                tapOpacity = GravityView.coachIsNotActive
                                
                            }
                        }
                    }
            }//ZStack
        }//GeomtryReader
        .onTapGesture {
            if GravityView.coachIsNotActive{
                numberOfBoxes += 1
                if !firstTap{
                    print("tapped")
                    firstTap = true
                    withAnimation{
                        tapOpacity = false
                    }
                    AudioServicesPlaySystemSound(1103)
                    place.toggle()
                    print(numberOfBoxes)
                }
                if numberOfBoxesCheck{
                    AudioServicesPlaySystemSound(1103)
                    
                    place.toggle()
                    print(numberOfBoxes)
                }
            }
        }
        
    }//body
}

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var planetRouter: PlanetRouter
    @Binding var place: Bool
    let check: Bool
    
    func coachActive(){
        
    }
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        
        config.planeDetection = [.horizontal, .vertical]
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh){
            config.sceneReconstruction = .mesh
        }
        
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.activatesAutomatically = true
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = arView.session
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.delegate = arView
        arView.addSubview(coachingOverlay)
        arView.session.run(config)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        DispatchQueue.main.async{
            var boxAnchor: HasAnchoring
            
            
            switch planetRouter.currentPlanet {
            case .mercury:
                boxAnchor = try! MercuryBall.loadBox()
            case .venus:
                boxAnchor = try! VenusBall.loadBox()
                
            case .earth:
                boxAnchor = try! EarthBall.loadBox()
                
            case .mars:
                boxAnchor = try! MarsBall.loadBox()
                
            case .jupiter:
                boxAnchor = try! JupiterBall.loadBox()
                
            case .saturn:
                boxAnchor = try! SaturnBall.loadBox()
                
            case .uranus:
                boxAnchor = try! UranusBall.loadBox()
                
            case .neptune:
                boxAnchor = try! NeptuneBall.loadBox()
                
            }
            
            if check && GravityView.coachIsNotActive {
                if place{
                    uiView.scene.addAnchor(boxAnchor)
                } else {
                    uiView.scene.addAnchor(boxAnchor)
                }
            }
        }
    }
    
}

#if DEBUG
struct GravityView_Previews: PreviewProvider {
    static var previews: some View {
        GravityView()
            .previewInterfaceOrientation(.landscapeRight)
            .previewDevice("iPad Pro (9.7-inch)")
            .environmentObject(ViewRouter())
            .environmentObject(PlanetRouter())
    }
}
#endif


extension ARView: ARCoachingOverlayViewDelegate{
    
    public func coachingOverlayViewDidDeactivate(
        _ coachingOverlayView: ARCoachingOverlayView
    ) {
        GravityView.coachIsNotActive = true
        print("Coaching completed")
        
    }
    public func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView){
        GravityView.coachIsNotActive = false
        print("Coaching in progress")
        
    }
}


