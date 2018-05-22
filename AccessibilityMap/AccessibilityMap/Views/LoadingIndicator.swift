//
//  LoadingIndicator.swift
//  UbiqApp
//
//  Created by admin on 4/20/17.
//  Copyright © 2017 ubiq. All rights reserved.
//

import UIKit
import BLMultiColorLoader

class LoadingIndicator {
    
    static let shared: LoadingIndicator = LoadingIndicator()
    private var indicatorView: BLMultiColorLoader
    private var containerView: UIView
    
    private init() {
        // Setup indicator view
        indicatorView = BLMultiColorLoader()
        indicatorView.addConstraint(NSLayoutConstraint(item: indicatorView,
                                                       attribute: .width,
                                                       relatedBy: .equal,
                                                       toItem: nil,
                                                       attribute: .notAnAttribute,
                                                       multiplier: 1,
                                                       constant: 60))
        indicatorView.addConstraint(NSLayoutConstraint(item: indicatorView,
                                                       attribute: .height,
                                                       relatedBy: .equal,
                                                       toItem: nil,
                                                       attribute: .notAnAttribute,
                                                       multiplier: 1,
                                                       constant: 60))
        indicatorView.colorArray = [UIColor.white]
        indicatorView.lineWidth = 4
        
        // Setup container view
        containerView = UIView(frame: UIScreen.main.bounds)
        containerView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        containerView.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraint(NSLayoutConstraint(item: indicatorView,
                                                       attribute: .centerX,
                                                       relatedBy: .equal,
                                                       toItem: containerView,
                                                       attribute: .centerX,
                                                       multiplier: 1,
                                                       constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: indicatorView,
                                                       attribute: .centerY,
                                                       relatedBy: .equal,
                                                       toItem: containerView,
                                                       attribute: .centerY,
                                                       multiplier: 1,
                                                       constant: 0))
        
        // Setup notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    @objc func applicationDidBecomeActive() {
        indicatorView.startAnimation()
    }

    func show() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        containerView.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(containerView)
        window.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|",
                                                             options: .directionLeftToRight,
                                                             metrics: nil,
                                                             views: ["view": containerView]))
        window.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|",
                                                             options: .directionLeftToRight,
                                                             metrics: nil,
                                                             views: ["view": containerView]))
        containerView.alpha = 0
        indicatorView.startAnimation()
        UIView.animate(withDuration: 0.1) {
            self.containerView.alpha = 1
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.1, animations: {
            self.containerView.alpha = 0
        }, completion: {_ in
            self.containerView.removeFromSuperview()
            self.indicatorView.stopAnimation()
        })
    }
}
