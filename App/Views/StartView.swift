//
//  StartScreen.swift
//  WWDC22 Vincenzo Pascarella
//
//  Created by Vincenzo Pascarella on 17/04/22.
//

import SwiftUI
import AVFoundation

struct StartView: View {
    @State var isStarted = false
    @State var shadowScaling = false
    @State var tapAnimation = false
    
    @EnvironmentObject var viewRouter: ViewRouter

    
    let texts = [
        "Hi, I'm Joxy the astronaut",
        "I’m here to guide you exploring the solar system and understanding the gravity of its planets",
        "To start experiencing how the gravity changes on each planet, tap it and enjoy the AR experience"
    ]
    
    @State var selectedText = 0
    
    var body: some View {
        GeometryReader{ geo in
            ZStack(){
                
                
                Image("ColoredBackground")
                    .resizable()
                    .ignoresSafeArea()
                    .opacity(0.6)
                
                
                Image("Stars")
                    .resizable(resizingMode: .tile)
                    .ignoresSafeArea()
                    .opacity(0.4)
                
                HStack{
                    
                    Spacer()
                    VStack{
                    autoScalingImage(named: "Joxy", additionalScaling: isStarted ? 0.5 : 0.8)
                        .shadow(color: .blue.opacity(shadowScaling && !isStarted ? 0 : 1), radius: shadowScaling ? 0 : 150, x: 0, y: 0)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                    shadowScaling.toggle()
                                }
                        }
                    }
                    
                    if isStarted{
                        Spacer()
                        
                        Text(texts[selectedText])
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .frame(width: geo.size.width / 2.5)
                            .shadow(color: .black, radius: 10)
                            .scaleEffect(1.2)
                    }
                    Spacer()
                    
                }//HStack
                VStack{
                    Spacer()
                Text("Tap to continue")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .frame(width: geo.size.width / 2.5)
                    .shadow(color: .black, radius: 10)
                    .scaleEffect(1.2)
                    .opacity(tapAnimation ? 1 : 0)
                    .padding(.bottom, 32)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1).delay(4).repeatForever(autoreverses: true)) {
                                tapAnimation.toggle()
                            }
                    }
                }
                
            }//ZStack
            .frame(width: geo.size.width, height: geo.size.height)
            
        }//GeometryReader
        .background(Color.black.opacity(0.95))
        .onTapGesture{
            if isStarted && (selectedText<texts.count - 1){
                withAnimation {
                    selectedText += 1
                }
            } else if selectedText >= texts.count - 1 {
                withAnimation {
                    viewRouter.currentPage = .page2
                }
            }  else {
                withAnimation() {
                    isStarted = true
                }
            }
            
            tapAnimation = false
            withAnimation(.easeInOut(duration: 1).delay(4).repeatForever(autoreverses: true)) {
                    tapAnimation.toggle()
                }
            
            AudioServicesPlaySystemSound(1103)
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad mini (6th generation)")
            .environmentObject(ViewRouter())
    }
}
