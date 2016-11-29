//
//  ExtraView.swift
//  LayerTest2
//
//  Created by rxj on 2016/11/18.
//  Copyright © 2016年 renxiaojian. All rights reserved.
//

import UIKit

private var headerKey: Void?

extension DispatchQueue {
    private static var _onceTracker = [String]()
    class func once(token: String, closure: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        closure()
    }
}

extension UIScrollView {
    weak var header: ExtradeHeader? {
        set{
            objc_setAssociatedObject(self, &headerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &headerKey) as? ExtradeHeader
        }
    }
    func addExRefresh(_ closure: @escaping Refreshclosue) {
        header = ExtradeHeader(frame: CGRect(x: 0, y: -44, width: frame.width, height: 44))
        header?.scrollView = self
        header?.refresh(closure)
    }
    
    open override class func initialize() {
        
        //保证只能执行一次
        DispatchQueue.once(token: "initialize", closure: {
            let method1 = class_getInstanceMethod(self, #selector(xdeaclloc))
            let method2 = class_getInstanceMethod(self, NSSelectorFromString("dealloc"))
            method_exchangeImplementations(method1, method2)
        })
        
    }
    func xdeaclloc() {
        if header != nil {
            removeObserver(header!, forKeyPath: "contentOffset")
            removeObserver(header!, forKeyPath: "contentSize")
            header?.removeFromSuperview()
            header = nil
        
        xdeaclloc()
        }
    }
    
    
}



enum RefreshState: Int {
    case nomal
    case pullToRefresh
    case refreshing
    case refreshed
}

typealias Refreshclosue = () ->Void

class ExtradeHeader: UIView {
    
    private  let moveDistance: CGFloat = 60  //拉伸最远距离
    private  let topMarin: CGFloat = 20      //上面圆心与起始点的距离
    private var maxRadius: CGFloat = 14     //圆半径的最大半径
    private var topRadius: CGFloat          //上圆半径
    private var moveRadius: CGFloat         //下圆半径
    private var arrowSize: CGFloat = 2.8    //箭头宽度
    private var exHeight: CGFloat           //高度
    private var shapLayer: CAShapeLayer!
    private var arrowLayer: CAShapeLayer!
    fileprivate var activityView: UIActivityIndicatorView!
    private var msgView: UIView!
    private var refreshclosure: Refreshclosue?
    private var isReset: Bool = false
    private var state: RefreshState = .nomal {
        didSet{
            if state != oldValue {
                stateDidChange()
            }
        }
    }
    weak var scrollView: UIScrollView? {
        didSet{
            scrollView?.addSubview(self)
        }
        
    }
    override init(frame: CGRect) {
        topRadius = maxRadius
        moveRadius = maxRadius
        exHeight = frame.height
        super.init(frame: frame)
        setup()
    }
    deinit {
        print("deinit ExtraView")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview is UIScrollView {
            addObserver()
        }
    }
    
    private func setup() {
        shapLayer = CAShapeLayer()
        shapLayer.fillColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).cgColor
        shapLayer.path = pathWithOffset(0)
        layer.addSublayer(shapLayer)
        
        arrowLayer = CAShapeLayer()
        arrowLayer.path = arrowPath(0)
        arrowLayer.strokeColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
        arrowLayer.fillColor = UIColor.white.cgColor
        arrowLayer.lineWidth = 0.5
        shapLayer.addSublayer(arrowLayer)
        
        activityView = UIActivityIndicatorView()
        activityView.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        activityView.center = CGPoint(x: frame.width / 2, y:topMarin)
        activityView.activityIndicatorViewStyle = .gray
        addSubview(activityView)
        
        msgView = UIView()
        msgView.center = activityView.center
        msgView.bounds = CGRect.zero
        addSubview(msgView)
        
        let msgLabel = UILabel()
        msgLabel.font = UIFont.systemFont(ofSize: 12)
        msgLabel.text = "刷新成功"
        msgLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        let size = NSString(string: msgLabel.text!).size(attributes: [NSFontAttributeName: msgLabel.font])
        msgLabel.frame = CGRect(x: 26, y: 0, width: size.width, height: 20)
        msgView.addSubview(msgLabel)
        msgView.alpha = 0
        msgView.bounds = CGRect(x: 0, y: 0, width: 24 + size.width, height: 20)
        
        let msgLayer = CAShapeLayer()
        msgLayer.frame = CGRect(x: 0, y: 0, width: msgView.frame.height, height: msgView.frame.height)
        msgLayer.strokeColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor
        msgLayer.fillColor = UIColor.clear.cgColor
        let radius: CGFloat = msgLayer.frame.height / 2
        let center = CGPoint(x: msgLayer.frame.width / 2, y: msgLayer.frame.height / 2)
        let point1 = CGPoint(x: center.x - radius * 0.6, y: center.y)
        let point2 = CGPoint(x: center.x - radius * 0.2, y: center.y + radius * 0.4)
        let point3 = CGPoint(x: center.x + radius * 0.6, y: center.y - radius * 0.4)
        let path = UIBezierPath()
        path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: false)
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        msgLayer.path = path.cgPath
        msgView.layer.addSublayer(msgLayer)
        
        
        
    }
    
    func refresh(_ closure: @escaping Refreshclosue) {
        refreshclosure = closure
    }
    
    func endRefresh() {
        state = .refreshed
        UIView.animate(withDuration: 0.2, animations: {
            self.msgView.alpha = 1
        }, completion: { (finished) in
            UIView.animate(withDuration: 0.35, delay: 0.2, options: .curveEaseInOut, animations: {
                self.scrollView?.contentInset.top = 0
            }, completion: { (finished) in
                if !(self.scrollView?.isDragging)! {
                    self.state = .nomal
                } else {
                    
                    UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseInOut, animations: {
                        self.msgView.alpha = 1
                    }, completion: { (finished) in
                        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseInOut, animations: {
                           self.msgView.alpha = 0
                        }, completion: { (finished) in
                             self.isReset = true
                        })
                       
                    })
                }
            })
        })
        
        
    }
    
    private func addObserver() {
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        scrollView?.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    private func removeObserver() {
        scrollView?.removeObserver(self, forKeyPath: "contentOffset")
        scrollView?.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            let offsetY = scrollView?.contentOffset.y
            let offset = abs(offsetY! + exHeight)
            if offsetY! <= -exHeight {
                frame = CGRect(x: 0, y: -(offset + exHeight), width: frame.width, height: offset + exHeight)
            } else {
                reSetpath()
            }
            if (scrollView?.isDragging)! {
                if state != .refreshing {
                    if offset >= moveDistance {
                        if state == .pullToRefresh {
                            state = .refreshing
                        }
                    } else {
                        guard offsetY! <= -exHeight else {
                            return
                        }
                        state = .pullToRefresh
                        setPath(offset: offset)
                    }
                    
                }
                
            } else {
                if state == .refreshing {
                    UIView .animate(withDuration: 0.35, animations: {
                        self.scrollView?.contentInset.top = self.exHeight
                        
                    })
                    
                } else {
                    reSetpath()
                }
                if offsetY == 0 && isReset {
                    state = .nomal
                }
            }
            
        } else if keyPath == "contentSize" {
            frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: exHeight)
            
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func stateDidChange() {
        switch state {
        case .nomal:
            reSetPostion()
            msgView.alpha = 0
        case .refreshing:
            if let closure = refreshclosure {
                closure()
            }
            beiginAnimation()
        case .refreshed:
            activityView.stopAnimating()
            
        default: break
            
        }
        
    }
    
    
    private func setPath(offset: CGFloat) {
        shapLayer.path = pathWithOffset(offset)
        arrowLayer.path = arrowPath(offset)
    }
    
    private func reSetPostion() {
        removeAnimtion()
        moveRadius = topRadius
        shapLayer.path = nil
        arrowLayer.path = nil
    }
    
    private func reSetpath() {
        shapLayer.path = pathWithOffset(0)
        arrowLayer.path = arrowPath(0)
    }
    
    private func arrowPath(_ offsetY: CGFloat) ->CGPath {
        let bRad = topRadius * 3 / 5
        let currentArrowSize = arrowSize - offsetY / moveDistance / 2 * arrowSize * 0.8
        let topCenter = CGPoint(x: frame.width / 2, y: topMarin)
        let path = CGMutablePath()
        path.addArc(center: topCenter, radius: bRad, startAngle: 0, endAngle: CGFloat(M_PI * 3 / 2), clockwise: false)
        let upPoint = CGPoint(x: topCenter.x, y: topCenter.y - bRad - currentArrowSize)
        let frontPoint = CGPoint(x: topCenter.x + currentArrowSize * 2 , y: topCenter.y - bRad + currentArrowSize / 2)
        let downPoint = CGPoint(x: topCenter.x, y: topCenter.y - bRad + currentArrowSize * 2)
        path.addLine(to: upPoint)
        path.addLine(to: frontPoint)
        path.addLine(to: downPoint)
        path.addArc(center: topCenter, radius: bRad - currentArrowSize, startAngle: CGFloat(M_PI * 3 / 2), endAngle: 0, clockwise: true)
        path.closeSubpath()
        return path
    }
    
    private func pathWithOffset(_ offsetY: CGFloat) -> CGPath {
        topRadius = maxRadius - offsetY / moveDistance / 2 * 2 / 3 * maxRadius
        moveRadius = topRadius - offsetY / moveDistance * topRadius * 2 / 3
        
        let topCenter = CGPoint(x: bounds.width / 2, y: topMarin)
        let moveCenter = CGPoint(x: bounds.width / 2, y: topMarin + offsetY)
        
        let a_pow = pow(moveCenter.x - topCenter.x, 2)
        let b_pow = pow(moveCenter.y - topCenter.y, 2)
        let l = sqrt(a_pow + b_pow)
        let sin = l != 0 ? abs(moveCenter.x - topCenter.x) / l: 0
        let cos = l != 0 ? abs(moveCenter.y - topCenter.y) / l: 0
        let topLeftPoint = CGPoint(x: topCenter.x - topRadius * cos, y: topCenter.y - topRadius * sin)
        let topRightPoint = CGPoint(x: topCenter.x + topRadius * cos, y: topCenter.y + topRadius * sin)
        let moveLeftPoint = CGPoint(x: moveCenter.x - moveRadius * cos, y: moveCenter.y - moveRadius * sin)
        let moveRightPoint = CGPoint(x: moveCenter.x + moveRadius * cos, y: moveCenter.y + moveRadius * sin)
        let leftCp1 = CGPoint(x: lerp(a: topLeftPoint.x, b: moveLeftPoint.x, p: 0.1), y: lerp(a: topCenter.y, b: moveCenter.y, p: 0.2))
        let leftCp2 = CGPoint(x: lerp(a: topLeftPoint.x, b: moveLeftPoint.x, p: 0.9), y: lerp(a: topCenter.y, b: moveCenter.y, p: 0.2))
        
        let rightCp2 = CGPoint(x: lerp(a: topRightPoint.x, b: moveRightPoint.x, p: 0.1), y: lerp(a: topCenter.y, b: moveCenter.y, p: 0.2))
        let rightCp1 = CGPoint(x: lerp(a: topRightPoint.x, b: moveRightPoint.x, p: 0.9), y: lerp(a: topCenter.y, b: moveCenter.y, p: 0.2))
        
        let path = UIBezierPath()
        path.addArc(withCenter: topCenter, radius: topRadius, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: false)
        path.addCurve(to: moveLeftPoint, controlPoint1: leftCp1, controlPoint2: leftCp2)
        path.addArc(withCenter: moveCenter, radius: moveRadius, startAngle: CGFloat(M_PI), endAngle: 0, clockwise: false)
        path.addCurve(to: topRightPoint, controlPoint1: rightCp1, controlPoint2: rightCp2)
        path.close()
        return path.cgPath
        
    }
    
    private func animatPath() -> CGPath {
        let radius = topRadius / 2
        let currentTopCenter = CGPoint(x: bounds.width / 2, y: topMarin)
        let path = UIBezierPath()
        let leftCpoint = CGPoint(x: currentTopCenter.x - radius, y: currentTopCenter.y)
        let rightCpoint = CGPoint(x: currentTopCenter.x + radius, y: currentTopCenter.y)
        path.addArc(withCenter: currentTopCenter, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: false)
        path.addCurve(to: leftCpoint, controlPoint1: leftCpoint, controlPoint2: leftCpoint)
        path.addArc(withCenter: currentTopCenter, radius: radius, startAngle: CGFloat(M_PI), endAngle: 0, clockwise: false)
        path.addCurve(to: rightCpoint, controlPoint1: rightCpoint, controlPoint2: rightCpoint)
        path.close()
        return path.cgPath
        
    }
    
    private func arrowAnimtPath() ->CGPath {
        let bRad: CGFloat = 0
        let topCenter = CGPoint(x: bounds.width / 2, y: topMarin)
        let path = CGMutablePath()
        path.addArc(center: topCenter, radius: bRad, startAngle: 0, endAngle: CGFloat(M_PI * 3 / 2), clockwise: false)
        let upPoint = CGPoint(x: topCenter.x, y: topCenter.y - bRad - arrowSize)
        let frontPoint = CGPoint(x: topCenter.x + arrowSize * 2 , y: topCenter.y - bRad + arrowSize / 2)
        let downPoint = CGPoint(x: topCenter.x, y: topCenter.y - bRad + arrowSize * 2)
        path.addLine(to: upPoint)
        path.addLine(to: frontPoint)
        path.addLine(to: downPoint)
        path.addArc(center: topCenter, radius: 0, startAngle: CGFloat(M_PI * 3 / 2), endAngle: 0, clockwise: true)
        path.closeSubpath()
        return path
    }
    
    private func removeAnimtion() {
        shapLayer.removeAllAnimations()
        arrowLayer.removeAllAnimations()
    }
    
    private func beiginAnimation() {
        let pathAnimat = CABasicAnimation(keyPath: "path")
        pathAnimat.duration = 0.15
        pathAnimat.toValue = animatPath()
        
        let opacityAnimtion = CABasicAnimation(keyPath: "opacity")
        opacityAnimtion.duration = 0.05
        opacityAnimtion.toValue = 0
        opacityAnimtion.beginTime = 0.1
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = 0.15
        groupAnimation.animations = [pathAnimat, opacityAnimtion]
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = kCAFillModeForwards
        groupAnimation.delegate = self
        shapLayer.add(groupAnimation, forKey: nil)
        
        let arrowAnimatiom = CABasicAnimation(keyPath: "opacity")
        arrowAnimatiom.duration = 0.1
        arrowAnimatiom.fromValue = 1.0
        arrowAnimatiom.toValue = 0.0
        arrowAnimatiom.isRemovedOnCompletion = false
        arrowAnimatiom.fillMode = kCAFillModeForwards
        arrowLayer.add(arrowAnimatiom, forKey: nil)
        activityView.startAnimating()
    }
    
    private func lerp(a: CGFloat, b: CGFloat, p: CGFloat) ->CGFloat {
        return a + (b - a) * p
    }
}

extension ExtradeHeader: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        activityView.startAnimating()
    }
}
