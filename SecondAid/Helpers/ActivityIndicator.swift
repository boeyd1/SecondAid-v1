//
//  ActivityIndicator.swift
//  SecondAid
//
//  Created by Desmond Boey on 27/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicator {
    static let actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
    
    
    static func startAnimating(view: UIView){
        actInd.center = view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(actInd)
        actInd.startAnimating()
    }
    
    static func stopAnimating(view: UIView){
        actInd.stopAnimating()
        view.willRemoveSubview(actInd)
    }
    
}