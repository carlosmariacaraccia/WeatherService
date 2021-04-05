//
//  CurrrentWeatherCell.swift
//  Weather Service
//
//  Created by Carlos Caraccia on 4/5/21.
//

import UIKit


class CurrentWeatherCell:UICollectionViewCell {
    
    lazy var cityLabel:UILabel = {
        let label = UILabel()
        label.text = "Clarin Miente"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cityLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
