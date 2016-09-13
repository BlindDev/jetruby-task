//
//  StyleKit.swift
//  DribbbleClient
//
//  Created by PavelPopov on 14.09.16.
//  Copyright (c) 2016 ru.youreconomicapps. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//



import UIKit

public class StyleKit : NSObject {

    //// Cache

    private struct Cache {
        static let pinkColor: UIColor = UIColor(red: 1.000, green: 0.090, blue: 0.510, alpha: 1.000)
        static let charcoalColor: UIColor = UIColor(red: 0.200, green: 0.200, blue: 0.200, alpha: 1.000)
        static let linkBlueColor: UIColor = UIColor(red: 0.067, green: 0.541, blue: 0.745, alpha: 1.000)
        static let proColor: UIColor = UIColor(red: 0.157, green: 0.820, blue: 0.812, alpha: 1.000)
        static let jobsHiringColor: UIColor = UIColor(red: 0.353, green: 0.765, blue: 0.369, alpha: 1.000)
        static let teamsColor: UIColor = UIColor(red: 0.000, green: 0.718, blue: 0.906, alpha: 1.000)
        static let playbookColor: UIColor = UIColor(red: 0.043, green: 0.831, blue: 0.608, alpha: 1.000)
        static let slateColor: UIColor = UIColor(red: 0.612, green: 0.639, blue: 0.647, alpha: 1.000)
        static let noFill: UIColor = UIColor(red: 0.800, green: 0.320, blue: 0.320, alpha: 0.000)
    }

    //// Colors

    public class var pinkColor: UIColor { return Cache.pinkColor }
    public class var charcoalColor: UIColor { return Cache.charcoalColor }
    public class var linkBlueColor: UIColor { return Cache.linkBlueColor }
    public class var proColor: UIColor { return Cache.proColor }
    public class var jobsHiringColor: UIColor { return Cache.jobsHiringColor }
    public class var teamsColor: UIColor { return Cache.teamsColor }
    public class var playbookColor: UIColor { return Cache.playbookColor }
    public class var slateColor: UIColor { return Cache.slateColor }
    public class var noFill: UIColor { return Cache.noFill }

    //// Drawing Methods

    public class func drawLoginButton(buttonFrame buttonFrame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 30)) {

        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: buttonFrame, cornerRadius: 5)
        StyleKit.pinkColor.setFill()
        rectanglePath.fill()
    }

    public class func drawLikeButtonHeartSymbol(shotLiked shotLiked: Bool = true) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()


        //// Shadow Declarations
        let shadow = NSShadow()
        shadow.shadowColor = StyleKit.charcoalColor
        shadow.shadowOffset = CGSize(width: 0.1, height: -0.1)
        shadow.shadowBlurRadius = 8

        //// Variable Declarations
        let expression = shotLiked ? StyleKit.pinkColor : StyleKit.noFill

        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: 49, y: 13))
        bezierPath.addCurveToPoint(CGPoint(x: 38, y: 19.39), controlPoint1: CGPoint(x: 44.5, y: 13), controlPoint2: CGPoint(x: 40.5, y: 15.5))
        bezierPath.addCurveToPoint(CGPoint(x: 27, y: 13), controlPoint1: CGPoint(x: 35.5, y: 15.5), controlPoint2: CGPoint(x: 31.5, y: 13))
        bezierPath.addCurveToPoint(CGPoint(x: 13, y: 28.56), controlPoint1: CGPoint(x: 19.25, y: 13), controlPoint2: CGPoint(x: 13, y: 19.94))
        bezierPath.addCurveToPoint(CGPoint(x: 38, y: 63), controlPoint1: CGPoint(x: 13, y: 40.78), controlPoint2: CGPoint(x: 38, y: 63))
        bezierPath.addCurveToPoint(CGPoint(x: 63, y: 28.56), controlPoint1: CGPoint(x: 38, y: 63), controlPoint2: CGPoint(x: 63, y: 40.78))
        bezierPath.addCurveToPoint(CGPoint(x: 49, y: 13), controlPoint1: CGPoint(x: 63, y: 19.94), controlPoint2: CGPoint(x: 56.75, y: 13))
        bezierPath.closePath()
        bezierPath.miterLimit = 4;

        CGContextSaveGState(context)
        CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, (shadow.shadowColor as! UIColor).CGColor)
        expression.setFill()
        bezierPath.fill()
        CGContextRestoreGState(context)

        StyleKit.pinkColor.setStroke()
        bezierPath.lineWidth = 2.5
        bezierPath.stroke()
    }

    public class func drawLikeButtonHeart(heartFrame heartFrame: CGRect = CGRect(x: 0, y: 0, width: 40, height: 40), shotLiked: Bool = true) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// Symbol Drawing
        let symbolRect = CGRect(x: heartFrame.origin.x, y: heartFrame.origin.y, width: heartFrame.size.width, height: heartFrame.size.height)
        CGContextSaveGState(context)
        UIRectClip(symbolRect)
        CGContextTranslateCTM(context, symbolRect.origin.x, symbolRect.origin.y)
        CGContextScaleCTM(context, symbolRect.size.width / 76, symbolRect.size.height / 76)

        StyleKit.drawLikeButtonHeartSymbol(shotLiked: shotLiked)
        CGContextRestoreGState(context)
    }

}
