//
//  Extensions.swift
//  WWDC22 Vincenzo Pascarella
//
//  Created by Vincenzo Pascarella on 17/04/22.
//

import SwiftUI


// MARK: iPad 1194 x 834 (original design) scaling viewModifier to scale views components between devices by Vincenzo Pascarella

extension View{
    
    func imageScaleEffect(horizontalAxe x: Bool = false, verticalAxe y: Bool = false, additionalScaling: Double = 1, anchor: UnitPoint = .center) -> some View{
        self.scaleEffect(scaling(horizontalAxe: x, verticalAxe: y) * additionalScaling, anchor: anchor)
    }
    
    private func scaling(horizontalAxe: Bool = false, verticalAxe: Bool = false) -> Double{
        let widthScaling = (UIScreen.main.bounds.size.width)/1194
        let heightScaling = (UIScreen.main.bounds.size.height)/834
        
        if !horizontalAxe && verticalAxe{
            return heightScaling
        } else if !verticalAxe && horizontalAxe {
            return widthScaling
        } else {
            return min(widthScaling, heightScaling)
        }
    }
}


func autoScalingImage(named imageName: String, horizontalAxe: Bool = false, verticalAxe: Bool = false, additionalScaling extraScaling: Double = 1) -> some View{
    let image = UIImage(named: imageName)!
    
    if !verticalAxe && horizontalAxe {
        let scalingFactor = UIScreen.main.bounds.size.width / 1194
        let imageMaxWidth = image.size.width * scalingFactor * extraScaling
        return Image(uiImage: image)
                .frame(maxWidth: imageMaxWidth)
                .imageScaleEffect(horizontalAxe: true, additionalScaling: extraScaling)
        
    } else if !horizontalAxe && verticalAxe {
        let scalingFactor = UIScreen.main.bounds.size.height / 834
        let imageMaxHeight = image.size.height * scalingFactor * extraScaling
        return Image(uiImage: image)
                .frame(maxHeight: imageMaxHeight)
                .imageScaleEffect(verticalAxe: true, additionalScaling: extraScaling)
    } else {
        let scalingWidthFactor = UIScreen.main.bounds.size.width / 1194
        let imageMaxWidth = image.size.width * scalingWidthFactor * extraScaling
        let scalingHeightFactor = UIScreen.main.bounds.size.height / 834
        let imageMaxHeight = image.size.height * scalingHeightFactor * extraScaling
        return Image(uiImage: image)
                .frame(maxWidth: imageMaxWidth, maxHeight: imageMaxHeight)
                .imageScaleEffect(additionalScaling: extraScaling)
    }
}
