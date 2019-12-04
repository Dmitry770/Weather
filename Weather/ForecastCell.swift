//
//  ForecastCell.swift
//  Weather
//
//  Created by Macintosh on 02/12/2019.
//  Copyright © 2019 Macintosh. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell {
    
    @IBOutlet weak var forecastDay: UILabel!
    
    @IBOutlet weak var forecastTemp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(temp: Double, day: String) {
        self.forecastDay.text = day
        self.forecastTemp.text = "\(temp)"
        
    }

}
