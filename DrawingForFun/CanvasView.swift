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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        negativePath.stroke()
        positivePath.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let newTouchPoint = touches.first?.location(in: nil) else { return }
        negativePath.move(to: newTouchPoint)
        positivePath.move(to: newTouchPoint)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let newTouchPoint = touch.location(in: nil)
        let force = touch.force

        negativePath.addLine(to: CGPoint(x: newTouchPoint.x - 100 * force,
                                         y: newTouchPoint.y - 100 * force))
        positivePath.addLine(to: CGPoint(x: newTouchPoint.x + 100 * force,
                                         y: newTouchPoint.y + 100 * force))
        setNeedsDisplay()
    }
}
