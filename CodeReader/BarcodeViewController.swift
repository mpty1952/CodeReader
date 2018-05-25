import UIKit

class BarcodeViewController: UIViewController{
    
    @IBOutlet weak var Barcode: UIView!
    @IBAction func Back2(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myView = MyView(frame: Barcode.bounds)
        myView.backgroundColor = UIColor.white
        Barcode.addSubview(myView)
        DisplayCode(code: CodeStart, xx: 7)
        DisplayCode(code: CodeLeft, xx: 35.75)
        DisplayCode(code: CodeRight, xx: 151.25)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DisplayCode(code: String, xx:Double){
        var i:Double = 0
        for char in code {
            let label = UILabel()
            label.text = String(char)
            label.frame = CGRect(x: xx + 17.5 * i, y: 140, width: 15, height: 22.7)
            label.textColor = UIColor.black
            label.backgroundColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 22.7)
            Barcode.addSubview(label)
            i += 1
        }
    }
}

class MyView: UIView {
    override func draw(_ rect: CGRect) {
        let bar = UIBezierPath()
        var yy: Double
        for i in(0...94) {
            if (0...2 ~= i || 45...49 ~= i || 92...94 ~= i) {
                yy = 155
            } else {
                yy = 140
            }
            if output[i] == 1 {
                bar.move(to: CGPoint(x: 25.75 + 2.5 * Double(i), y: 5))
                bar.addLine(to: CGPoint(x: 25.75 + 2.5 * Double(i), y: yy))
                bar.lineWidth = 2.0 // 線の太さ
                UIColor.black.setStroke() // 色をセット
                bar.stroke()
            }
        }
    }
}
