//
//  CanvasView.swift
//  DrawingForFun
//
//  Created by Wylder, Matt on 7/14/23.
//

import Foundation
import UIKit

class CanvasView: UIView {
    
    let isTouchPathEnabled = false
    
    var paths = [UIBezierPath]()
    var curStroke = Stroke()

    var lastTouchPoint = CGPoint(x: 0, y: 0)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        for path in paths {
            path.fill()
        }
        curStroke.toBezier().fill()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let newTouchPoint = touches.first?.location(in: nil) else {
            return
        }
        curStroke.start(at: newTouchPoint)
        lastTouchPoint = newTouchPoint
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let newTouchPoint = touch.location(in: nil)
        curStroke.move(to: newTouchPoint, with: touch.force)
        lastTouchPoint = newTouchPoint
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        curStroke.finish(at: touch.location(in: nil))
        paths.append(curStroke.toBezier())
        curStroke = Stroke()
        setNeedsDisplay()
    }
    
    func clear() {
        paths.removeAll()
        setNeedsDisplay()
    }
    
    func undo() {
        if paths.count > 0 {
            paths.removeLast()
        }
        setNeedsDisplay()
    }
}
