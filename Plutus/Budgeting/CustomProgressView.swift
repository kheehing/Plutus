//
//  CustomProgressView.swift
//  Plutus
//
//  Created by Vellyn Tjandra on 30/11/19.
//  Copyright © 2019 NYP. All rights reserved.
//

import UIKit
import MultiProgressView

@IBDesignable
class CustomProgressView: MultiProgressView {
    
    @IBInspectable var percentage: Int = 0 {
        didSet {
            percentageLabel.text = "\(percentage)%"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    private func initialize() {
        setUpLabels()
        lineCap = .round
    }
    
    private func setUpLabels() {
        addSubview(percentageLabel)
//        percentageLabel.leadingAnchor
        percentageLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
