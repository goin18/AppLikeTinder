//
//  SwipeView.swift
//  AppLikeTinder
//
//  Created by Marko Budal on 30/08/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import Foundation
import UIKit

class SwipeView: UIView {
    
    enum Direction {
        case None
        case Left
        case Right
    }
    
    weak var delegate: SwipeViewDelegate?
    
    var innerView: UIView? {
        didSet {
            if let v = innerView {
                addSubview(v)
                v.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            }
        }
    }
    
    private var originalPoint:CGPoint?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initalize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initalize()
    }
    
    private func initalize() {
        self.backgroundColor = UIColor.clearColor()
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "dragged:"))
    }
    
    func dragged(gestureRecognizer: UIPanGestureRecognizer) {
        let distance = gestureRecognizer.translationInView(self)
        //println("Distance x: \(distance.x) y: \(distance.y)")
        
        switch gestureRecognizer.state {
            case UIGestureRecognizerState.Began:
                originalPoint = center
            case UIGestureRecognizerState.Changed:
                let rorationPercentage = min(distance.x/(self.superview!.frame.width/2),1)
                let rotationAngle = (CGFloat(2*M_PI/16) * rorationPercentage)
                transform = CGAffineTransformMakeRotation(rotationAngle)
                center = CGPointMake(originalPoint!.x + distance.x, originalPoint!.y + distance.y)
            case .Ended:
                if abs(distance.x) < frame.width/4 {
                    resetViewPositionAndTransformations()
                }else {
                    swipe(distance.x > 0 ? .Right : .Left)
                }
            default:
                println("Default trigger for GestureRecognizer")
                break
        }
    }
    
    func swipe(s:Direction) {
        if s == .None {
            return
        }
        
        var parentWith = superview!.frame.size.width
        if s == .Left {
            parentWith *= -1
        }
        
        UIView.animateWithDuration(0.3, animations: {
                self.center.x = self.frame.origin.x + parentWith
            }, completion: {
            success in
                if let d = self.delegate {
                    s == Direction.Right ? d.swipeRight() : d.swipeLeft()
                }
        })
    }
    
    private func resetViewPositionAndTransformations() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.center = self.originalPoint!
            self.transform = CGAffineTransformMakeRotation(0)
        })
    }
}

protocol SwipeViewDelegate: class {
    func swipeLeft()
    func swipeRight()
}

