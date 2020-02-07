//
//  EmbossButton.swift
//  PlayingWithUI
//
//  Created by morse on 1/29/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit

@IBDesignable
class EmbossButton: UIButton {
    
//    let gradientLayer = CAGradientLayer()
    
//    func setGradient() {
//        gradientLayer.colors = [UIColor.systemOrange.cgColor, UIColor.systemPink.cgColor]
//        layer.insertSublayer(gradientLayer, at: 0)
//    }
    
    // System Color: #191919
    
    @IBInspectable
    var buttonCornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    static let colorDepth: CGFloat = 0.1
    static let highlightDepth: CGFloat = 0.16//0.9
    static let shadowDepth: CGFloat = 0.06
    
    
    
    //// Color Declarations
    static var highlightColor = UIColor(red: highlightDepth, green: highlightDepth, blue: highlightDepth, alpha: 1.00) //For .gray, rgb were all 1.000, alpha: 0.201
    static var shadowColor = UIColor(red: shadowDepth, green: shadowDepth, blue: shadowDepth, alpha: 1) //For .gray, rgb were all 0.333, alpha: 0.423
    var rectColor = UIColor(red: colorDepth, green: colorDepth, blue: colorDepth, alpha: 1.0)
    
    func tapped(_ isTapped: Bool) {
        
        if isTapped {
            
            let tempColor = EmbossButton.highlightColor
            EmbossButton.highlightColor = EmbossButton.shadowColor.withAlphaComponent(1.0)
            EmbossButton.shadowColor = tempColor
        } else {
            let tempColor = EmbossButton.highlightColor.withAlphaComponent(0.6)
            EmbossButton.highlightColor = EmbossButton.shadowColor
            EmbossButton.shadowColor = tempColor
        }
        
        setNeedsDisplay()
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    
    override func draw(_ rect: CGRect) {
        
        if let context = UIGraphicsGetCurrentContext() {
//            print("hi")
//            self.heightAnchor.constraint(equalToConstant: intrinsicContentSize.height + 100).isActive = true
//            self.widthAnchor.constraint(equalToConstant: intrinsicContentSize.width + 100).isActive = true
            
            //// Shadow Declarations
            let buttonShadow = NSShadow()
            buttonShadow.shadowColor = EmbossButton.shadowColor
            buttonShadow.shadowOffset = CGSize(width: 3, height: -3)
            buttonShadow.shadowBlurRadius = abs(buttonShadow.shadowOffset.width) + 3
            let buttonHighlight = NSShadow()
            buttonHighlight.shadowColor = EmbossButton.highlightColor
            buttonHighlight.shadowOffset = CGSize(width: -3, height: 3)
            buttonHighlight.shadowBlurRadius = abs(buttonHighlight.shadowOffset.width) + 3
            
            //// Rectangle Drawing
//            let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 100, y: 300, width: 300, height: 200), cornerRadius: 4)
//            rectColor.setFill()
//            rectanglePath.fill()
            
            
            //// Rectangle 2 Drawing
            
//            let contentSize = CGSize(width: self.widthAnchor.s, height: <#T##CGFloat#>)
            let buttonPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0
                , width: rect.width, height: rect.height), cornerRadius: self.buttonCornerRadius)
            context.saveGState()
//            context.setShadow(offset: buttonHighlight.shadowOffset, blur: buttonHighlight.shadowBlurRadius, color: (buttonHighlight.shadowColor as! UIColor).cgColor)
            rectColor.setFill()
            buttonPath.fill()
            
            
            // Inner Shadow
            context.saveGState()
            context.clip(to: buttonPath.bounds)
            context.setShadow(offset: CGSize.zero, blur: 0)
            context.setAlpha((buttonShadow.shadowColor as! UIColor).cgColor.alpha)
            context.beginTransparencyLayer(auxiliaryInfo: nil)
            let buttonOpaqueShadow = (buttonShadow.shadowColor as! UIColor).withAlphaComponent(1)
            context.setShadow(offset: buttonShadow.shadowOffset, blur: buttonShadow.shadowBlurRadius, color: buttonOpaqueShadow.cgColor)
            context.setBlendMode(.sourceOut)
            context.beginTransparencyLayer(auxiliaryInfo: nil)
            
            buttonOpaqueShadow.setFill()
            buttonPath.fill()
            
            context.endTransparencyLayer()
            context.endTransparencyLayer()
            context.restoreGState()
            
            context.restoreGState()
            
            // Inner Highlight
            context.saveGState()
            context.clip(to: buttonPath.bounds)
            context.setShadow(offset: CGSize.zero, blur: 0)
            context.setAlpha((buttonHighlight.shadowColor as! UIColor).cgColor.alpha)
            context.beginTransparencyLayer(auxiliaryInfo: nil)
            let buttonOpaqueHighlight = (buttonHighlight.shadowColor as! UIColor).withAlphaComponent(1)
            context.setShadow(offset: buttonHighlight.shadowOffset, blur: buttonHighlight.shadowBlurRadius, color: buttonOpaqueHighlight.cgColor)
            context.setBlendMode(.sourceOut)
            context.beginTransparencyLayer(auxiliaryInfo: nil)
            
            buttonOpaqueHighlight.setFill()
            buttonPath.fill()
            
            context.endTransparencyLayer()
            context.endTransparencyLayer()
            context.restoreGState()
            
            context.restoreGState()
            
        }
    }
}


extension EmbossButton {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
//        UINotificationFeedbackGenerator().notificationOccurred(.success)
        tapped(false)
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        tapped(true)
    }
}
