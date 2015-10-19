//
//  Array+Random.swift
//  SwiftDungeon
//
//  Created by Sam Green on 10/18/15.
//  Copyright © 2015 Sam Green. All rights reserved.
//

import Foundation

extension Array {
    func randomElement() -> Element {
        let randomIndex = Int(arc4random_uniform(UInt32(count)))
        return self[randomIndex]
    }
}