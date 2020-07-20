
import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var tableView: UITableView!
    
    var tasks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTasks()
        // Extract to constant
        self.title = "Tasks"
        tableView.delegate = self
        tableView.dataSource = self 
        // Get all currently saved tasks
        // Saving setup
        
        if !UserDefaults.standard.bool(forKey:"setup"){
            
            UserDefaults.standard.set(true, forKey:"setup")
            UserDefaults.standard.set(0, forKey: "count")
        }
        
        
    }
    // swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete{
            
            var newCount = tasks.count
            newCount = newCount-1
            
            let index = indexPath.row
            
            tasks.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            UserDefaults.standard.set(newCount, forKey: "count")
            UserDefaults.standard.removeObject(forKey: "task_\(index)")
        }
        
        
        
    }
    
    func updateTasks(){
        print("updateTasks()")
        tasks.removeAll()
        
        guard let count = UserDefaults.standard.value(forKey: "count") as? Int else {
            return
        }
        // count is inclusive
        for x in 0..<count {
            
            if let task = UserDefaults.standard.value(forKey: "task_\(x+1)") as? String  { // make sure it's a string
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
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "task") as! TaskViewController
        // Extract to constant
        vc.title = "Update / Delete Task"
        vc.task = tasks[indexPath.row]
        vc.currentPosition = indexPath.row
        vc.count = tasks.count
        //print ("Selected \(vc.task)")
        navigationController?.pushViewController(vc, animated: true)
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
