//
//  ScaledHeightImageView.swift
//
//  https://gist.github.com/marcc-orange/e309d86275e301466d1eecc8e400ad00
//

import UIKit

/// An image view that computes its intrinsic height from its width while preserving aspect ratio
/// Source: https://stackoverflow.com/a/48476446
class ScaledHeightImageView: UIImageView {
    
    // Track the width that the intrinsic size was computed for,
    // to invalidate the intrinsic size when needed
    private var layoutedWidth: CGFloat = 0

    override var intrinsicContentSize: CGSize {
        layoutedWidth = bounds.width
        if let image = self.image {
            let viewWidth = bounds.width
            let ratio = viewWidth / image.size.width
            return CGSize(width: viewWidth, height: image.size.height * ratio)
        }
        return super.intrinsicContentSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if layoutedWidth != bounds.width {
            invalidateIntrinsicContentSize()
        }
    }
}
