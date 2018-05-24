//
//  RefreshControl.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/24/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit

class RefreshControl: UIRefreshControl {
    lazy var loadingView: LoadMoreView = {
        let contentView = LoadMoreView(frame: self.bounds)
        self.backgroundColor = UIColor.clear
        self.tintColor = UIColor.clear
        self.addSubview(contentView)
        return contentView
    }()
    
    override func beginRefreshing() {
        loadingView.beginRefreshing()
    }
}
