//
//  UseableItem.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/17/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation

protocol UsableItem: Item {
    var hasUsed: Bool { get set }
}