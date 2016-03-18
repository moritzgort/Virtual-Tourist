//
//  ImageLoadDelegate.swift
//  Virtual Tourist Udacity
//
//  Created by Moritz Gort on 16/03/16.
//  Copyright © 2016 Gabriele Gort. All rights reserved.
//

import Foundation
import QuartzCore

protocol ImageLoadDelegate {
    
    func progress(progress: CGFloat)
    
    func didFinishLoad()
}