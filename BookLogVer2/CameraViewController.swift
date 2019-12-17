//
//  CameraViewController.swift
//  BookLogVer2
//
//  Created by kisho shiraishi on 2019/11/15.
//  Copyright © 2019 kisho shiraishi. All rights reserved.
//
import UIKit
import AVFoundation
import AudioToolbox

class CameraViewController: UIViewController , AVCaptureMetadataOutputObjectsDelegate {

    var captureDevice:AVCaptureDevice?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var captureSession:AVCaptureSession?
    let detectionArea = UIView()
    var alertController: UIAlertController!
    // 検出エリアのビュー
    let x: CGFloat = 0.05
    let y: CGFloat = 0.3
    let width: CGFloat = 0.8
    let height: CGFloat = 0.2
    
//    var flag:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Scanner"
        view.backgroundColor = .white

        captureDevice = AVCaptureDevice.default(for: .video)
        // Check if captureDevice returns a value and unwrap it
        if let captureDevice = captureDevice {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)

                captureSession = AVCaptureSession()
                guard let captureSession = captureSession else { return }
                captureSession.addInput(input)

                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)
                // 検出エリアの設定
                captureMetadataOutput.rectOfInterest = CGRect(x: y,y: 1-x-width,width: height,height: width)

                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
                captureMetadataOutput.metadataObjectTypes = [.code128, .qr, .ean13,  .ean8, .code39] //AVMetadataObject.ObjectType
                captureSession.startRunning()

                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer?.videoGravity = .resizeAspectFill
                videoPreviewLayer?.frame = view.layer.bounds
                view.layer.addSublayer(videoPreviewLayer!)

            } catch {
                print("Error Device Input")
            }

        }

        view.addSubview(codeLabel)
        codeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        codeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        codeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        codeLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        
        //読み取り範囲の設定
        detectionArea.frame = CGRect(x: view.frame.size.width * x, y: view.frame.size.height * y, width: view.frame.size.width * width, height: view.frame.size.height * height)
        detectionArea.layer.borderColor = UIColor.red.cgColor
        detectionArea.layer.borderWidth = 2
        view.addSubview(detectionArea)
        self.view.bringSubviewToFront(detectionArea)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    let codeLabel:UILabel = {
        let codeLabel = UILabel()
        codeLabel.backgroundColor = .white
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        return codeLabel
    }()

    let codeFrame:UIView = {
        let codeFrame = UIView()
        codeFrame.layer.borderColor = UIColor.green.cgColor
        codeFrame.layer.borderWidth = 2
        codeFrame.frame = CGRect.zero
        codeFrame.translatesAutoresizingMaskIntoConstraints = false
        return codeFrame
    }()

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        captureSession?.stopRunning()
        let objects = metadataObjects as [AVMetadataObject]
        var detectionString: String? = nil
        let barcodeTypes = [AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13]
        for metadataObject in objects {
            loop: for type in barcodeTypes {
                guard metadataObject.type == type else { continue }
                guard self.videoPreviewLayer?.transformedMetadataObject(for: metadataObject) is AVMetadataMachineReadableCodeObject else { continue }
                if let object = metadataObject as? AVMetadataMachineReadableCodeObject {
                    detectionString = object.stringValue
                    break loop
                }
            }
            var text = ""
            guard let value = detectionString else { continue }
            text += "読み込んだ値:\t\(value)"
            text += "\n"
            guard let isbn = convartISBN(value: value) else {
                self.alert_notISBN(alertTitle: "ISBNではありません！", alertMessage: "正しいバーコードを読み込んでください",session: captureSession!)
                
                continue
            }
            text += "ISBN:\t\(isbn)"
            let get_api = GetGoogleApi()
            get_api.searchBook(completion: {returnData in
                
                
                if (returnData.totalItems != 0){
                    //googleのBookAPIに本の情報があった時
                    let tab = self.presentingViewController as! UITabBarController
                    let AC = tab.viewControllers![1] as! AddController
                    AC.TitleTextField.text = String((returnData.items?[0].volumeInfo?.title!)!)
                    var authors = String()
                    //あとでもっと丁寧に書きたい
                    for i in (returnData.items?[0].volumeInfo?.authors!)!{
                        authors = authors + i.description
                    }
                    AC.AuthorTextField.text = authors
                    
                    self.dismiss(animated: true, completion: nil)
                }else{
                    //本の情報がなかった時
                    self.alert_notfound(alertTitle: "登録情報がありません！！", alertMessage:"手動で入力してください")
                    
                }
                
                
            }, keyword : isbn)
                        
        }
    }


    private func convartISBN(value: String) -> String? {
        let v = NSString(string: value).longLongValue
        let prefix: Int64 = Int64(v / 10000000000)
        guard prefix == 978 || prefix == 979 else { return nil }
        let isbn9: Int64 = (v % 10000000000) / 10
        var sum: Int64 = 0
        var tmpISBN = isbn9
        /*
         for var i = 10; i > 0 && tmpISBN > 0; i -= 1 {
         let divisor: Int64 = Int64(pow(10, Double(i - 2)))
         sum += (tmpISBN / divisor) * Int64(i)
         tmpISBN %= divisor
         }
         */

        var i = 10
        while i > 0 && tmpISBN > 0 {
            let divisor: Int64 = Int64(pow(10, Double(i - 2)))
            sum += (tmpISBN / divisor) * Int64(i)
            tmpISBN %= divisor
            i -= 1
        }

        let checkdigit = 11 - (sum % 11)
        return String(format: "%lld%@", isbn9, (checkdigit == 10) ? "X" : String(format: "%lld", checkdigit % 11))
    }
    
    //本がなかった時の処理
    func alert_notfound(alertTitle:String, alertMessage:String){
        alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            
            self.dismiss(animated: true, completion: nil)

        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func alert_notISBN(alertTitle:String, alertMessage:String, session:AVCaptureSession){
        alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            session.startRunning()
        }))
        
        present(alertController, animated: true, completion: nil)
    }

}
    

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
