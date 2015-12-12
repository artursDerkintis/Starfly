//
//  Extensions.swift
//  StarFlyer
//
//  Created by Neal on 03/09/14.
//  Copyright (c) 2014 Neal. All rights reserved.
//

import Foundation
import UIKit
import WebKit
public func lineWidth() -> CGFloat{
    if UIScreen.mainScreen().respondsToSelector("displayLinkWithTarget:selector:") && UIScreen.mainScreen().scale == 2.0{
        return 0.5
    }else{
        return 1
    }
    
}
public func randomString(len : Int) -> NSString {
    let s : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let mut : NSMutableString = NSMutableString(capacity: len)
    for var inde = 0; inde < len; ++inde {
        mut.appendFormat("%C", s.characterAtIndex(Int(arc4random_uniform(UInt32(s.length)))))
    }
    return mut.mutableCopy() as! NSString
}
public func degreesToRadians(degrees: Double) -> Double { return degrees * M_PI / 180.0 }
public func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

public func getRandomColor() -> UIColor{
    
    let randomRed:CGFloat = CGFloat(drand48())
    
    let randomGreen:CGFloat = CGFloat(drand48())
    
    let randomBlue:CGFloat = CGFloat(drand48())
    
    return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    
}
extension NSUserDefaults {
    
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = dataForKey(key) {
            color = NSKeyedUnarchiver.unarchiveObjectWithData(colorData) as? UIColor
        }
        return color
    }
    
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedDataWithRootObject(color)
        }
        setObject(colorData, forKey: key)
    }
    
}
extension String {
    public func indexOfCharacter(char: Character) -> Int? {
        if let idx = self.characters.indexOf(char) {
            return self.startIndex.distanceTo(idx)
        }
        return nil
    }
}

public func isLandscape() -> Bool{
    let orientation : UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
    if orientation == UIInterfaceOrientation.LandscapeRight
    {
        return true
    }else if orientation == UIInterfaceOrientation.LandscapeLeft {
        return true
    }else{
        return false
    }
    
}

extension WKWebView{
    func deleteMySelf(){
        loadRequest(NSURLRequest(URL: NSURL(string: "about:blank")!))
        evaluateJavaScript("stopAllVideos()", completionHandler: nil)
    }
}
extension UIImage {
    
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext() as CGContextRef!
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        color1.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    func imageWithColorMultiply(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext() as CGContextRef!
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, CGBlendMode.Multiply)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        color1.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func addGlowEffect() -> UIImage{
        var newSize : CGRect = CGRectMake(0, 0, self.size.width, self.size.height)
        let theImage : CGImageRef = self.CGImage!
        newSize.size.width += 16
        newSize.size.height += 16
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let ctx : CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextBeginTransparencyLayerWithRect(ctx, newSize, nil)
        CGContextClearRect(ctx, newSize);
        
        // you can repeat this process to build glow.
        CGContextDrawImage(ctx, newSize, theImage);
        CGContextSetAlpha(ctx, 0.000002);
        
        CGContextEndTransparencyLayer(ctx);
        
        var centerRect : CGRect = CGRectMake(0, 0, self.size.width, self.size.height)
        centerRect.origin.x += -3;
        centerRect.origin.y += -3;
        CGContextDrawImage(ctx, centerRect, theImage);
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio = targetSize.width / self.size.width
        let heightRatio = targetSize.height / self.size.height
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio, size.height * widthRatio)
        }
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    func isDarkImage() -> Bool{
        var isDark = false
        let imageData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
        let pixels = CFDataGetBytePtr(imageData)
        var darkPixels = 0
        let lenght = CFDataGetLength(imageData)
        let darkPixelThreshold : Int = Int((self.size.width * self.size.height) * 0.45)
        for var i = 0; i < lenght; i += 4{
            let r = 0.299 * Float(pixels[i])
            let g = 0.587 * Float(pixels[i+1])
            let b = 0.114 * Float(pixels[i+2])
            
            let luminance = r + g + b
            if luminance < 150{
                darkPixels++
            }
        }
        if darkPixels >= darkPixelThreshold{
            isDark = true
        }
        return isDark
    }
    func tintedWithLinearGradientColors(colorsArr: [CGColor!]) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        let context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        let rect = CGRectMake(0, 0, self.size.width, self.size.height)
        
        // Create gradient
        
        let colors = colorsArr as CFArray
        let space = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradientCreateWithColors(space, colors, nil)
        
        // Apply gradient
        
        CGContextClipToMask(context, rect, self.CGImage)
        CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, self.size.height), CGGradientDrawingOptions.DrawsAfterEndLocation)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return gradientImage
    }
}

extension UIView {
    
    func takeSnapshot(offset : CGFloat) -> UIImage? {
        var image  : UIImage = UIImage()
        let orientation : UIDeviceOrientation = UIDevice.currentDevice().orientation
        var heght : CGFloat = 0
        if orientation.isLandscape{
            heght = self.frame.height / 5 * 4.5
        }else if orientation.isPortrait{
            heght = self.frame.height / 5 * 2.5
        }
        
        let rect : CGRect = CGRectMake(0, 0, self.bounds.width, heght)
        
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
        self.drawViewHierarchyInRect(CGRectMake(0, 0, self.bounds.width, self.bounds.height), afterScreenUpdates: false)
        
        // old style: self.layer.renderInContext(UIGraphicsGetCurrentContext())
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        
        return image
    }
    func takeSnapshotForFavorites(offset : CGFloat) -> UIImage {
        var image  : UIImage?
        let orientation : UIDeviceOrientation = UIDevice.currentDevice().orientation
        var heght : CGFloat = 0
        if orientation.isLandscape{
            heght = self.frame.height / 5 * 4.5
        }else if orientation.isPortrait{
            heght = self.frame.height / 5 * 2.5
        }
        
        let rect : CGRect = CGRectMake(0, -offset, self.bounds.width, heght)
        
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.7)
        self.drawViewHierarchyInRect(CGRectMake(0, -offset, self.bounds.width, self.bounds.height), afterScreenUpdates: false)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        if let image = image{
            return image
        }else{
            return UIImage(named: "splash")!
        }
    }
    func takeSnapshotForHomePage() -> UIImage {
        var image  : UIImage = UIImage()
        let orientation : UIDeviceOrientation = UIDevice.currentDevice().orientation
        var heght : CGFloat = 0
        if orientation.isLandscape{
            heght = self.frame.height / 5 * 4
        }else if orientation.isPortrait{
            heght = self.frame.height / 5 * 3
        }
        
        let rect : CGRect = CGRectMake(0, 0, self.bounds.width, heght)
        
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.7)
        self.drawViewHierarchyInRect(CGRectMake(0,0, self.frame.width, self.frame.height), afterScreenUpdates: false)
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        
        return image
    }
    func takeShootOfTab() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 2.0)
        drawViewHierarchyInRect(bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    func frontColor(color : UIColor){
        
        
        self.backgroundColor = UIColor.whiteColor()
        
        var alreadyHaveColorSublayer : Bool = false
        if self.layer.sublayers != nil{
            for layer in self.layer.sublayers as [CALayer]!{
                
                if layer.name != nil{
                    if (layer.name == "color"){
                        let l = layer as! CAGradientLayer
                        alreadyHaveColorSublayer = true
                        l.frame = self.bounds
                        l.colors = [color.colorWithAlphaComponent(1).CGColor, color.colorWithAlphaComponent(1).CGColor, color.colorWithAlphaComponent(1).CGColor]
                        l.locations = [NSNumber(float: 0.1), NSNumber(float: 0.5), NSNumber(float: 0.9)]
                    }}
            }}
        if alreadyHaveColorSublayer == false{
            let frontColorLayer : CAGradientLayer = CAGradientLayer()
            frontColorLayer.name = "color"
            frontColorLayer.frame = self.bounds
            frontColorLayer.colors = [color.colorWithAlphaComponent(1).CGColor, color.colorWithAlphaComponent(1).CGColor, color.colorWithAlphaComponent(1).CGColor]
            frontColorLayer.locations = [NSNumber(float: 0.1), NSNumber(float: 0.5), NSNumber(float: 0.9)]
            self.layer.insertSublayer(frontColorLayer, atIndex: 0)
        }
    }
    func frontColore(color : UIColor, withBackgroundColor bcolor : UIColor){
        
        
        self.backgroundColor = UIColor.whiteColor()
        
        var alreadyHaveColorSublayer : Bool = false
        if self.layer.sublayers != nil{
            for layer in self.layer.sublayers as [CALayer]!{
                
                if layer.name != nil{
                    if (layer.name == "color"){
                        let l = layer as CALayer
                        alreadyHaveColorSublayer = true
                        l.frame = self.bounds
                        
                        l.backgroundColor = color.CGColor
                    }}
            }}
        if alreadyHaveColorSublayer == false{
            let frontColorLayer = CALayer()
            frontColorLayer.name = "color"
            frontColorLayer.frame = self.bounds
            frontColorLayer.backgroundColor  = color.CGColor
            self.layer.insertSublayer(frontColorLayer, atIndex: 0)
        }
    }
    
    
}

extension UIColor {
    
    
    class func colorWithSaturationFactor(factor: CGFloat, color: UIColor) -> UIColor {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        if color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue,
                saturation:saturation * factor,
                brightness: brightness,
                alpha: alpha)
        } else {
            return UIColor.blueColor()
        }
    }
    convenience init(rgba: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#") {
            let index   = rgba.startIndex.advancedBy(1)
            let hex : NSString    = rgba.substringFromIndex(index)
            let scanner = NSScanner(string: hex as String)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                if (hex.length == 6) {
                    red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF) / 255.0
                } else if hex.length == 8 {
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                } else {
                }
            } else {
                print("scan hex error")
            }
        } else {
            
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    class func darkerColorForColor(color: UIColor, rateDown : CGFloat) -> UIColor {
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        if color.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r - rateDown, 0.0), green: max(g - rateDown, 0.0), blue: max(b - rateDown, 0.0), alpha: a)
        }
        return UIColor()
    }
    
    func lighterColor(percent : Double) -> UIColor {
        return colorWithBrightnessFactor(CGFloat(1 + percent));
    }
    func colorWithBrightnessFactor(factor: CGFloat) -> UIColor {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
        } else {
            return self;
        }
    }
    
}

public func lighterColorForColor(color: UIColor, index : CGFloat) -> UIColor {
    
    var h:CGFloat = 0, s:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
    
    if color.getHue(&h, saturation: &s, brightness: &b, alpha: &a){
        return UIColor(hue: h, saturation: s, brightness: min(b + index, 1.0), alpha: a)
    }
    
    return UIColor()
}

public func parseUrl(input : NSString) -> String?{
    var string : String?
    let hasDot : Bool = input.rangeOfString(".").location != NSNotFound
    let hasSpace : Bool = input.rangeOfString(" ").location != NSNotFound
    let hasSheme : Bool = input.rangeOfString("://").location != NSNotFound
    if hasDot && !hasSpace {
        if !hasSheme  {
            return  String(format: "http://%@", input.urlEncode())
        }
        return input as String
        
    }
    
    string = input.urlEncode() as String
    
    return String(format: "https://www.google.com/search?q=%@", string!)
}
extension CGPoint{
    func distanceToPoint(point : CGPoint) -> CGFloat{
        let xDist = x - point.x
        let yDist = y - point.y
        return sqrt((xDist * xDist) + (yDist * yDist))
    }
}
extension UIViewController{
    
    func addSubviewSafe(subview : UIView?){
        if let v = subview{
            self.view.addSubview(v)
        }
    }
}
extension UIView{
    func addSubviewSafe(subview : UIView?){
        if let v = subview{
            self.addSubview(v)
        }
    }
    
}
extension NSString {
    func urlEncode() -> NSString {
        return CFURLCreateStringByAddingPercentEscapes(
            nil,
            self,
            nil,
            "!*'();:@&=+$,/?%#[]",
            CFStringBuiltInEncodings.UTF8.rawValue
        )
    }
}
extension UIView{
    
    func firstViewController() -> UIViewController?{
        return tranverseResponderChainForUIVc()  as? UIViewController
    }
    func tranverseResponderChainForUIVc() -> AnyObject?{
        if let res = self.nextResponder(){
            if res.isKindOfClass(UIViewController){
                return res
            }else if res.isKindOfClass(UIView){
                return (res as! UIView).tranverseResponderChainForUIVc()
            }
        }
        return nil
        
    }
    
    
}
public func shortURL(url : NSURL?) -> NSString{
    
    if url == nil{return ""}
    if url!.absoluteString.containsString("file:///var/"){return ""}
    var strinf = url!.absoluteString as NSString
    if strinf.containsString("http://") || strinf.containsString("https://"){
        let array : NSArray = strinf.componentsSeparatedByString("//")
        let newString : String = array.objectAtIndex(1) as! String
        let newArray  : NSArray = newString.componentsSeparatedByString("/")
        for string : String in newArray as! [String]{
            if string == newArray[0] as? NSString{
                strinf = string
            }else{
                
            }
            
        }}
    return strinf
}
