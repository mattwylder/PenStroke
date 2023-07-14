//
//  ViewController.swift
//  DrawingForFun
//
//  Created by Wylder, Matt on 7/14/23.
//

import UIKit

class ViewController: UIViewController {
    
    let canvas = Canvas()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(canvas)
        canvas.backgroundColor = .white
        canvas.frame = view.frame
    }
}

