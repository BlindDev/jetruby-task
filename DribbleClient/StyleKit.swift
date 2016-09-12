//
//  StyleKit.swift
//  DribbbleClient
//
//  Created by PavelPopov on 11.09.16.
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

    //// Drawing Methods

    public class func drawLoginButtonSymbol(buttonFrame buttonFrame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 30)) {

        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: buttonFrame, cornerRadius: 5)
        StyleKit.pinkColor.setFill()
        rectanglePath.fill()
    }

}