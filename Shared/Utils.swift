//
//  Utils.swift
//  Utils
//
//  Created by Dmytro Anokhin on 13/08/2021.
//

import CoreGraphics


func isCalculable(_ size: CGSize) -> Bool {
    return size.width > 0.0
        && size.height > 0.0
        && size.width < CGFloat.greatestFiniteMagnitude
        && size.height < CGFloat.greatestFiniteMagnitude
}

func isCalculable(_ point: CGPoint) -> Bool {
    return point.x > CGFloat.leastNormalMagnitude
        && point.y > CGFloat.leastNormalMagnitude
        && point.x < CGFloat.greatestFiniteMagnitude
        && point.y < CGFloat.greatestFiniteMagnitude
}

func isCalculable(_ rect: CGRect) -> Bool {
    isCalculable(rect.origin) && isCalculable(rect.size)
}
