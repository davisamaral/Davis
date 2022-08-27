import UIKit

class StatePickerViewController: UIViewController & UIPickerViewDelegate & UIPickerViewDataSource {
    
    var pickerData: [String] = [String]()
    
    @IBOutlet weak var pickerViewOrderState: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerViewOrderState.delegate = self
        pickerViewOrderState.dataSource = self
        pickerData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}
