import UIKit
import CoreData

class ProductFormViewController: UIViewController & UIPickerViewDelegate & UIPickerViewDataSource {
    
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 2
    var selectedRow = 0
    var states: [State] = []

    @IBOutlet weak var textFieldProductName: UITextField!
    @IBOutlet weak var imageViewProductPicture: UIImageView!
    @IBOutlet weak var textFieldOrderState: UITextField!
    @IBOutlet weak var textFieldProductPrice: UITextField!
    @IBOutlet weak var switchWasPaidByCard: UISwitch!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var buttonChooseOrderState: UIButton!
    
    var product: Product?
    var selectedState: State? =  nil {
        didSet {
            if selectedState == nil {
                textFieldOrderState.text = ""
            } else {
                textFieldOrderState.text = selectedState?.name
            }
        }
    }
    
    private func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            states = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStates()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProductFormViewController.imageTapped(gesture:)))
        imageViewProductPicture.addGestureRecognizer(tapGesture)
        imageViewProductPicture.isUserInteractionEnabled = true
        
        if let product = product {
            textFieldProductName.text = product.name
            imageViewProductPicture.image = product.pictureUIImage
            textFieldOrderState.text = product.state?.name
            textFieldProductPrice.text = "\(product.price)"
            switchWasPaidByCard.isOn = product.wasPaidByCreditCard
            selectedState = product.state
            title = "Editar Produto"
            buttonSubmit.setTitle("Salvar", for: .normal)
        }
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            selectImage()
        }
    }
    
    
    private func selectPictureFrom(_ sourceType: UIImagePickerController.SourceType) {
        view.endEditing(true)
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func selectImage(){
        let alert = UIAlertController(title: "Selecionar pôster", message: "De onde você deseja escolher o pôster?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { _ in
                self.selectPictureFrom(.camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de Fotos", style: .default) { _ in
            self.selectPictureFrom(.photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de Fotos", style: .default) { _ in
            self.selectPictureFrom(.savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func selectState(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(selectedRow, inComponent: 0, animated: true)
        
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
       
        
        let alert = UIAlertController(title: "Selecione o estado da Compra", message: "", preferredStyle: .actionSheet)
        
        alert.popoverPresentationController?.sourceView = buttonChooseOrderState
        alert.popoverPresentationController?.sourceRect = buttonChooseOrderState.bounds
        
        alert.setValue(vc, forKey: "ContentViewController")
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { UIAlertAction in
                
        } ))
        
        alert.addAction(UIAlertAction(title: "Selecionar", style: .default, handler: { UIAlertAction in
            self.selectedRow = pickerView.selectedRow(inComponent: 0)
            self.selectedState = self.states[self.selectedRow]
        } ))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: Any) {
        print("Submit")
        if(textFieldProductName.text == nil ||
           textFieldProductName.text == "" ||
           imageViewProductPicture.image == nil ||
           selectedState == nil ||
           (Double(textFieldProductPrice.text!) ?? 0.0) == 0.0){
            print("Submit ERROR")
            return
        }
        if product == nil {
            product = Product(context: context)
        }
        product?.name = textFieldProductName.text
        product?.picture = imageViewProductPicture.image?.jpegData(compressionQuality: 0.8)
        product?.state = selectedState
        product?.price = Double(textFieldProductPrice.text!) ?? 0.0
        product?.wasPaidByCreditCard = switchWasPaidByCard.isOn
        
        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row].name
    }
}

extension ProductFormViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imageViewProductPicture.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}
