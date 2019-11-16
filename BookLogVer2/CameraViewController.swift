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
    
//    var flag:Bool = false
    
    @IBAction func button(_ sender: Any) {
//        if(flag == false){//バーコード読み取れてない時
//            label.text = "false"
//        }else{//バーコード読み取れた時
//            label.text = "true"
//        }
        
        let tab = self.presentingViewController as! UITabBarController
        let AC = tab.viewControllers![tab.viewControllers!.count-2] as! AddController
        AC.TodoTextField.text = "hoge"
        self.dismiss(animated: true, completion: nil)
    }
    

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

//        view.addSubview(codeLabel)
//        codeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        codeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        codeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        codeLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//    let codeLabel:UILabel = {
//        let codeLabel = UILabel()
//        codeLabel.backgroundColor = .white
//        codeLabel.translatesAutoresizingMaskIntoConstraints = false
//        return codeLabel
//    }()
//
//    let codeFrame:UIView = {
//        let codeFrame = UIView()
//        codeFrame.layer.borderColor = UIColor.green.cgColor
//        codeFrame.layer.borderWidth = 2
//        codeFrame.frame = CGRect.zero
//        codeFrame.translatesAutoresizingMaskIntoConstraints = false
//        return codeFrame
//    }()

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        captureSession?.stopRunning()
        guard let objects = metadataObjects as? [AVMetadataObject] else { return }
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
            guard let isbn = convartISBN(value: value) else { continue }
            text += "ISBN:\t\(isbn)"
            print("text \(text)")
            
//            flag = true
            
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

}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


