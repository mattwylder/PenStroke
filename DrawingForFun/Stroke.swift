//
//  TouchPath.swift
//  DrawingForFun
//
//  Created by Wylder, Matt on 7/18/23.
//

import Foundation
import UIKit

class Stroke {
    
    // MARK: Configuration Properties
    
    var forceMultiplier: CGFloat = 50
    var smoothen = true
    
    // MARK: Path Management Properties
    private var lastCenterPoint = CGPoint()
    
    private var positiveArr = [CGPoint]()
    private var negativeArr = [CGPoint]()

    // MARK: - Path Management Methods
    
    func start(at p: CGPoint) {
        positiveArr.append(p)
        lastCenterPoint = p
    }
    
    func move(to newCenterPoint: CGPoint, with force: CGFloat) {
        guard let (positivePoint, negativePoint) =
                calculateGutterPoints(width: calculateStrokeWidth(force: force),
                                      pointA: lastCenterPoint,
                                      pointB: newCenterPoint) else {
            return
        }
        
        lastCenterPoint = newCenterPoint
        positiveArr.append(positivePoint)
        negativeArr.append(negativePoint)
    }
    
    func finish(at newCenterPoint: CGPoint) {
        positiveArr.append(newCenterPoint)
    }
    
    func toBezier() -> UIBezierPath {
        let result = UIBezierPath()
        
        for (i, p) in positiveArr.enumerated() {
            if i == 0 {
                result.move(to: p)
            } else {
                result.addLine(to: p)
            }
        }
        
        for (i, p) in negativeArr.reversed().enumerated() {
            if i == negativeArr.endIndex {
                result.close()
            } else {
                result.addLine(to: p)
            }
        }
        return result
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
    
    private func calculateStrokeWidth(force: CGFloat) -> CGFloat {
        if force == 0 {
            return 10
        }
        return forceMultiplier * force
    }
}
