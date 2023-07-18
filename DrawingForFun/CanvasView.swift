//
//  CanvasView.swift
//  DrawingForFun
//
//  Created by Wylder, Matt on 7/14/23.
//

import Foundation
import UIKit

class Canvas: UIView {
    
    let isTouchPathEnabled = false
    
    var negativePath = UIBezierPath()
    var positivePath = UIBezierPath()
    
    let pathAB = UIBezierPath()

    var lastTouchPoint = CGPoint(x: 0, y: 0)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if isTouchPathEnabled {
            pathAB.stroke()
        }
        negativePath.stroke()
        positivePath.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let newTouchPoint = touches.first?.location(in: nil) else {
            return
        }
        if isTouchPathEnabled {
            pathAB.move(to: newTouchPoint)
        }
        negativePath.move(to: newTouchPoint)
        positivePath.move(to: newTouchPoint)
        lastTouchPoint = newTouchPoint
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let newTouchPoint = touch.location(in: nil)
        renderGutterPaths(width: touch.force*50, pointA: newTouchPoint, pointB: lastTouchPoint)
        if isTouchPathEnabled {
            pathAB.addLine(to: newTouchPoint)
        }
        lastTouchPoint = newTouchPoint
        setNeedsDisplay()
    }
    
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
    
    private func showSquare(_ point: CGPoint) {
        let size: CGFloat = 10
        let square = UIView(frame: CGRect(x: point.x - size / 2,
                                          y: point.y - size / 2,
                                          width: size,
                                          height: size))
        square.backgroundColor = .black
        self.addSubview(square)
    }
    
    private func renderGutterPaths(width: CGFloat, pointA: CGPoint, pointB: CGPoint) {
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
        
        negativePath.addLine(to: pointAtNegativeAngle)
        positivePath.addLine(to: pointAtPositiveAngle)
    }
}
