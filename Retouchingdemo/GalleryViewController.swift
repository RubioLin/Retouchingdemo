import UIKit

class GalleryViewController: UIViewController {

    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var selectedPhotoBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedPhotoBtn.layer.cornerRadius = 35
        selectedPhotoBtn.backgroundColor = .black
        selectedPhotoBtn.layer.shadowRadius = 9
        selectedPhotoBtn.layer.shadowOpacity = 0.8
    }
    
    @IBAction func selectPhotoBtn(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Photo", message: nil, preferredStyle: .actionSheet)
        let sources:[(name:String, type:UIImagePickerController.SourceType)] = [
            ("Album", .photoLibrary),
            ("Camera", .camera)
        ]
        for source in sources {
            let action = UIAlertAction(title: source.name, style: .default) { (_) in
                self.selectPhoto(sourceType: source.type)
                
            }
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
    
extension GalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func selectPhoto(sourceType: UIImagePickerController.SourceType) {
        let ImagePickerController = UIImagePickerController()
        ImagePickerController.sourceType = sourceType
        ImagePickerController.delegate = self
        present(ImagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        if let retouchingController = storyboard?.instantiateViewController(identifier: "retouchingViewController", creator: { coder in RetouchingViewController(coder: coder, retouchingPhoto: image!)
        }) {
            show(retouchingController, sender: nil)
        }
        dismiss(animated: true, completion: nil)
    }
    
}

