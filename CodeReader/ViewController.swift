import Foundation
import AVFoundation
import UIKit
class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var cameraView: UIView!
    let userDefaults = UserDefaults.standard
    private var session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        
        do {
            let videoInput = try AVCaptureDeviceInput(device:videoCaptureDevice!)
            
            if self.session.canAddInput(videoInput) {
                self.session.addInput(videoInput)
                
                let metadataOutput = AVCaptureMetadataOutput()
                
                if self.session.canAddOutput(metadataOutput) {
                    self.session.addOutput(metadataOutput)
                    
                    metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    metadataOutput.metadataObjectTypes = [.qr]
                    
                    let PreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                    PreviewLayer.frame = self.cameraView.bounds
                    PreviewLayer.videoGravity = .resizeAspectFill
                    self.cameraView.layer.addSublayer(PreviewLayer)
                    PreviewLayer.position = CGPoint(x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
                    let X : CGFloat = 0.15
                    let Y : CGFloat = 0.25
                    let W : CGFloat = 0.7
                    let H : CGFloat = 0.7*self.view.frame.width/self.view.frame.height
                    metadataOutput.rectOfInterest = CGRect(x: Y,y: 1-X-W,width: H,height: W)
                    let borderView = UIView(frame: CGRect(x : X * self.view.bounds.width, y : Y * self.view.bounds.height, width : W * self.view.bounds.width, height : H * self.view.bounds.height))
                    borderView.layer.borderWidth = 2
                    borderView.layer.borderColor = UIColor.red.cgColor
                    self.view.addSubview(borderView)
                    self.session.startRunning()
                }
            }
        } catch {
            print("error")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            if metadata.type != .qr { continue }
            if metadata.stringValue == nil { continue }
            Code = metadata.stringValue!
            jsonParse.Parse()
            if Code[Code.startIndex] == "[" {
                Alart(code: Code)
            }else{
                EAlart(code: Code)
            }
            self.session.stopRunning()
            break
            
        }
    }
    func Alart(code: String) {
        print(code)
        let refix = UIAlertController (
            title: "取得コード",
            message: code,
            preferredStyle: .alert
        )
        let refix_button1 = UIAlertAction(
            title: "追加",
            style: .default,
            handler: { action in
                self.addData()
                self.session.startRunning()
        })
        let refix_button2 = UIAlertAction(
            title: "変更",
            style: .default,
            handler: { action in
                self.performSegue(withIdentifier: "segue4", sender: nil) 
                self.addData()
                self.session.startRunning()
        })
        let refix_button3 = UIAlertAction(
            title: "キャンセル",
            style: .default,
            handler: { action in
                self.session.startRunning()
        })
        refix.addAction(refix_button1)
        refix.addAction(refix_button2)
        refix.addAction(refix_button3)
        
        present(refix, animated: true, completion: nil)
    }
    func EAlart(code: String) {
        print(code)
        let error = UIAlertController (
            title: "error",
            message: code,
            preferredStyle: .alert
        )
        let error_button = UIAlertAction(
            title: "OK",
            style: .default,
            handler: { action in
                self.session.startRunning()
        })
        error.addAction(error_button)
        present(error, animated: true, completion: nil)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
        
    }
    
    
    func addData(){
        for i in (1...20) {
            if userDefaults.string(forKey: "\(1000+i)") == nil{
                userDefaults.set("\(nameData)", forKey: "\(1000+i)")
                userDefaults.set("\(numberData)", forKey: "\(10000+i)")
                break
            }
        }
    }
}
let viewController = ViewController()

