//
//  NewGoalCollectionViewCell.swift
//  BeeSwift
//
//  Created by Andy Brett on 11/25/16.
//  Copyright © 2016 APB. All rights reserved.
//

import UIKit

class NewGoalCollectionViewCell: UICollectionViewCell {
    
    var newGoalButton = BSButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.newGoalButton)
        self.newGoalButton.addTarget(self, action: #selector(NewGoalCollectionViewCell.newGoalButtonPressed), for: .touchUpInside)
        self.newGoalButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(25)
            make.width.equalTo(self.contentView).multipliedBy(0.75)
            make.centerX.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView).offset(-25)
        }
        self.newGoalButton.setTitle("Create Goal", for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func newGoalButtonPressed() {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "createGoalButtonPressed")))
    }
    
}
