
import UIKit

class ViewController: UIViewController {
    

    @IBOutlet var tableView: UITableView!
    var tasks = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Extract to constant
        self.title = "Tasks"
        tableView.delegate = self
        tableView.dataSource = self 
        // Get all currently saved tasks
        
        // Saving setup
        
        if !UserDefaults().bool(forKey: "setup"){
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count") // Number of tasks user currently has
        }
        
        
        
    }
    
    func updateTasks(){
        
        tasks.removeAll()
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        // count is inclusive
        for x in 0..<count {
             
            if let task = UserDefaults().value(forKey: "task_\(x+1)") as? String  {
                tasks.append(task)
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func didTapAdd(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "entry") as! EntryViewController
        // Extract to constant
        vc.title = "New Task"
        
        //reload the table view when add tasks
        vc.update = {
            DispatchQueue.main.async { // prioritize updating the tasks
                      self.updateTasks()
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension ViewController: UITableViewDelegate {
    
    func tableView (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // DQueue the cell ?
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row]
        
        return cell
    }
    
}
