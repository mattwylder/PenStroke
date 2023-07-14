//
//  CanvasView.swift
//  DrawingForFun
//
//  Created by Wylder, Matt on 7/14/23.
//

import Foundation
import UIKit

class Canvas: UIView {
    var curLine = [CGPoint]()
    var lines = [[CGPoint]]()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        for line in lines {
            for (i, p) in line.enumerated() {
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
        }
        
        for (i, p) in curLine.enumerated() {
            if i == 0 {
                context.move(to: p)
            } else {
                context.addLine(to: p)
            }
        }
        
        context.strokePath()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let point = touch.location(in: nil)
        curLine.append(point)
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append(curLine)
        curLine = [CGPoint]()
    }
}
