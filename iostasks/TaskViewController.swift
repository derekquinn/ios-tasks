
import UIKit

class TaskViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    var task: String?
    var currentPosition: Int?
    var count: Int?
    var update: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = task
        
    }
    
}


