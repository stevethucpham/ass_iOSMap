//
//  LoadMoreView.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/24/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit
import BLMultiColorLoader

class LoadMoreView: UIView {
     @IBOutlet var loadingIndicator: BLMultiColorLoader!
     @IBOutlet var contentView: UIView!
    
    override func awakeFromNib() {
        loadingIndicator.colorArray = [UIColor(hexString: Styles.Color.navigationBar)!]
        loadingIndicator.startAnimation()
    }
    
    func beginRefreshing() {
        loadingIndicator.colorArray = [UIColor(hexString: Styles.Color.navigationBar)!]
        loadingIndicator.startAnimation()
    }
    
    func stopRefreshing() {
        loadingIndicator.stopAnimation()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("LoadMoreView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }
}
