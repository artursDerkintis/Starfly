//
//  SCheckBox.swift
//  Soriana
//
//  Created by Guillermo Anaya Magallón on 25/09/14.
//  Copyright (c) 2014 wanaya. All rights reserved.
//

import UIKit

class SCheckBox: UIControl {
    
    let textLabel = UILabel()
    private let DefaultSideLength = CGFloat(20.0)
    private var colors = [UInt: UIColor]()
    private var backgroundColors = [UInt: UIColor]()
    var checkboxSideLength = CGFloat(0.0)
    
    var checkboxColor:UIColor = UIColor.blackColor() {
        didSet {
            self.textLabel.textColor = self.checkboxColor
            self.setNeedsDisplay()
        }
    }
    
    var checked:Bool = false {
        didSet {
            self.setNeedsDisplay()
            self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    private func commonInit() {
        self.textLabel.frame = CGRectZero
        self.checkboxSideLength = DefaultSideLength
        self.checkboxColor = UIColor.blackColor()
        self.backgroundColor = UIColor.clearColor()
        self.textLabel.backgroundColor = UIColor.clearColor()
        
        self.addSubview(self.textLabel)
        
        self.addObserver(self, forKeyPath: "enabled", options: NSKeyValueObservingOptions.New, context: nil)
        self.addObserver(self, forKeyPath: "selected", options: NSKeyValueObservingOptions.New, context: nil)
        self.addObserver(self, forKeyPath: "highlighted", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    func color(color:UIColor, forState state:UIControlState) {
        self.colors[state.rawValue] = color
        self.changeColorForState(self.state)
    }
    
    func backgroundColor(color:UIColor, forState state:UIControlState) {
        
        self.backgroundColors[state.rawValue] = color
        self.changeBackgroundColorForState(self.state)
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "enabled")
        self.removeObserver(self, forKeyPath: "selected")
        self.removeObserver(self, forKeyPath: "highlighted")
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "enabled" || keyPath == "selected" || keyPath == "highlighted"{
        
            self.changeColorForState(self.state)
            
        }
    }
    
    private func changeColorForState(state: UIControlState) {
        
        if let color = self.colors[state.rawValue] {
            self.checkboxColor = color
            self.textLabel.textColor = color
        }
    }
    
    private func changeBackgroundColorForState(state: UIControlState) {
        
        if let color = self.backgroundColors[state.rawValue] {
            self.backgroundColor = color
        }
    }
    
    override func drawRect(rect: CGRect) {
        _ = CGRectIntegral(CGRectMake(0, (rect.size.height - self.checkboxSideLength) / 2.0, self.checkboxSideLength, self.checkboxSideLength))
        
        if self.checked {
            
            
            //// Bezier Drawing
            let bezierPath = UIBezierPath()
            bezierPath.moveToPoint(CGPointMake(16, 22.8))
            bezierPath.addLineToPoint(CGPointMake(23.29, 30))
            bezierPath.addLineToPoint(CGPointMake(33, 18))
            bezierPath.lineCapStyle = CGLineCap.Round;
            
            bezierPath.lineJoinStyle = CGLineJoin.Round;
            
            self.checkboxColor.setStroke()
            bezierPath.lineWidth = 3
            bezierPath.stroke()
        }
        
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalInRect: CGRectMake(9, 9, 31, 31))
        self.checkboxColor.setStroke()
        ovalPath.lineWidth = 3
        ovalPath.stroke()
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
  
        
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        let location = touch!.locationInView(self)
        if CGRectContainsPoint(self.bounds, location) {
            self.checked = !self.checked
        }
    }
}




