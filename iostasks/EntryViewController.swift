
import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var field: UITextField!
    
    var update: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTask()
        
        return true
    }
    
    @objc func saveTask() {
        
        guard let text = field.text, !text.isEmpty else{
            return
        }
        
        // instead of a database
        // increment the count by one (more items in table view) & save task entered by user

        guard let count = UserDefaults.value(forKey:"count") as? Int else { // Swift doesn't know this value can't be empty so guard against it being nil
            return
        }
    
        let newCount = count+1
        
        UserDefaults().set(newCount, forKey: "count")
        UserDefaults().set(text, forKey: "task_\(newCount)")
        
        update?() // if this update function exists, call it
        
        // dismiss the view controller
        navigationController?.popViewController(animated: true)
        
    }

}
