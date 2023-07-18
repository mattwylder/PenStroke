//
//  ViewController.swift
//  DrawingForFun
//
//  Created by Wylder, Matt on 7/14/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var canvas: CanvasView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        canvas.backgroundColor = .white
    }
    
    @IBAction func didUndo(_ sender: Any) {
        canvas.undo()
    }
    
    @IBAction func didClear(_ sender: Any) {
        canvas.clear()
    }
}

