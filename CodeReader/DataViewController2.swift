import UIKit
class DataViewController2: UIViewController,UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var MyTableView: UITableView!
    @IBAction func back1(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "myCell2")
        let cellName = {(i: Int) -> String in
            guard let name = viewController.userDefaults.string(forKey: "\(i)") else{
                return ""
            }
            return name
        }
        if cellName(indexPath.row+1) != "" {
            cell.textLabel!.text = String(indexPath.row+1)+". \(cellName(indexPath.row+1))"
        } else {
            cell.textLabel!.text = String(indexPath.row+1)+"."
        }
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            UserDefaults.standard.removeObject(forKey: "\(indexPath.row+1)")
            for i in (indexPath.row...20){
                let Data = viewController.userDefaults.string(forKey: "\(i+2)")
                viewController.userDefaults.set(Data, forKey: "\(i+1)")
            }
            self.MyTableView.reloadData()
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Code = viewController.userDefaults.string(forKey: "\(indexPath.row+1)")!
        makingBarcode.makeBarcod()
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "segue2", sender: nil)
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if viewController.userDefaults.string(forKey: "\(indexPath.row+1)") == nil {
            return nil;
        }else{
            return indexPath;
        }
    }
    

    @IBAction func AC2(_ sender: Any) {
        self.ACAlart()     
    }
    func ACAlart() {
        let alart = UIAlertController (
            title: "確認",
            message: "全てのデータを削除しますか？",
            preferredStyle: .alert
        )
        let alart_button1 = UIAlertAction(
            title: "OK",
            style: .default,
            handler: { action in
                self.ACfunc()
                self.MyTableView.reloadData()
        })
        let alart_button2 = UIAlertAction(
            title: "キャンセル",
            style: .default,
            handler: { action in
        })
        alart.addAction(alart_button1)
        alart.addAction(alart_button2)
        present(alart, animated: true, completion: nil)
    }
    func ACfunc(){
        for i in  (1...20){
            UserDefaults.standard.removeObject(forKey: "\(i)")
        }
    }
}

let dataViewController2 = DataViewController2()
