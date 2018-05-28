import AVFoundation
import UIKit
class ViewController2: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UITextFieldDelegate{
    let userDefaults = UserDefaults.standard
    var captureSession: AVCaptureSession!
    var X : CGFloat = 0.1
    var Y : CGFloat = 0.2
    var W : CGFloat = 0.8
    var H : CGFloat = 0.2
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet weak var cameraView2: UIView!
    @IBOutlet weak var Bar2: UITabBarItem!
    @IBOutlet weak var cgrect2: UIView!
    
    var metadataOutput = AVCaptureMetadataOutput()
    var borderView1: UIView!
    var borderView2: UIView!
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
            return;
        }
        
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13]
        } else {
            return
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        self.cameraView2.layer.addSublayer(previewLayer)
        previewLayer.videoGravity = .resizeAspectFill
        metadataOutput.rectOfInterest = CGRect(x: Y,y: 1-X-W,width: H,height: W)
        borderView1 = UIView(frame: CGRect(x : X * self.cgrect2.bounds.width, y : Y * self.cgrect2.bounds.height, width : W * self.cgrect2.bounds.width, height : H * self.cgrect2.bounds.height))
        borderView1.layer.borderWidth = 2
        borderView1.layer.borderColor = UIColor.red.cgColor
        self.view.addSubview(borderView1)
        borderView2 = UIView(frame: CGRect(x : 0.2 * self.cgrect2.bounds.height, y : 0.25 * self.cgrect2.bounds.width, width : 0.6 * self.cgrect2.bounds.height, height : 0.5                                                                                                                                 * self.cgrect2.bounds.width))
        borderView2.layer.borderWidth = 2
        borderView2.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        self.view.addSubview(borderView2)
        captureSession.startRunning();
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (captureSession?.isRunning == false) {
            captureSession.startRunning();
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.orientationChange()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning();
        }
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
        previewLayer?.bounds = cameraView2.frame
        previewLayer?.position = CGPoint(x: self.cameraView2.frame.width / 2, y: self.cameraView2.frame.height / 2)
        switch deviceOrientation {
        case UIDeviceOrientation.portrait:
            previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            metadataOutput.rectOfInterest = CGRect(x: Y,y: 1-X-W,width: H,height: W)
            borderView1.layer.borderColor = UIColor.red.cgColor
            borderView2.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
            break
        case UIDeviceOrientation.landscapeLeft:
            previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
            metadataOutput.rectOfInterest = CGRect(x: 0.2, y: 0.25, width: 0.6, height: 0.5)
            borderView2.layer.borderColor = UIColor.red.cgColor
            borderView1.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
            break
        case UIDeviceOrientation.landscapeRight:
            previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
            metadataOutput.rectOfInterest = CGRect(x: 0.2, y: 0.25, width: 0.6, height: 0.5)
            borderView2.layer.borderColor = UIColor.red.cgColor
            borderView1.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
            break
        default:
            break
        }
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
       if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            captureSession.stopRunning()
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
                self.captureSession.startRunning()
        })
        let refix_button2 = UIAlertAction(
            title: "変更",
            style: .default,
            handler: { action in
                makingBarcode.ChangeBarcode()
                self.addData()
                self.captureSession.startRunning()
        })
        let refix_button3 = UIAlertAction(
            title: "キャンセル",
            style: .default,
            handler: { action in
                self.captureSession.startRunning()
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


/*
if UIDeviceOrientationIsLandscape(deviceOrientation) {
    X = 0.2
    Y = 0.25
    W = 0.6
    H = 0.5
    previewLayer?.connection?.videoOrientation=AVCaptureVideoOrientation.landscapeLeft
} else if UIDeviceOrientationIsPortrait(deviceOrientation){
    X = 0.1
    Y = 0.2
    W = 0.8
    H = 0.2
    previewLayer?.connection?.videoOrientation=AVCaptureVideoOrientation.portrait
}
 */

