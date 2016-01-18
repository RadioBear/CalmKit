//
//  BRBAngularGradientLayer.swift
//  BRBAngularGradientLayer
//
// Copyright (c) 2016 RadioBear
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

import UIKit

class BRBAngularGradientLayer: CALayer {
    typealias Byte = UInt8
    typealias ColorUnit = UInt32
    
    var colors: [CGColor]?
    var locations: [Float]?
    var path: CGPath?
    var lineWidth: CGFloat = 1.0
    var lineCap: CGLineCap = CGLineCap.Butt
    var lineJoin: CGLineJoin = CGLineJoin.Miter
    var miterLimit: CGFloat = 10.0
    
    override init() {
        super.init()
        self.needsDisplayOnBoundsChange = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.needsDisplayOnBoundsChange = true
    }
    
    
    override func drawInContext(ctx: CGContext) {
        
        let usePath = (path != nil)
        
        if usePath {
            // Copy the path of the shape and turn it into a stroke.
            let shapeCopyPath = CGPathCreateCopyByStrokingPath(path!, nil, lineWidth, lineCap, lineJoin, miterLimit)
            CGContextSaveGState(ctx)
            
            // Add the stroked path to the context and clip to it.
            CGContextAddPath(ctx, shapeCopyPath)
            CGContextClip(ctx)
        }
        
        CGContextSetFillColorWithColor(ctx, self.backgroundColor)
        let rect = CGContextGetClipBoundingBox(ctx)
        CGContextFillRect(ctx, rect)
        
        let img = self.createImageGradient(inRect: rect)
        CGContextDrawImage(ctx, rect, img)
        
        if usePath {
            CGContextRestoreGState(ctx)
        }
    }
    
    
    func createImageGradient(inRect rect : CGRect) -> CGImage! {
        return self.dynamicType.createImageGradient(inRect: rect, colors: self.colors, locations: self.locations)
    }
    
    @inline(__always)
    private class func p_redFrom(colorUnit : ColorUnit) -> Byte {
        return Byte((colorUnit >> 24) & ColorUnit(0xFF))
    }
    
    @inline(__always)
    private class func p_greenFrom(colorUnit : ColorUnit) -> Byte {
        return Byte((colorUnit >> 16) & ColorUnit(0xFF))
    }
    
    @inline(__always)
    private class func p_blueFrom(colorUnit : ColorUnit) -> Byte {
        return Byte((colorUnit >> 8) & ColorUnit(0xFF))
    }
    
    @inline(__always)
    private class func p_alphaFrom(colorUnit : ColorUnit) -> Byte {
        return Byte(colorUnit & ColorUnit(0xFF))
    }
    
    @inline(__always)
    private class func p_colorByteFrom(floatValue : CGFloat) -> Byte {
        return Byte(floatValue * 255.0) & 0xFF
    }
    
    @inline(__always)
    private class func p_colorUnitFrom(red r: Byte, green g: Byte, blue b: Byte, alpha a: Byte) -> ColorUnit {
        return (ColorUnit(r) << 24) | (ColorUnit(g) << 16) | (ColorUnit(b) << 8) | ColorUnit(a)
    }
    
    @inline(__always)
    private class func p_colorUnitFrom(red r: CGFloat, green g: CGFloat, blue b: CGFloat, alpha a: CGFloat) -> ColorUnit {
        return p_colorUnitFrom(red: p_colorByteFrom(r), green: p_colorByteFrom(g), blue: p_colorByteFrom(b), alpha: p_colorByteFrom(a))
    }
    
    @inline(__always)
    private class func p_byteLerp(from a: Byte, to b: Byte, withRate rate: Float) -> Byte {
        return Byte(Float(a) + (rate * (Float(b) - Float(a))))
    }
    
    @inline(__always)
    private class func p_colorUnitLerp(from a: ColorUnit, to b: ColorUnit, withRate rate: Float) -> ColorUnit {
        return p_colorUnitFrom(
            red: p_byteLerp(from: p_redFrom(a), to: p_redFrom(b), withRate: rate),
            green: p_byteLerp(from: p_greenFrom(a), to: p_greenFrom(b), withRate: rate),
            blue: p_byteLerp(from: p_blueFrom(a), to: p_blueFrom(b), withRate: rate),
            alpha: p_byteLerp(from: p_alphaFrom(a), to: p_alphaFrom(b), withRate: rate)
        )
    }
    
    @inline(__always)
    private class func p_colorUnitMultiplyByAlpha(c : ColorUnit) -> ColorUnit {
        let alphaByte = p_alphaFrom(c)
        if alphaByte == Byte.max {
            return c
        }
        let a: CGFloat = CGFloat(alphaByte) / 255.0
        return p_colorUnitFrom(
            red: Byte(CGFloat(p_redFrom(c)) * a),
            green: Byte(CGFloat(p_greenFrom(c)) * a),
            blue: Byte(CGFloat(p_blueFrom(c)) * a),
            alpha: alphaByte
        )
    }
    
    private class func p_colorUnitFrom(CGColor color : CGColor) -> ColorUnit {
        let colorSpace = CGColorGetColorSpace(color)
        let colorSpaceModel = CGColorSpaceGetModel(colorSpace)
        let colorComponents = CGColorGetComponents(color)
        let colorComponentCount = CGColorGetNumberOfComponents(color)
        
        switch colorSpaceModel {
        case .RGB:
            assert(colorComponentCount == 4)
            return p_colorUnitFrom(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], alpha: colorComponents[3])
        case .Monochrome:
            assert(colorComponentCount == 2)
            return p_colorUnitFrom(red: colorComponents[0], green: colorComponents[0], blue: colorComponents[0], alpha: colorComponents[1])
        default:
            print("<error> Unsupported color space model: \(colorSpaceModel)")
            return 0
        }
    }
    
    
    private class func p_createAngularGradient(toData data: UnsafeMutableBufferPointer<ColorUnit>, width : Int, height : Int, colors: [ColorUnit]!, locations: [Float]!) {
        
        let colorCount = (colors?.count) ?? 0
        let locationCount = (locations?.count) ?? 0
        if colorCount < 1 {
            return ;
        }
        if locationCount > 0 && locationCount != colorCount {
            return ;
        }
        
        let centerX: Float = Float(width) * 0.5
        let centerY: Float = Float(height) * 0.5
        let circleRadius: Float = 2 * Float(M_PI)
        
        var dataPtr = data.baseAddress
        for y in 0..<height {
            for x in 0..<width {
                let dirX: Float = Float(x) - centerX
                let dirY: Float = Float(y) - centerY
                var angle: Float = atan2f(dirY, dirX)
                if dirY < 0.0 {
                    angle += circleRadius
                }
                angle /= circleRadius
                
                var index: Int = 0, nextIndex: Int = 0, rate: Float = 0.0
                
                if locationCount > 0 {
                    for index = locationCount - 1; index >= 0; --index {
                        if angle >= locations[index] {
                            break
                        }
                    }
                    if index < 0 {
                        index = 0
                    }
                    if index >= locationCount {
                        index = locationCount - 1
                    }
                    nextIndex = index + 1
                    if nextIndex >= locationCount {
                        nextIndex = locationCount - 1
                    }
                    let locationDelta = locations[nextIndex] - locations[index]
                    rate = (locationDelta <= 0) ? 0 : (angle - locations[index]) / locationDelta
                } else {
                    rate = angle * Float(colorCount - 1)
                    index = Int(rate)
                    rate -= Float(index)
                    nextIndex = index + 1
                    if nextIndex >= colorCount {
                        nextIndex = colorCount - 1
                    }
                }
                
                let lc = colors[index]
                let rc = colors[nextIndex]
                let color = p_colorUnitLerp(from: lc, to: rc, withRate: rate)
                dataPtr.memory = p_colorUnitMultiplyByAlpha(color)
                dataPtr = dataPtr.successor()
            }
        }
    }
  
    class func createImageGradient(inRect rect : CGRect, colors: [CGColor]!, locations: [Float]!) -> CGImage! {
  
        let width: Int = Int(rect.width)
        let height: Int = Int(rect.height)
        let bitsPerComponent = 8
        let bpp = 4
        let pixelCount = width * height
        
        let colorUnits: [ColorUnit]!
        let colorCount = (colors?.count) ?? 0
        if colorCount > 0 {
            colorUnits = [ColorUnit](count: colorCount, repeatedValue: 0)
            for (index, color) in colors.enumerate() {
                colorUnits[index] = p_colorUnitFrom(CGColor: color)
            }
        } else {
            colorUnits = nil
        }
        
        let data = UnsafeMutablePointer<ColorUnit>.alloc(pixelCount)
        let dataBuffer = UnsafeMutableBufferPointer<ColorUnit>(start: data, count: pixelCount)
        p_createAngularGradient(toData: dataBuffer, width: width, height: height, colors: colorUnits, locations: locations)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue | CGBitmapInfo.ByteOrder32Little.rawValue)
        let ctx = CGBitmapContextCreate(data, width, height, bitsPerComponent, width * bpp, colorSpace, bitmapInfo.rawValue)
        let img = CGBitmapContextCreateImage(ctx)
        data.destroy()
        data.dealloc(colorCount)
        
        return img
    }
    
}
