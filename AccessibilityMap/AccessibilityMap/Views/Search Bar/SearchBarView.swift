//
//  SearchBarView.swift
//  AccessibilityMap
//
//  Created by iOS Developer on 5/22/18.
//  Copyright © 2018 Swinburne. All rights reserved.
//

import UIKit

class SearchBarView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var searchBarButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchLabel: UILabel!
    var filterButtonClicked: (() -> Void)?
    var searchButtonClicked: (() -> Void)?
    
    var searchText: String! {
        didSet {
            self.searchLabel.text = searchText
        }
    }
    
    @IBAction func searchBarButtonClicked(_ sender: Any) {
        if let searchButtonClicked = searchButtonClicked {
            searchButtonClicked()
        }
    }
    
    @IBAction func filterButtonClicked(_ sender: Any) {
        if let filterButtonClicked = filterButtonClicked  {
            filterButtonClicked()
        }
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
        Bundle.main.loadNibNamed("SearchBarView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.layer.cornerRadius = 5
        contentView.layer.shadowColor = UIColor.darkGray.cgColor
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowOffset = CGSize.zero
        contentView.layer.shadowRadius = 10
        addSubview(contentView)
    }
    
}
