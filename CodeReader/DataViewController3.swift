import UIKit
class DataViewController3: UIViewController,UITableViewDataSource, UITableViewDelegate{
    let Array = ["A病院","B病院","C病院"]
    @IBOutlet weak var HosTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allHospitalCode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "myCell3")
        /*
        let cellName = {(i: Int) -> String in
            guard let name = viewController.userDefaults.string(forKey: "\(i)") else{
                return ""
            }
            return name
        }
        */
    
        cell.textLabel!.text = Array[indexPath.row] + ":" + allHospitalCode[Array[indexPath.row]]!
       
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //nameData = Array[indexPath.row]
        numberData = Int (String(numberData) + allHospitalCode[Array[indexPath.row]]!)!
        viewController.addData()
        jsonParse.createJson()
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "segue3", sender: nil)
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if viewController.userDefaults.string(forKey: "\(indexPath.row+1)") == nil {
            return nil;
        }else{
            return indexPath;
        }
    }

}

let dataViewController3 = DataViewController3()
