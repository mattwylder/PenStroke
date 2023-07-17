//
//  CanvasView.swift
//  DrawingForFun
//
//  Created by Wylder, Matt on 7/14/23.
//

import Foundation
import UIKit

class Canvas: UIView {
    
    var negativePath = UIBezierPath()
    var positivePath = UIBezierPath()
    
    let pathAB = UIBezierPath()

    var lastTouchPoint = CGPoint(x: 0, y: 0)
    
    override func didMoveToSuperview() {
        let startPoint = CGPoint(x: 600, y: 500)
        pathAB.move(to: startPoint)
        showSquare(startPoint)
        lastTouchPoint = startPoint
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //        negativePath.stroke()
        //        positivePath.stroke()
        pathAB.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let newTouchPoint = touches.first?.location(in: nil) else { return }
        
        pathAB.addLine(to: newTouchPoint)
        showSquare(newTouchPoint)
        addSidePoints(pointA: lastTouchPoint, pointB: newTouchPoint)
        setNeedsDisplay()
//        negativePath.move(to: newTouchPoint)
//        positivePath.move(to: newTouchPoint)
        lastTouchPoint = newTouchPoint
    }
    
    func addSidePoints(pointA: CGPoint, pointB: CGPoint) {
        let width: CGFloat = 50
        let distance = distance(p1: pointA, p2: pointB)
        let hypotenuse = hypotenuse(width: width, distance: distance)
        let angleAB = atan((pointB.y - pointA.y) / (pointB.x - pointA.x))
        let relativeAngle = asin(width / hypotenuse)

        let positiveAngle = angleAB + relativeAngle
        let negativeAngle = angleAB - relativeAngle

        let newPositiveY: CGFloat
        let newNegativeY: CGFloat
        let newPositiveX: CGFloat
        let newNegativeX: CGFloat
        
        let isUpward = pointB.y < pointA.y
        let isRightward = pointB.x > pointA.x

        if isRightward || (pointB.x == pointA.x && isUpward) {
            newPositiveY = pointA.y + hypotenuse * sin(positiveAngle)
            newNegativeY = pointA.y + hypotenuse * sin(negativeAngle)
            newPositiveX = pointA.x + hypotenuse * cos(positiveAngle)
            newNegativeX = pointA.x + hypotenuse * cos(negativeAngle)
        } else /*if isUpward && isLeftward*/ {
            newPositiveY = pointA.y - hypotenuse * sin(positiveAngle)
            newNegativeY = pointA.y - hypotenuse * sin(negativeAngle)
            newPositiveX = pointA.x - hypotenuse * cos(positiveAngle)
            newNegativeX = pointA.x - hypotenuse * cos(negativeAngle)
        }
        
        let pointAtPositiveAngle = CGPoint(x: newPositiveX,
                                           y: newPositiveY)
        let pointAtNegativeAngle = CGPoint(x: newNegativeX,
                                           y: newNegativeY)
        
        showSquare(pointAtNegativeAngle)
        showSquare(pointAtPositiveAngle)
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else {
//            return
//        }
//        let newTouchPoint = touch.location(in: nil)
//        let force: CGFloat = touch.force
//        let forceMultiplier: CGFloat = 100 * force
//        
//        // The new lines should be perpendicular angles to the new touch point
//        // we know distance between the two touched points, we know the distance to the drawn paths (force)
//        // solve hypotenuse for distance from lastPoint
//        // hypotenuse = sqrt(sq(force) + sq(distance))
//        // angle = sin(force / hypotenuse)
//        // or angle = tan(force / distance)
//        // desired point is a vector starting at lastTouchPoint moving hypotenuse points at angle
//        
//        // let's not consider force for a bit
//        
//        let strokeWidth: CGFloat = 100
//
//        negativePath.addLine(to: edgePoint(width: strokeWidth * force,
//                                           newPoint: newTouchPoint,
//                                           prevPoint: lastTouchPoint))
////        positivePath.addLine(to: CGPoint(x: newTouchPoint.x + 100,
////                                         y: newTouchPoint.y + 100))
//        setNeedsDisplay()
//        lastTouchPoint = newTouchPoint
//    }
    
    
    private func distance(p1: CGPoint, p2: CGPoint) -> CGFloat {
        sqrt(pow((p2.x - p1.x), 2) + pow((p2.y - p1.y), 2))
    }
    
    private func hypotenuse(width: CGFloat, distance: CGFloat) -> CGFloat {
        sqrt(pow(width, 2) + pow(distance, 2))
    }
    
    private func edgePoint(width: CGFloat, newPoint: CGPoint, prevPoint: CGPoint) -> CGPoint {
        let distance = distance(p1: newPoint, p2: prevPoint)
        let hypotenuse = hypotenuse(width: width, distance: distance)
        let angle = asin(width / hypotenuse)
        return CGPoint(x: prevPoint.x + hypotenuse * cos(angle),
                       y: prevPoint.y + hypotenuse * sin(angle))
    }
    
    func showSquare(_ point: CGPoint) {
        let size: CGFloat = 10
        let square = UIView(frame: CGRect(x: point.x - size / 2,
                                          y: point.y - size / 2,
                                          width: size,
                                          height: size))
        square.backgroundColor = .black
        let label = UILabel()
        label.text = "(\(point.x), \(point.y))"
        label.textColor = .black
        label.frame = CGRect(x: point.x, y: point.y, width: 100, height: 20)
        label.sizeToFit()
//        self.addSubview(label)
        self.addSubview(square)
    }

}
