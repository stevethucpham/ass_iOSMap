//
//  UITableView.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/29/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit
import BLMultiColorLoader

extension UITableView {
    
    func showLoadingFooter(){
        let loadingFooter = BLMultiColorLoader()
        loadingFooter.colorArray = [UIColor.red]
        loadingFooter.frame.size.height = 25
        loadingFooter.lineWidth = 3
        loadingFooter.startAnimation()
        tableFooterView = loadingFooter
    }
    
    func hideLoadingFooter(){
        let tableContentSufficentlyTall = (contentSize.height > frame.size.height)
        let atBottomOfTable = (contentOffset.y >= contentSize.height - frame.size.height)
        if atBottomOfTable && tableContentSufficentlyTall {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentOffset.y = self.contentOffset.y - 50
            }, completion: { finished in
                self.tableFooterView = UIView()
            })
        } else {
            self.tableFooterView = UIView()
        }
    }
    
    func isLoadingFooterShowing() -> Bool {
        return tableFooterView is UIActivityIndicatorView
    }
    
}
