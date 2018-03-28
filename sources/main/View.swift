
import UIKit

private func configure<Type>(_ value: Type, block: (_ object: Type) -> Void) -> Type {
    block(value)
    return value
}

class View: UIView
{
    private let circle = CircleView()
    private let label = configure(UILabel()){
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
    }
    private let field = configure(UITextField()){
        $0.backgroundColor = .white
        $0.textAlignment = .center
    }
    
    func animateCircle(duration: TimeInterval){
        circle.animateCircle(duration: duration)
    }
    func update(status: String){
        label.text = status
    }
        
    init() {
        super.init(frame: CGRect.zero)
        initialize()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("unavailable")
    }

    private func initialize()
    {
        backgroundColor = .black
        addSubview(circle)
        addSubview(label)
        addSubview(field)
        
        let views: [String: UIView] = [ "circle": circle, "field": field, "label": label]
        views.values.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            "H:|[circle]|", "V:|[circle]|",
            "H:|[field]|", "V:[field(30)]",
            "H:|-50-[label]|", "V:[field]-10-[label(20)]"
            ].forEach { (constraint) in
                addConstraints(NSLayoutConstraint.constraints(withVisualFormat: constraint, options: [], metrics: nil, views: views))
        }
        View.matchParentValue(attributes: [.centerX, .centerY], for: field)
    }
    
    private static func matchParentValue(attributes: [NSLayoutAttribute], for view: UIView){
        guard let parent = view.superview else { return }
        for attribute in attributes {
            parent.addConstraint(NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal, toItem: parent, attribute: attribute, multiplier: 1, constant: 0))
        }
    }
}
