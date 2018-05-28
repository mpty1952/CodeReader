import Foundation
import AVFoundation
import UIKit
class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var Bar1: UITabBarItem!

    @IBOutlet weak var cgrect1: UIView!
    let userDefaults = UserDefaults.standard
    var PreviewLayer: AVCaptureVideoPreviewLayer!
    var borderView1: UIView!
    var borderView2: UIView!
    let X : CGFloat = 0.16
    let Y : CGFloat = (1.0 - (0.68 * 40.0 / 71.0)) / 2.0
    let W : CGFloat = 0.68
    let H : CGFloat = 0.68 * 40.0 / 71.0
    private var session = AVCaptureSession()
    var metadataOutput = AVCaptureMetadataOutput()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        
        do {
            let videoInput = try AVCaptureDeviceInput(device:videoCaptureDevice!)
            
            if self.session.canAddInput(videoInput) {
                self.session.addInput(videoInput)
                
                if self.session.canAddOutput(metadataOutput) {
                    self.session.addOutput(metadataOutput)
                    metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    metadataOutput.metadataObjectTypes = [.qr]
                    metadataOutput.rectOfInterest = CGRect(x: Y,y: 1-X-W,width: H,height: W)
                    PreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                    PreviewLayer.videoGravity = .resizeAspectFill
                    self.cameraView.layer.addSublayer(PreviewLayer)
                    borderView1 = UIView(frame: CGRect(x : X * self.cgrect1.bounds.width, y : Y * self.cgrect1.bounds.height, width : W * self.cgrect1.bounds.width, height : H * self.cgrect1.bounds.height))
                    borderView1.layer.borderWidth = 2
                    borderView1.layer.borderColor = UIColor.red.cgColor
                    self.view.addSubview(borderView1)
                    borderView2 = UIView(frame: CGRect(x : Y * self.cgrect1.bounds.height, y : (1-W-X) * self.cgrect1.bounds.width, width : W * self.cgrect1.bounds.width, height : H * self.cgrect1.bounds.height))
                    borderView2.layer.borderWidth = 2
                    borderView2.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
                    self.view.addSubview(borderView2)
                    self.session.startRunning()
                }
            }
        } catch {
            print("error")
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (session.isRunning == false) {
            session.startRunning();
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.orientationChange()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) 
        NotificationCenter.default.addObserver(self, selector: #selector(self.OrientationChange(notification:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    @objc func OrientationChange(notification: NSNotification){
        self.orientationChange()
    }
    func orientationChange(){
        let deviceOrientation = UIDevice.current.orientation
        PreviewLayer?.bounds = cameraView.frame
        PreviewLayer?.position = CGPoint(x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
        switch deviceOrientation {
        case UIDeviceOrientation.portrait:
            PreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            metadataOutput.rectOfInterest = CGRect(x: Y,y: 1-X-W,width: H,height: W)
            borderView1.layer.borderColor = UIColor.red.cgColor
            borderView2.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
            break
        case UIDeviceOrientation.landscapeLeft:
            PreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
            metadataOutput.rectOfInterest = CGRect(x: Y,y: 1-X-W, width: W * 40.0 / 71.0, height: H * 71.0 / 40.0)
            borderView2.layer.borderColor = UIColor.red.cgColor
            borderView1.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
            break
        case UIDeviceOrientation.landscapeRight:
            PreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
            metadataOutput.rectOfInterest = CGRect(x: Y,y: 1-X-W, width: W * 40.0 / 71.0, height: H * 71.0 / 40.0)
            borderView2.layer.borderColor = UIColor.red.cgColor
            borderView1.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
            break
        default:
            break
        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (session.isRunning == true) {
            
            session.stopRunning();
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
            self.session.stopRunning()
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            if Code[Code.startIndex] == "{" {
                jsonParse.Parse()
                Alart(code: Code)
            }else{
                EAlart(code: Code)
            }
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
                self.session.stopRunning()
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
