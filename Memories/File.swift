//
//  Pie.swift
//  Memories
//
//  Created by Gideon Boateng on 11/19/23.
//

import SwiftUI

// MARK: - Pie Shape

/// A custom shape representing a pie slice.
struct Pie: Shape {
    
    // MARK: - Properties
    
    /// The starting angle of the pie slice.
    var startAngle: Angle
    
    /// The ending angle of the pie slice.
    var endAngle: Angle
    
    /// A boolean indicating whether the pie slice should be drawn in a clockwise direction.
    var clockwise: Bool = false
    
    // MARK: - Animatable Properties
    
    /// The animatable data representing the start and end angles in radians.
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(startAngle.radians, endAngle.radians)
        }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }
    
    // MARK: - Path Drawing
    
    /// Creates the path for the pie slice within a given rectangle.
    /// - Parameter rect: The rectangle in which the pie slice is drawn.
    /// - Returns: The path representing the pie slice.
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        let start = CGPoint(
            x: center.x + radius * CGFloat(cos(startAngle.radians)),
            y: center.y + radius * CGFloat(sin(startAngle.radians))
        )
        
        var path = Path()
        path.move(to: center)
        path.addLine(to: start)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: !clockwise
        )
        path.addLine(to: center)
        
        return path
    }
}
