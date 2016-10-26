//
//  alertTableViewCell.swift
//  SecondAid
//
//  Created by Desmond Boey on 14/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

class alertTableViewCell: UITableViewCell {

    @IBOutlet weak var numOfResponders: UILabel!
    @IBOutlet weak var timeElapsed: UILabel!
    @IBOutlet weak var alertDescription: UILabel!
   
    weak var delegate : AlertTableViewCellDelegate?
    
    var createdTime : NSDate?
    
    var timer = NSTimer()
    
    var alert : Alerts? {
        didSet {
            if let alert = alert{
                
                ParseHelper.getNumOfResponders (alert){ (result: Int32, error: NSError?) in
                    if let error = error {
                        ErrorHandling.defaultErrorHandler(error)
                    }
                    self.numOfResponders.text = String(Int(result))
                }
                
                alertDescription.text = alert.alertDescription
                
                timer = NSTimer.scheduledTimerWithTimeInterval (2.0, target: self, selector: #selector(alertTableViewCell.timeTick), userInfo: nil, repeats: true)
                
                timer.tolerance = 1.0
                
                createdTime = alert.createdAt!
                
            }
        }
    }
    
    func timeTick(){
        let timeNow = NSDate()
        let minPassed = Int(timeNow.timeIntervalSinceDate(createdTime!)/60)
        
        let secPassed = Int(timeNow.timeIntervalSinceDate(createdTime!)%60)
        
        if secPassed > 10 {
        timeElapsed.text = "\(minPassed)m \(secPassed)s"
        }else{
            timeElapsed.text = "\(minPassed)m 0\(secPassed)s"
        }
        
        if minPassed > 9 && secPassed > 15 {
            timer.invalidate()
            self.delegate?.reloadMapAndTableView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

protocol AlertTableViewCellDelegate: class {
    func reloadMapAndTableView()
}
