import UIKit

enum type {
    case typeText, typeCrop, typeRotate
}

var currentType: type = .typeText

class RetouchingViewController: UIViewController, UIColorPickerViewControllerDelegate, UITextViewDelegate {
    
    init?(coder: NSCoder, retouchingPhoto: UIImage){
        self.selectedPhoro = retouchingPhoto
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet var secondBtns: [UIButton]!
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var retouchingImageView: UIImageView!
    @IBOutlet var fullscreenView: UIView!
    var selectedPhoro: UIImage?
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    var rotatex: CGFloat = 1
    var rotatey: CGFloat = 1
    var rotateConstant: CGFloat = 0
    var imageBackgroundOriginalWidth: CGFloat = 0
    var imageBackgroundOriginalHeight: CGFloat = 0
    var retouchingImageOriginalWidth: CGFloat = 0
    var retouchingImageOriginalHeight: CGFloat = 0
    var textView: DraggableTextView?
    var imageBackgroundmaxY: CGFloat = 0
    var imageBackgroundminY: CGFloat = 0
    var a: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(g:)) )
        textView?.addGestureRecognizer(pan)
        retouchingImageView.image = selectedPhoro
        imageBackgroundOriginalWidth = imageBackgroundView.bounds.width
        imageBackgroundOriginalHeight = imageBackgroundView.bounds.height
        retouchingImageOriginalWidth = retouchingImageView.frame.width
        retouchingImageOriginalHeight = retouchingImageView.frame.height
        imageBackgroundmaxY = imageBackgroundView.frame.maxY
        imageBackgroundminY = imageBackgroundView.frame.minY
    }
    
    @objc func pan(g: UIPanGestureRecognizer) {
        switch g.state {
        case .began:
            print("began")
        case .ended:
            print("ended")
        case .changed:
            self.textView?.center = g.location(ofTouch: 0, in: retouchingImageView)
            if (self.textView?.frame.midY)! > retouchingImageView.bounds.maxY {
                textView?.frame.origin = CGPoint(x: retouchingImageView.frame.midX - CGFloat((self.textView?.frame.width)! / 2), y: retouchingImageView.frame.midY - CGFloat((self.textView?.frame.height)! / 2))
            } 
        default:
            print("hello")
        }
    }
    
    
    func originalCrop() {
        imageBackgroundView.bounds.size = CGSize(width: imageBackgroundOriginalWidth, height: imageBackgroundOriginalHeight)
        retouchingImageView.frame.size = CGSize(width: retouchingImageOriginalWidth, height: retouchingImageOriginalHeight)
        
    }
    
    func horizontalRotate() {
        rotatex *= -1
        retouchingImageView.transform = CGAffineTransform(scaleX: rotatex, y: rotatey)
    }
    
     
    
    @IBAction func Btn1(_ sender: UIButton) {
        switch currentType {
        case .typeText:
            createTextView()
        case .typeCrop:
            originalCrop()
            imageBackgroundmaxY = imageBackgroundView.frame.maxY
            print(imageBackgroundmaxY)
        case .typeRotate:
            horizontalRotate()
        }
    }
    
    func squareCrop() {
        width = imageBackgroundView.bounds.width
        height = width
        imageBackgroundView.bounds.size = CGSize(width: width, height: height)
        retouchingImageView.frame.size = imageBackgroundView.bounds.size
    }
    
    func verticalRotate() {
        rotatey *= -1
        retouchingImageView.transform = CGAffineTransform(scaleX: rotatex, y: rotatey)
    }
    
    @IBAction func Btn2(_ sender: UIButton) {
        switch currentType {
        case .typeText:
            fallthrough
        case .typeCrop:
            squareCrop()
            imageBackgroundmaxY = imageBackgroundView.frame.maxY
            print(imageBackgroundmaxY)
        case .typeRotate:
            verticalRotate()
        }
    }
    
    func ratio16to9Crop() {
        width = imageBackgroundView.bounds.width
        height = width / 16 * 9
        imageBackgroundView.bounds.size = CGSize(width: width, height: height)
        retouchingImageView.frame.size = imageBackgroundView.bounds.size
       
    }
    
    func clockwiseRotate() {
        rotateConstant += ((CGFloat.pi) / 2)
        retouchingImageView.transform = CGAffineTransform(rotationAngle: rotateConstant )
    }
    
    @IBAction func Btn3(_ sender: UIButton) {
        switch currentType {
        case .typeText:
            fallthrough
        case .typeCrop:
            ratio16to9Crop()
            imageBackgroundmaxY = imageBackgroundView.frame.maxY
            print(imageBackgroundmaxY)
        case .typeRotate:
            clockwiseRotate()
        }
    }
    
    func anticlockwiseRotate() {
        rotateConstant -= ((CGFloat.pi) / 2)
        retouchingImageView.transform = CGAffineTransform(rotationAngle: rotateConstant )
    }
    
    @IBAction func Btn4(_ sender: UIButton) {
        switch currentType {
        case .typeText:
            fallthrough
        case .typeCrop:
            fallthrough
        case .typeRotate:
            anticlockwiseRotate()
        }
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        imageBackgroundView.backgroundColor = viewController.selectedColor
    }
    
    func secondBtnReset() {
        secondBtns[0].isHidden = false
        secondBtns[1].isHidden = false
        secondBtns[2].isHidden = false
        secondBtns[3].isHidden = false
    }
 
    func photoSave() {
        let renderer = UIGraphicsImageRenderer(size: imageBackgroundView.bounds.size)
        let retouchingImage = renderer.image (actions: { (UIGraphicsImageRendererContext) in
            imageBackgroundView.drawHierarchy(in: imageBackgroundView.bounds, afterScreenUpdates: true)
        })
        let activityViewController = UIActivityViewController(activityItems: [retouchingImage], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }

    @IBAction func saveBtn(_ sender: Any) {
        photoSave()
    }
    
    @IBAction func typeCropChange(_ sender: UIButton) {
        secondBtnReset()
        currentType = .typeCrop
        switch currentType {
        case .typeText:
            fallthrough
        case .typeCrop:
            secondBtns[0].setTitle("original", for: .normal)
            secondBtns[0].setImage(nil, for: .normal)
            secondBtns[1].setTitle("1:1", for: .normal)
            secondBtns[1].setImage(nil, for: .normal)
            secondBtns[2].setTitle("9:16", for: .normal)
            secondBtns[2].setImage(nil, for: .normal)
            secondBtns[3].isHidden = true
        case .typeRotate:
            break
        }
    }
    
    @IBAction func typeRotateChange(_ sender: UIButton) {
        secondBtnReset()
        currentType = .typeRotate
        switch currentType {
        case .typeText:
            fallthrough
        case .typeCrop:
            fallthrough
        case .typeRotate:
            secondBtns[0].setTitle(nil, for: .normal)
            secondBtns[0].setImage(UIImage(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right"), for: .normal)
            secondBtns[1].setTitle(nil, for: .normal)
            secondBtns[1].setImage(UIImage(systemName: "arrow.up.and.down.righttriangle.up.righttriangle.down"), for: .normal)
            secondBtns[2].setTitle(nil, for: .normal)
            secondBtns[2].setImage(UIImage(systemName: "rotate.right"), for: .normal)
            secondBtns[3].setTitle(nil, for: .normal)
            secondBtns[3].setImage(UIImage(systemName: "rotate.left"), for: .normal)
        }
    }
    
    @IBAction func backgroundColorChange(_ sender: UIButton) {
        let controller = UIColorPickerViewController()
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func typeTextChange(_ sender: UIButton) {
        secondBtnReset()
        currentType = .typeText
        switch currentType {
        case .typeText:
            secondBtns[0].setTitle(nil, for: .normal)
            secondBtns[0].setImage(UIImage(systemName: "plus"), for: .normal)
            secondBtns[1].setTitle(nil, for: .normal)
            secondBtns[1].setImage(UIImage(systemName: "paintpalette"), for: .normal)
            secondBtns[2].setTitle(nil, for: .normal)
            secondBtns[2].setImage(UIImage(systemName: "character.cursor.ibeam"), for: .normal)
            secondBtns[3].setTitle(nil, for: .normal)
            secondBtns[3].setImage(UIImage(systemName: "clear"), for: .normal)
        case .typeCrop:
            fallthrough
        case .typeRotate:
            break
        }
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.textView?.resignFirstResponder()    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = .lightGray
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = .clear
    }
    
    
    func createTextView() {
        textView = DraggableTextView(frame: CGRect(x: 0, y: 0, width: 100, height: 20), textContainer: nil)
        textView?.backgroundColor = .lightGray
        textView?.delegate = self
        textView?.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        self.imageBackgroundView.addSubview(textView!)
        textView?.isScrollEnabled = false
    }
}
