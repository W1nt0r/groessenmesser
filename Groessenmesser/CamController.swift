//
//  CamController.swift
//  Groessenmesser
//
//  Created by Jan Winter & Adrian Tang on 03.10.14.
//  Copyright (c) 2014 HSR. All rights reserved.
//

import UIKit
import CoreMotion
protocol GetAnglesDelegate{
    func gotAngles(alphaAngle:Double!,betaAngle:Double!)
}

class CamController: UIViewController, DIYCamDelegate {
    
    var delegate:GetAnglesDelegate?
    var cam: DIYCam!
    var line: UIView!
    let motionManager = CMMotionManager()
    var currentAngle:Double!
    var capButton: UIButton!
    var alphaAngle:Double!
    var betaAngle:Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentAngle = nil
        self.alphaAngle = nil
        self.betaAngle = nil
        
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler: { (motion, error) -> Void in
            let interfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
            if UIInterfaceOrientationIsPortrait(interfaceOrientation) {
                let w = motion.attitude.quaternion.w
                let x = motion.attitude.quaternion.x
                let y = motion.attitude.quaternion.y
                let z = motion.attitude.quaternion.z
                
                let pitch = atan2(2*x*w - 2*y*z, 1 - 2*x*x - 2*z*z)
                
                self.currentAngle = self.radiansToDegree(pitch)
            } else {
                self.currentAngle = self.radiansToDegree(abs(motion.attitude.roll))
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        cam = DIYCam(frame: self.view.bounds)
        cam.delegate = self
        var params: [NSObject: AnyObject] = [DIYAVSettingCameraPosition : 1]
        
        cam.setupWithOptions(params)
        cam.setCamMode(DIYAVModePhoto)
        self.view.addSubview(cam)
        
        //let statusBar: Double = Double(UIApplication.sharedApplication().statusBarFrame.height)
        //let topLayBar: Double = Double(self.topLayoutGuide.length)
        //let botLayBar: Double  = Double(self.bottomLayoutGuide.length)
        
        let height: Double = 3.0
        let width: Double = Double(cam.bounds.width)
        let lineOriginX: Double = 0
        let lineOriginY: Double = Double(cam.bounds.height) / 2 - height / 2
        
        let lineFrame: CGRect = CGRect(x: lineOriginX, y: lineOriginY, width: width, height: height)
        let capButtonFrame: CGRect = CGRect(x: lineOriginX, y: 0, width: width, height: Double(cam.bounds.height))
        
        self.line = UIView(frame: lineFrame)
        cam.addSubview(self.line)
        self.line.backgroundColor = UIColor(red: 0, green: 222, blue: 96, alpha: 0.5)
        
        self.capButton = UIButton(frame: capButtonFrame)
        cam.addSubview(self.capButton)
        self.capButton.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.0)
        self.capButton.addTarget(self,action: "getAngle:",forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func radiansToDegree(radians:Double) -> Double {
        return radians * 180 / M_PI
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func getAngle(sender: UIButton) {
        self.setBeta()
        self.setAlpha()
        
        if (self.alphaAngle != nil && self.betaAngle != nil){
            var verification = UIAlertController(title:"Verification",message:"Do you want to proceed?",preferredStyle:UIAlertControllerStyle.Alert);
            verification.addAction(UIAlertAction(title: "Yes",style:UIAlertActionStyle.Default,handler: {
                (ACTION:UIAlertAction!) in
                let finalbetaAngle = self.betaAngle
                let finalalphaAngle = self.alphaAngle
                
                self.delegate!.gotAngles(finalalphaAngle, betaAngle: finalbetaAngle)
                self.navigationController?.popViewControllerAnimated(true)
            }))
            
            verification.addAction(UIAlertAction(title: "New Angles",style:UIAlertActionStyle.Default,handler: {
                (ACTION:UIAlertAction!) in
                self.clearAngles()
            }))
            
            self.presentViewController(verification, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.motionManager.stopDeviceMotionUpdates()
    }
    
    func setAlpha() {
        if(self.alphaAngle == nil) {
            self.alphaAngle = self.currentAngle
        }
    }
    
    func setBeta() {
        if(self.betaAngle == nil && self.alphaAngle != nil) {
            let beta = self.currentAngle - self.alphaAngle
            self.betaAngle = abs(beta)
        }
    }
    
    func clearAngles() {
        self.alphaAngle = nil
        self.betaAngle = nil
    }
    
    func camCaptureComplete(cam: DIYCam!, withAsset asset: [NSObject : AnyObject]!) {
        println("camCaptureComplete")
    }
    
    func camCaptureLibraryOperationComplete(cam: DIYCam!) {
        println("camCaptureLibraryOperationComplete")
    }
    
    func camCaptureProcessing(cam: DIYCam!) {
        println("camCaptureProcessing")
    }
    
    func camCaptureStarted(cam: DIYCam!) {
        exit(1)
    }
    
    func camCaptureStopped(cam: DIYCam!) {
        println("camCaptureStopped")
    }
    
    func camDidFail(cam: DIYCam!, withError error: NSError!) {
        println("camDidFail")
    }
    
    func camModeDidChange(cam: DIYCam!, mode: DIYAVMode) {
        println("camModeDidChange")
    }
    
    func camModeWillChange(cam: DIYCam!, mode: DIYAVMode) {
        println("camModeWillChange")
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
