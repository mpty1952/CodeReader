
import UIKit

class QRViewController: UIViewController {
    

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

