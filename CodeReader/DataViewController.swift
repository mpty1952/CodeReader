import UIKit
class DataViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var myTableView: UITableView!

    override func viewDidLoad(){
        super.viewDidLoad()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "myCell1")
        let cellName = {(i: Int) -> String in
            guard let name = viewController.userDefaults.string(forKey: "\(i)") else{
                return ""
            }
            return name
        }
        cell.textLabel!.numberOfLines = 0;
        if cellName(indexPath.row+1001) != "" {
            cell.textLabel!.text = String(format:"%2d",indexPath.row+1)+". "+"\(cellName(indexPath.row+1001))"+"\n"+"      Code: "+"\(cellName(indexPath.row+10001))"
        } else {
            cell.textLabel!.text = String(format:"%2d",indexPath.row+1)+"."
        }
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            UserDefaults.standard.removeObject(forKey: "\(indexPath.row+1001)")
            UserDefaults.standard.removeObject(forKey: "\(indexPath.row+10001)")
            for i in (indexPath.row...20){
                var j = 1000
                for _ in (1...2){
                    let Data = viewController.userDefaults.string(forKey: "\(i+2+j)")
                    viewController.userDefaults.set(Data, forKey: "\(i+1+j)")
                    j=j*10
                }
            }
            self.myTableView.reloadData()
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nameData = viewController.userDefaults.string(forKey: "\(indexPath.row+1001)")!
        numberData = UInt64(viewController.userDefaults.string(forKey: "\(indexPath.row+10001)")!)!
        jsonParse.createJson()
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "segue1", sender: nil)
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if viewController.userDefaults.string(forKey: "\(indexPath.row+1001)") == nil {
            return nil;
        }else{
            return indexPath;
        }
    }
    
    @IBAction func AC(_ sender: Any) {
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
                self.myTableView.reloadData()
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
            var j=1000
            for _ in (1...2){
                UserDefaults.standard.removeObject(forKey: "\(j+i)")
                j=j*10
            }
        }
    }
}

let dataViewController = DataViewController()
