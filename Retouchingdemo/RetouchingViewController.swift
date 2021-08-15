import UIKit

class RetouchingViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    @IBOutlet var secondBtns: [UIButton]!
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var retouchingImageView: UIImageView!
    @IBOutlet var fullscreenView: UIView!
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    var rotatex: CGFloat = 1
    var rotatey: CGFloat = 1
    var rotateConstant: CGFloat = 0
    var imageBackgroundOriginalWidth: CGFloat = 0
    var imageBackgroundOriginalHeight: CGFloat = 0
    var retouchingImageOriginalWidth: CGFloat = 0
    var retouchingImageOriginalHeight: CGFloat = 0
    
    enum SecondBtnsType {
        case typeDefault, typeCrop, typeRotate
    }
    
    var type = SecondBtnsType.typeDefault
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageBackgroundOriginalWidth = imageBackgroundView.bounds.width
        imageBackgroundOriginalHeight = imageBackgroundView.bounds.height
        retouchingImageOriginalWidth = retouchingImageView.frame.width
        retouchingImageOriginalHeight = retouchingImageView.frame.height
    }
    
    
    func originalCrop() {
        imageBackgroundView.bounds.size = CGSize(width: imageBackgroundOriginalWidth, height: imageBackgroundOriginalHeight)
        retouchingImageView.frame.size = CGSize(width: retouchingImageOriginalWidth, height: retouchingImageOriginalHeight)
//        retouchingImageView.center = CGPoint(x: originalWidth / 2, y: originalHeight / 2)
//        retouchingImageView.frame = imageBackgroundView.bounds
//        width = imageBackgroundView.frame.width
//        height = imageBackgroundView.frame.height
//        retouchingImageView.layer.cornerRadius = 0
//        retouchingImageView.contentMode = .scaleAspectFit
//        retouchingImageView.bounds.size = CGSize(width: width, height: height)
    }
    
    func horizontalRotate() {
        rotatex *= -1
        retouchingImageView.transform = CGAffineTransform(scaleX: rotatex, y: rotatey)
    }
    
    @IBAction func Btn1(_ sender: UIButton) {
        switch type {
        case .typeDefault:
            fallthrough
        case .typeCrop:
            originalCrop()
        case .typeRotate:
            horizontalRotate()
        }
    }
    
    func squareCrop() {
        width = imageBackgroundView.bounds.width
        height = width
        imageBackgroundView.bounds.size = CGSize(width: width, height: height)
        retouchingImageView.frame.size = imageBackgroundView.bounds.size
//        retouchingImageView.center = CGPoint(x: width / 2, y: height / 2)

//        retouchingImageView.frame = imageBackgroundView.bounds
//        width = imageBackgroundView.frame.width
//        height = width
//        retouchingImageView.contentMode = .scaleAspectFill
//        retouchingImageView.bounds.size = CGSize(width: width, height: height)
    }
    
    func verticalRotate() {
        rotatey *= -1
        retouchingImageView.transform = CGAffineTransform(scaleX: rotatex, y: rotatey)
    }
    
    @IBAction func Btn2(_ sender: UIButton) {
        switch type {
        case .typeDefault:
            fallthrough
        case .typeCrop:
            squareCrop()
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
        switch type {
        case .typeDefault:
            fallthrough
        case .typeCrop:
            ratio16to9Crop()
        case .typeRotate:
            clockwiseRotate()
        }
    }
    
    func anticlockwiseRotate() {
        rotateConstant -= ((CGFloat.pi) / 2)
        retouchingImageView.transform = CGAffineTransform(rotationAngle: rotateConstant )
    }
    
    @IBAction func Btn4(_ sender: UIButton) {
        switch type {
        case .typeDefault:
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
    
    @IBAction func backgroundColorChange(_ sender: UIButton) {
        let controller = UIColorPickerViewController()
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    func secondBtnReset() {
        secondBtns[0].isHidden = false
        secondBtns[1].isHidden = false
        secondBtns[2].isHidden = false
        secondBtns[3].isHidden = false
    }
    
    @IBAction func typeCropChange(_ sender: UIButton) {
        secondBtnReset()
        type = .typeCrop
        switch type {
        case .typeDefault:
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
        type = .typeRotate
        switch type {
        case .typeDefault:
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
    
    func photoSave() {
        let renderer = UIGraphicsImageRenderer(size: imageBackgroundView.bounds.size)
        let retouchingImage = renderer.image (actions: { (UIGraphicsImageRendererContext) in
            imageBackgroundView.drawHierarchy(in: imageBackgroundView.bounds, afterScreenUpdates: true)
        })
        let activityViewController = UIActivityViewController(activityItems: [retouchingImage], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }

    @IBAction func saveBtn(_ sender: UIButton) {
        photoSave()
    }
}
