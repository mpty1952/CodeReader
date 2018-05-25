
import UIKit

class QRViewController: UIViewController {
    
    @IBAction func Back3(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var QRView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let Image = createQRcode.createQR(from: Code)
        self.QRView.image = Image
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

