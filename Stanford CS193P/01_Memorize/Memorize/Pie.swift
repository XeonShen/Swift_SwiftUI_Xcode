import SwiftUI

struct Pie: Shape {
    var startAngle: Angle
    var endAngel: Angle
    var animatableData: AnimatablePair<Double,Double> {
        get {
            AnimatablePair(startAngle.radians,endAngel.radians)
        }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngel = Angle.radians(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width,rect.height)/2
        let start = CGPoint(
            x: center.x + radius * CGFloat(cos(startAngle.radians)),
            y: center.y + radius * CGFloat(sin(startAngle.radians))
            
        )
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center,
                 radius: radius,
                 startAngle: startAngle,
                 endAngle: endAngel,
                 clockwise: true
        )
        p.addLine(to: center)
        return p
    }
}
