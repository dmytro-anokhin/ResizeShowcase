//
//  AspectFit.swift
//  AspectFit
//
//  Created by Dmytro Anokhin on 13/08/2021.
//

import CoreGraphics


/// Resize given rect to aspect fit target.
///
/// - Parameters:
///     - rect: The rect to resize.
///     - target: Target rect to fit and align with.
///
/// - Returns:
///     New rectangle that fits target size, preserving original aspect ratio, and center aligned with target.
///
func aspectFit(rect original: CGRect, in target: CGRect) -> CGRect {
    var rect = original
    rect.size = aspectFit(original: rect.size, target: target.size)
    return centerAlign(rect: rect, with: target)
}

/// Resize to fit target.
///
/// - Parameters:
///     - original: Original size used to calculate aspect ratio.
///     - target: Target size to fit.
///
/// - Returns:
///     Largest size, not exceding target, and preserving original aspect ratio.
///
func aspectFit(original: CGSize, target: CGSize) -> CGSize {
    guard isCalculable(original), isCalculable(target) else {
        return .zero
    }

    var result: CGSize = .zero

    if original.width > original.height {
        // Original is landscape
        let aspectRatio = original.height / original.width
        let targetRatio = target.height / target.width

        if aspectRatio > targetRatio {
            result = CGSize(width: target.height / aspectRatio, height: target.height)
        } else {
            result = CGSize(width: target.width, height: target.width * aspectRatio)
        }
    } else {
        // Original is portrait (or square)
        let aspectRatio = original.width / original.height
        let targetRatio = target.width / target.height

        if aspectRatio > targetRatio {
            result = CGSize(width: target.width, height: target.width / aspectRatio)
        } else {
            result = CGSize(width: target.height * aspectRatio, height: target.height)
        }
    }

    return result
}

/// Center align rect and target.
func centerAlign(rect: CGRect, with target: CGRect) -> CGRect {
    var result = rect

    result.origin = CGPoint(x: target.minX + (target.width - rect.width) * 0.5,
                            y: target.minY + (target.height - rect.height) * 0.5)

    return result
}
