//
//  TimCalendarCell.swift
//  TimCharge
//
//  Created by nice on 2018/12/28.
//  Copyright © 2018 Tim. All rights reserved.
//

import UIKit

class TimCalendarCell: UICollectionViewCell {
    
    lazy var dateLabel: UILabel = self.getDateLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        
        self.contentView.layer.cornerRadius = TimCalendarConfig.share.itemW / 2.0
        
        self.contentView.addSubview(self.dateLabel)
        self.dateLabel.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self.contentView)
        }
        
    }
    
    
    func getDateLabel() -> UILabel {
        
        let dateLabel = UILabel.init()
        dateLabel.textAlignment = .center
        return dateLabel
    }
    
}
