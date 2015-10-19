//
//  Drawable.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/18/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation
import UIKit

protocol Drawable {
    var imageName: String { get }
    var imageColor: UIColor { get }
}