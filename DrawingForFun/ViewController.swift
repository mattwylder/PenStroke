//
//  ViewController.swift
//  DrawingForFun
//
//  Created by Wylder, Matt on 7/14/23.
//

import UIKit

class ViewController: UIViewController {
    
    let canvas = Canvas()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(canvas)
        canvas.backgroundColor = .white
        canvas.frame = view.frame

//        pathAB.stroke()
    }
    
    
}

