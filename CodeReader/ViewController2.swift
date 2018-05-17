import AVFoundation
import UIKit
class ViewController2: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UITextFieldDelegate{
    let userDefaults = UserDefaults.standard
    var captureSession: AVCaptureSession!
    let X : CGFloat = 0.1
    let Y : CGFloat = 0.2
    let W : CGFloat = 0.8
    let H : CGFloat = 0.2
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet weak var cameraView2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        let videoInput: AVCaptureDeviceInput
        
        
        do {
            videoInput = try AVCaptureDeviceInput(device:videoCaptureDevice!)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill;
        view.layer.addSublayer(previewLayer);
        cameraView2.layer.addSublayer(previewLayer!)
        previewLayer?.position = CGPoint(x: self.cameraView2.frame.width / 2, y: self.cameraView2.frame.height / 2)
        previewLayer?.bounds = cameraView2.frame
        
        metadataOutput.rectOfInterest = CGRect(x: Y,y: 1-X-W,width: H,height: W)
        
        let borderView = UIView(frame: CGRect(x : X * self.view.bounds.width, y : Y * self.view.bounds.height, width : W * self.view.bounds.width, height : H * self.view.bounds.height))
        borderView.layer.borderWidth = 2
        borderView.layer.borderColor = UIColor.red.cgColor
        self.view.addSubview(borderView)
        
        captureSession.startRunning();
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning();
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: readableObject.stringValue!);
            
        }
        
    }
    
    func found(code: String) {
        print(code)
        Code = code
        let refix = UIAlertController (
            title: "取得コード",
            message: Code,
            preferredStyle: .alert
        )
        let refix_button1 = UIAlertAction(
            title: "追加",
            style: .default,
            handler: { action in
                self.addData()
                self.viewDidLoad()
        })
        let refix_button2 = UIAlertAction(
            title: "変更",
            style: .default,
            handler: { action in
                makingBarcode.ChangeBarcode()
                self.addData()
                self.viewDidLoad()
        })
        let refix_button3 = UIAlertAction(
            title: "キャンセル",
            style: .default,
            handler: { action in
                self.viewDidLoad()
        })
        refix.addAction(refix_button1)
        refix.addAction(refix_button2)
        refix.addAction(refix_button3)
        
        present(refix, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
        
    }
    @IBOutlet weak var aaa: UIButton!
    
    func addData(){
        for i in (1...20) {
            let Data = userDefaults.string(forKey: "\(i)")
            if Data == nil{
                userDefaults.set("\(Code)", forKey: "\(i)")
                break
            }
        }
    }
}

let viewController2 = ViewController2()

