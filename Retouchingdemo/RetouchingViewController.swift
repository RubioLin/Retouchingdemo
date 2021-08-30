import UIKit
import CoreImage.CIFilterBuiltins

enum type {
    case typeDefault, typeCrop, typeRotate, typeFilter
}

var currentType: type = .typeDefault

class RetouchingViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    init?(coder: NSCoder, retouchingPhoto: UIImage){
        self.selectedPhoto = retouchingPhoto
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    @IBOutlet var filterBtns: [UIButton]!
    @IBOutlet weak var filterScrollView: UIScrollView!
    @IBOutlet var secondBtns: [UIButton]!
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var retouchingImageView: UIImageView!
    @IBOutlet var fullscreenView: UIView!
    var selectedPhoto: UIImage?
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        retouchingImageView.image = selectedPhoto
        imageBackgroundOriginalWidth = imageBackgroundView.bounds.width
        imageBackgroundOriginalHeight = imageBackgroundView.bounds.height
        retouchingImageOriginalWidth = retouchingImageView.frame.width
        retouchingImageOriginalHeight = retouchingImageView.frame.height
        imageBackgroundmaxY = imageBackgroundView.frame.maxY
        imageBackgroundminY = imageBackgroundView.frame.minY
    }
    
    //裁切成原圖
    func originalCrop() {
        imageBackgroundView.bounds.size = CGSize(width: imageBackgroundOriginalWidth, height: imageBackgroundOriginalHeight)
        retouchingImageView.frame.size = CGSize(width: retouchingImageOriginalWidth, height: retouchingImageOriginalHeight)
    }
    
    //水平翻轉
    func horizontalRotate() {
        rotatex *= -1
        retouchingImageView.transform = CGAffineTransform(scaleX: rotatex, y: rotatey)
    }
    
    @IBAction func Btn1(_ sender: UIButton) {
        switch currentType {
        case .typeDefault:
            fallthrough
        case .typeCrop:
            originalCrop()
            imageBackgroundmaxY = imageBackgroundView.frame.maxY
            print(imageBackgroundmaxY)
        case .typeRotate:
            horizontalRotate()
        case .typeFilter:
            break
        }
    }
    
    //裁切成1：1
    func squareCrop() {
        width = imageBackgroundView.bounds.width
        height = width
        imageBackgroundView.bounds.size = CGSize(width: width, height: height)
        retouchingImageView.frame.size = imageBackgroundView.bounds.size
    }
    
    //垂直翻轉
    func verticalRotate() {
        rotatey *= -1
        retouchingImageView.transform = CGAffineTransform(scaleX: rotatex, y: rotatey)
    }
    
    @IBAction func Btn2(_ sender: UIButton) {
        switch currentType {
        case .typeDefault:
            fallthrough
        case .typeCrop:
            squareCrop()
            imageBackgroundmaxY = imageBackgroundView.frame.maxY
            print(imageBackgroundmaxY)
        case .typeRotate:
            verticalRotate()
        case .typeFilter:
            break
        }
    }
    
    //裁切成16：9
    func ratio16to9Crop() {
        width = imageBackgroundView.bounds.width
        height = width / 16 * 9
        imageBackgroundView.bounds.size = CGSize(width: width, height: height)
        retouchingImageView.frame.size = imageBackgroundView.bounds.size
       
    }
    
    //順時針翻轉
    func clockwiseRotate() {
        rotateConstant += ((CGFloat.pi) / 2)
        retouchingImageView.transform = CGAffineTransform(rotationAngle: rotateConstant )
    }
    
    @IBAction func Btn3(_ sender: UIButton) {
        switch currentType {
        case .typeDefault:
            fallthrough
        case .typeCrop:
            ratio16to9Crop()
            imageBackgroundmaxY = imageBackgroundView.frame.maxY
            print(imageBackgroundmaxY)
        case .typeRotate:
            clockwiseRotate()
        case .typeFilter:
            break
        }
    }
    
    //逆時針翻轉
    func anticlockwiseRotate() {
        rotateConstant -= ((CGFloat.pi) / 2)
        retouchingImageView.transform = CGAffineTransform(rotationAngle: rotateConstant )
    }
    
    @IBAction func Btn4(_ sender: UIButton) {
        switch currentType {
        case .typeDefault:
            fallthrough
        case .typeCrop:
            fallthrough
        case .typeRotate:
            anticlockwiseRotate()
        case .typeFilter:
            break
        }
    }
    
    //背景色調整
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        imageBackgroundView.backgroundColor = viewController.selectedColor
    }
    
    //重置上排按鈕的狀態
    func secondBtnReset() {
        filterScrollView.isHidden = true
        secondBtns[0].isHidden = false
        secondBtns[1].isHidden = false
        secondBtns[2].isHidden = false
        secondBtns[3].isHidden = false
    }
    
    //濾鏡的設定
    func filterChange(filterName: filterEffect) {
        let ciImage = CIImage(image: selectedPhoto!)
        let filter = CIFilter(name: filterName.rawValue)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        if filterName == .CISepiaTone {
            filter?.setValue(1 , forKey: kCIInputIntensityKey)
        }
        if let output = filter?.outputImage {
            let filterImage = UIImage(ciImage: output)
            retouchingImageView.image = filterImage
        }
    }
    
    @IBAction func filterChange(_ sender: UIButton) {
        let index = filterBtns.firstIndex(of: sender)
        switch index {
        case 0:
            retouchingImageView.image = selectedPhoto
        case 1:
            filterChange(filterName: .CIPhotoEffectInstant)
        case 2:
            filterChange(filterName: .CISepiaTone)
        case 3:
            filterChange(filterName: .CIPhotoEffectMono)
        case 4:
            filterChange(filterName: .CIPhotoEffectProcess)
        case 5:
            filterChange(filterName: .CISRGBToneCurveToLinear)
        default:
            break
        }
    }
    
    //儲存照片
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
        case .typeDefault:
            fallthrough
        case .typeCrop:
            secondBtns[0].setTitle("original", for: .normal)
            secondBtns[0].setImage(nil, for: .normal)
            secondBtns[1].setTitle("1:1", for: .normal)
            secondBtns[1].setImage(nil, for: .normal)
            secondBtns[2].setTitle("16:9", for: .normal)
            secondBtns[2].setImage(nil, for: .normal)
            secondBtns[3].isHidden = true
        case .typeRotate:
            fallthrough
        case .typeFilter:
            break
        }
    }
    
    @IBAction func typeRotateChange(_ sender: UIButton) {
        secondBtnReset()
        currentType = .typeRotate
        switch currentType {
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
        case .typeFilter:
            break
        }
    }
    
    @IBAction func backgroundColorChange(_ sender: UIButton) {
        let controller = UIColorPickerViewController()
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
        
    @IBAction func typeFilterChange(_ sender: UIButton) {
        currentType = .typeFilter
        switch currentType {
        case .typeDefault:
            fallthrough
        case .typeCrop:
            fallthrough
        case .typeRotate:
            fallthrough
        case .typeFilter:
            filterScrollView.isHidden = false
            secondBtns[0].isHidden = true
            secondBtns[1].isHidden = true
            secondBtns[2].isHidden = true
            secondBtns[3].isHidden = true
        }
    }
    
    //TODO: - 新增文字功能待新增
    /*
    @IBAction func typeTextChange(_ sender: UIButton) {
        secondBtnReset()
        currentType = .typeDefault
        switch currentType {
        case .typeDefault:
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
            fallthrough
        case .typeFilter:
            break
        }
    }
    */
}
