
import UIKit

class CircleView: UIView
{
    private var circleLayer: CAShapeLayer?
    
    override var superview: UIView? {
        get { return super.superview }
        set { expandOnSuperview() }
    }
    
    private func initialize(){
        CircleView.removeLayer(layer: self.circleLayer)
        let circleLayer = CircleView.createCircleLayerExpandedOnView(self)
        layer.addSublayer(circleLayer)
        self.circleLayer = circleLayer
    }
    
    func animateCircle(duration: TimeInterval) {
        initialize()
        let animation = CircleView.createStrokeAnimation(duration: duration)
        circleLayer?.strokeEnd = 1.0
        circleLayer?.add(animation, forKey: "animateCircle")
    }
    
    private func expandOnSuperview() {
        self.translatesAutoresizingMaskIntoConstraints = false
        ["H:|[view]|", "V:|[view]|"].forEach { (constraint) in
            superview?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: constraint, options: [], metrics: nil, views: ["view": self]))
        }
    }
    
    private static func removeLayer(layer: CALayer?){
        guard let layer = layer else { return }
        layer.removeAllAnimations()
        layer.removeFromSuperlayer()
    }
    
    private static func createCircleLayerExpandedOnView(_ view: UIView) -> CAShapeLayer {
        let center = CGPoint(x: view.frame.size.width / 2.0, y: view.frame.size.height / 2.0)
        let radius = (view.frame.size.width - 10)/2
        return CircleView.createCircleLayer(center: center, radius: radius)
    }
    
    private static func createCircleLayer(center: CGPoint, radius: CGFloat) -> CAShapeLayer {
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: radius,
                                      startAngle: 0.0,
                                      endAngle: CGFloat(Double.pi * 2.0),
                                      clockwise: true)
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.lineWidth = 50.0;
        circleLayer.strokeEnd = 0.0
        return circleLayer
    }
    
    private static func createStrokeAnimation(duration: TimeInterval) -> CABasicAnimation
    {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        return animation
    }
}

