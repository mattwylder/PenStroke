//
//  TouchPath.swift
//  DrawingForFun
//
//  Created by Wylder, Matt on 7/18/23.
//

import Foundation
import UIKit

struct Stroke {
    
    // MARK: Configuration Properties
    
    var forceMultiplier: CGFloat = 50
    
    // MARK: Path Management Properties
    
    let centerPath: UIBezierPath
    let negativePath: UIBezierPath
    let positivePath: UIBezierPath
    
    init() {
        centerPath = UIBezierPath()
        negativePath = UIBezierPath()
        positivePath = UIBezierPath()
    }
    
    // MARK: - Path Management Methods
    
    func start(at p: CGPoint) {
        centerPath.move(to: p)
        negativePath.move(to: p)
        positivePath.move(to: p)
    }
    
    func move(to newCenterPoint: CGPoint, with force: CGFloat) {
        let lastCenterPoint = centerPath.currentPoint
        guard let (positivePoint, negativePoint) =
                calculateGutterPoints(width: forceMultiplier * force,
                                      pointA: lastCenterPoint,
                                      pointB: newCenterPoint) else {
            return
        }
        centerPath.move(to: newCenterPoint)
        positivePath.addLine(to: positivePoint)
        negativePath.addLine(to: negativePoint)
    }
    
    // MARK: - Geometry Methods
    
    private func calculateGutterPoints(
        width: CGFloat,
        pointA: CGPoint,
        pointB: CGPoint
    ) -> (positive: CGPoint, negative: CGPoint)? {
        let strokeLength = distance(p1: pointA, p2: pointB)
        let hypotenuse = hypotenuse(width: width, distance: strokeLength)
        let strokeAngle = atan((pointB.y - pointA.y) / (pointB.x - pointA.x))
        let gutterAngle = asin(width / hypotenuse)

        let positiveAngle = strokeAngle + gutterAngle
        let negativeAngle = strokeAngle - gutterAngle

        let newPositiveY: CGFloat
        let newNegativeY: CGFloat
        let newPositiveX: CGFloat
        let newNegativeX: CGFloat
        
        let isStraightUpOrDown = pointB.x == pointA.x
        let isRightward = pointB.x > pointA.x

        if isStraightUpOrDown {
            newPositiveY = pointA.y + hypotenuse * sin(positiveAngle)
            newNegativeY = pointA.y + hypotenuse * sin(negativeAngle)
            newPositiveX = pointA.x + hypotenuse * cos(positiveAngle)
            newNegativeX = pointA.x + hypotenuse * cos(negativeAngle)
        } else if isRightward {
            newPositiveY = pointA.y + hypotenuse * sin(positiveAngle)
            newNegativeY = pointA.y + hypotenuse * sin(negativeAngle)
            newPositiveX = pointA.x + hypotenuse * cos(positiveAngle)
            newNegativeX = pointA.x + hypotenuse * cos(negativeAngle)
        } else {
            newPositiveY = pointA.y - hypotenuse * sin(positiveAngle)
            newNegativeY = pointA.y - hypotenuse * sin(negativeAngle)
            newPositiveX = pointA.x - hypotenuse * cos(positiveAngle)
            newNegativeX = pointA.x - hypotenuse * cos(negativeAngle)
        }
        
        if newPositiveX.isNaN || newNegativeX.isNaN ||
            newPositiveY.isNaN || newNegativeY.isNaN {
            return nil
        }
        
        let pointAtPositiveAngle = CGPoint(x: newPositiveX,
                                           y: newPositiveY)
        let pointAtNegativeAngle = CGPoint(x: newNegativeX,
                                           y: newNegativeY)
        return (pointAtPositiveAngle, pointAtNegativeAngle)
    }
    
    private func distance(p1: CGPoint, p2: CGPoint) -> CGFloat {
        sqrt(pow((p2.x - p1.x), 2) + pow((p2.y - p1.y), 2))
    }
    
    private func hypotenuse(width: CGFloat, distance: CGFloat) -> CGFloat {
        sqrt(pow(width, 2) + pow(distance, 2))
    }
}
