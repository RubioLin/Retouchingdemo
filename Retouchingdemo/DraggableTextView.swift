import UIKit

class DraggableTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard currentType == .typeDefault else {
            return
        }
        if let touch = touches.first {
            let currentLocation = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            let deltaX = currentLocation.x - previousLocation.x
            let deltaY = currentLocation.y - previousLocation.y
            self.frame.origin.x += deltaX
            self.frame.origin.y += deltaY
        }
    }
    
    func textViewDidChange() {
        let fixedWidth =  self.frame.size.width
        let newSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        self.frame.size = CGSize(width: max(newSize.width, fixedWidth) , height: newSize.height)
    }
 
}
