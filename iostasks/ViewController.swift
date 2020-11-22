
import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var tableView: UITableView!
    
    var tasks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTasks()
        // Extract to constant
        self.title = Constant.titleTasks
        tableView.delegate = self
        tableView.dataSource = self 
        // Get all currently saved tasks
        // Saving setup
        
        if !UserDefaults.standard.bool(forKey: Constant.setup){
            
            UserDefaults.standard.set(true, forKey: Constant.setup)
            UserDefaults.standard.set(0, forKey: Constant.count)
        }
        
        
    }
    
    func updateTasks(){
        print("updateTasks()")
        tasks.removeAll()
        
        guard let count = UserDefaults.standard.value(forKey: Constant.count) as? Int else {
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
        let vc = storyboard?.instantiateViewController(withIdentifier: Constant.entryIdentifier) as! EntryViewController
        // Extract to constant
        vc.title = Constant.titleNewTask
        
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
        
        let vc = storyboard?.instantiateViewController(withIdentifier: Constant.taskIdentifier) as! TaskViewController
        // Extract to constant
        vc.title = Constant.titleStoryboard
        vc.task = tasks[indexPath.row]
        vc.currentPosition = indexPath.row
        vc.count = tasks.count
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let index = indexPath.row
            // remove task from array at index
            tasks.remove(at: indexPath.row)
            // remove task from tableView
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            // remove object (row) from UserDefaults.standard
            UserDefaults.standard.removeObject(forKey: "task_\(index)")
            // update User Defaults count
            let newCount = tasks.count
            UserDefaults.standard.set(newCount, forKey: Constant.count)
            // tableView reload
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // DQueue the cell ?
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cell, for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row]
        
        return cell
    }
    
}
