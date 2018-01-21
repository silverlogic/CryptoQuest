//
//  SCNVector3+Extension.swift
//  CryptoQuest
//
//  Created by Vasilii Muravev on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import ARKit
import SceneKit
import UIKit

// MARK: - SCNVector3 Extension
enum PointType {
    case horizontal
    case vertical
}

extension SCNVector3 {
    func length() -> Float {
        return sqrtf(x * x + y * y + z * z)
    }
    
    func normalized() -> SCNVector3 {
        let length = self.length()
        return SCNVector3(x / length, y / length, z / length)
    }
    
    func distanceFromVector(_ vector: SCNVector3) -> Float {
        return (self - vector).length()
    }
    
    func flatPoint(_ type: PointType = .horizontal) -> CGPoint {
        switch type {
        case .horizontal:
            return CGPoint(x: CGFloat(x), y: CGFloat(z))
        case .vertical:
            return CGPoint(x: CGFloat(x), y: CGFloat(y))
        }
    }
    
    func forceVector(to target: SCNVector3, by time: Float, with gravity: SCNVector3) -> SCNVector3 {
        guard time > 0 else {
            return SCNVector3Zero
        }
        var vector = target - self
        let y = vector.y
        vector.y = 0
        let xz = vector.length()
        let v0y = y / time + 0.3 * gravity.length() * time
        let v0xz = xz / time
        var result = vector.normalized() * v0xz
        result.y = v0y
        return result
    }
}


// MARK: - Operator Overloads
func - (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
}

func + (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
}

func * (lhs: SCNVector3, rhs: Float) -> SCNVector3 {
    return SCNVector3Make(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs)
}

func == (lhs: SCNVector3, rhs: SCNVector3) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

func != (lhs: SCNVector3, rhs: SCNVector3) -> Bool {
    return !(lhs == rhs)
}


// MARK: - CGPoint Extension
extension CGPoint {
    init(_ vector: SCNVector3) {
        x = CGFloat(vector.x)
        y = CGFloat(vector.y)
    }
    
    func normalized(for size: CGSize) -> CGPoint {
        if size.width == 0 || size.height == 0 {
            return CGPoint.zero
        }
        return CGPoint(x: x / size.width, y: y / size.height)
    }
    
    func length() -> CGFloat {
        return sqrt(x * x + y * y)
    }
    
    func angle() -> CGFloat {
        guard x != 0 else { return 0.0 }
        let angle = atan(y / x)
        return CGFloat.pi * (x > 0 ? 0.5 : 1.5) - angle
    }
}


// MARK: - Operator Overloads
func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}

func -= (left: inout CGPoint, right: CGPoint) {
    left = left - right
}

func / (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x / right, y: left.y / right)
}

func * (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x * right, y: left.y * right)
}

func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

func /= (left: inout CGPoint, right: CGFloat) {
    left = left / right
}

func *= (left: inout CGPoint, right: CGFloat) {
    left = left * right
}


// MARK: - SCNNode
extension SCNNode {
    func look(at pointOfView: SCNNode, offset: SCNVector3?) {
        let constraint = SCNLookAtConstraint(target: pointOfView)
        constraint.isGimbalLockEnabled = true
        if let offset = offset {
            constraint.targetOffset = offset
        }
        constraints = [constraint]
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak constraint] in
            constraint?.influenceFactor = 0.03
        }
    }
    
    func parentOfType<T: SCNNode>() -> T? {
        var node: SCNNode! = self
        repeat {
            if let node = node as? T { return node }
            node = node?.parent
        } while node != nil
        return nil
    }
    
    func performAction(_ independent: Bool = false) {
        var node: SCNNode! = self
        repeat {
            if let actionNode = node as? ActionNodeProtocol,
                let action = actionNode.action {
                action(node)
                if !independent { break }
            }
            node = node?.parent
        } while node != nil
    }
    
    func applyRandomForce(with magnitude: UInt32) {
        let randomX = Float(arc4random_uniform(magnitude)) - Float(magnitude) / 2
        let randomY = Float(arc4random_uniform(magnitude)) - Float(magnitude) / 2
        let randomZ = Float(arc4random_uniform(magnitude)) - Float(magnitude) / 2
        let forceVector = SCNVector3(randomX, randomY, randomZ)
        physicsBody?.clearAllForces()
        physicsBody?.applyForce(forceVector, asImpulse: true)
    }
}


// MARK: - UIColor
extension UIColor {
    static func colorFromHexValue(_ hexValue: UInt, alpha: CGFloat = 1.0) -> UIColor {
        let redValue = ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0
        let greenValue = ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0
        let blueValue = ((CGFloat)(hexValue & 0xFF)) / 255.0
        return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alpha)
    }
    
    @nonobjc static var darkOrangeHexValue: UInt = 0xF05223
    @nonobjc static var limeGreenHexValue: UInt = 0xC0CB33
    @nonobjc static var bitcoinOrangeHexValue: UInt = 0xF7931A
    
    static var darkOrange: UIColor { return colorFromHexValue(darkOrangeHexValue) }
    static var lineGreen: UIColor { return colorFromHexValue(limeGreenHexValue) }
    static var bitcoinOrange: UIColor { return colorFromHexValue(bitcoinOrangeHexValue) }
}


// MARK: - SCNMaterial
extension SCNMaterial {
    
    // MARK: - Initializers
    convenience init(color: UIColor, specularColor: UIColor? = .white) {
        self.init()
        diffuse.contents = color
        specular.contents = specularColor
    }
    
    convenience init(image: UIImage, specularColor: UIColor? = .white) {
        self.init()
        diffuse.contents = image
        specular.contents = specularColor
    }
    
    static func invertedByX(image: UIImage) -> SCNMaterial {
        let material = SCNMaterial(image: image)
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(-1.0, 1.0, 1.0)
        material.diffuse.wrapT = .repeat
        material.diffuse.wrapS = .repeat
        return material
    }

    static func invertedByY(image: UIImage) -> SCNMaterial {
        let material = SCNMaterial(image: image)
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(1.0, -1.0, 1.0)
        material.diffuse.wrapT = .repeat
        material.diffuse.wrapS = .repeat
        return material
    }
    
    static func invertedByZ(image: UIImage) -> SCNMaterial {
        let material = SCNMaterial(image: image)
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(1.0, 1.0, -1.0)
        material.diffuse.wrapT = .repeat
        material.diffuse.wrapS = .repeat
        return material
    }
}


// MARK: - matrix_float4x4
extension matrix_float4x4 {
    func position() -> SCNVector3 {
        return SCNVector3(columns.3.x, columns.3.y, columns.3.z)
    }
}


// MARK: - ARFrame
extension ARFrame {
    func featurePoint(for normalizedPoint: CGPoint) -> matrix_float4x4? {
        let x = normalizedPoint.x
        let y = normalizedPoint.y
        if x < 0.0 || x > 1.0 || y < 0.0 || y > 1.0 {
            return nil
        }
        guard let testResult = hitTest(normalizedPoint, types: .featurePoint).first else {
            return nil
        }
        return testResult.worldTransform
    }
    
    func existingPlanePoint(for normalizedPoint: CGPoint) -> matrix_float4x4? {
        let x = normalizedPoint.x
        let y = normalizedPoint.y
        if x < 0.0 || x > 1.0 || y < 0.0 || y > 1.0 {
            return nil
        }
        guard let testResult = hitTest(normalizedPoint, types: [.existingPlaneUsingExtent]).first else {
            return nil
        }
        return testResult.worldTransform
    }
}


// MARK: - ARFrame
extension ARFrame {
    func cameraVector() -> (direction: SCNVector3, position: SCNVector3) {
        let matrix = SCNMatrix4(camera.transform) // 4x4 transform matrix describing camera in world space
        let direction = SCNVector3(-1 * matrix.m31, -1 * matrix.m32, -1 * matrix.m33) // orientation of camera in world space
        let position = SCNVector3(matrix.m41, matrix.m42, matrix.m43) // location of camera in world space
        return (direction, position)
    }
}

// MARK: - UIView
extension UIView {
    func animateShow() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.alpha = 1
        }
    }
    
    func animateHide() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.alpha = 0
        }
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-30.0, 30.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}


// MARK: - Array
extension Array {
    subscript (safe index: Int) -> Element? {
        return index < count && index >= 0 ? self[index] : nil
    }
}


// MARK: - UIViewController
extension UIViewController {
    func showActivityIndicator() {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.color = .white
        activityIndicatorView.tag = 99
        activityIndicatorView.center = view.center
        activityIndicatorView.alpha = 0
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.animateShow()
    }
    
    func dismissActivityIndicator() {
        guard let activityIndicatorView = view.subviews.first(where: { $0.tag == 99 }) else { return }
        activityIndicatorView.animateHide()
        activityIndicatorView.removeFromSuperview()
    }
}


// MARK: UIImage
extension UIImage {
    func flippedHorizontal() -> UIImage {
        guard let cgImage = cgImage else {
            return self
        }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .upMirrored)
    }
}
