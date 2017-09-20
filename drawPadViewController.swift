//
//  drawPadViewController.swift
//  strokeNinja
//
//  Created by Toro Roan on 9/19/17.
//  Copyright © 2017 Toro Roan. All rights reserved.
//

import UIKit

class drawPadViewController: UIViewController {

    var lastPoint = CGPoint(x: 0, y: 0)
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    let colors: [(CGFloat, CGFloat, CGFloat)] = [
        // black tag 0
        (0, 0, 0),
        // gray tag 1
        (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
        // red tag 2
        (1.0, 0, 0),
        // blue tag 3
        (0, 0, 1.0),
        // light blue tag 4
        (51.0 / 255.0, 204.0 / 255.0, 1.0),
        // green tag 5
        (102.0 / 255.0, 204.0 / 255.0, 0),
        // light green tag 6
        (102.0 / 255.0, 1.0, 0),
        // brown tag 7
        (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
        // orange tag 8
        (1.0, 102.0 / 255.0, 0),
        // yellow tag 9
        (1.0, 1.0, 0),
        // white tag 10
        (1.0, 1.0, 1.0),
        ]
    
    @IBOutlet weak var mainImageView: UIImageView!

    @IBOutlet weak var tempImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        // 1
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        // 2
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        // 3
        context?.setLineCap(.round)
        context?.setLineWidth(brushWidth)
    
        
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: opacity)
        context?.setBlendMode(.normal)
        
        // 4
        context?.strokePath()
        
        // 5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = 1
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with Event: UIEvent?) {
        // 6
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            
            // 7
            lastPoint = currentPoint
        }
    }
    
    func touchesEnded(touches: Set<UITouch>, with Event: UIEvent?) {
        
        if !swiped {
            // draw a single point
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: .normal, alpha: 1.0)
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: .normal, alpha: 1.0)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }

    
    @IBAction func pencilPressed(_ sender: UIButton) {
        var index = sender.tag 
        if index < 0 || index >= colors.count {
            index = 0
            
        }
        
        // swift tuple set multiple var
        (red, green, blue) = colors[index]
        brushWidth = 10
        
        if index == colors.count - 1 {
            opacity = 1.0
            brushWidth = 30
        }
    }
    
    @IBAction func brushSizeSlider(_ sender: UISlider) {
        brushWidth = CGFloat(Float(sender.value))
    }
    
    @IBAction func opacitySlider(_ sender: UISlider) {
        opacity = CGFloat(Float(sender.value))
    }

}
