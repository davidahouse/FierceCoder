//
//  FierceEncodeable.swift
//  FierceCoder
//
//  Created by David House on 7/24/15.
//  Copyright © 2015 David House. All rights reserved.
//

import Foundation

public protocol FierceEncodeable {
    func encode(encoder:FierceEncoder)
    init(decoder:FierceDecoder)
}