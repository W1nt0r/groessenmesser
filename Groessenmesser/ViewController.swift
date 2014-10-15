//
//  ViewController.swift
//  Groessenmesser
//
//  Created by Jan Winter on 03.10.14.
//  Copyright (c) 2014 HSR. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, GetAnglesDelegate {
    @IBOutlet var distance: UITextField!
    @IBOutlet var betaLabel: UILabel!
    @IBOutlet var alphaLabel: UILabel!
    @IBOutlet var heightObject: UILabel!
    var betaAngleFinal:Double!
    var alphaAngleFinal:Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        distance.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotAlphaBeta"{
            let CamC:CamController=segue.destinationViewController as CamController
            CamC.delegate = self
        }
    }
    
    func gotAngles(alphaAngle:Double!,betaAngle:Double!){
        betaLabel.text=NSString(format:"%.2f",betaAngle);
        alphaLabel.text=NSString(format:"%.2f",alphaAngle)
        alphaAngleFinal=alphaAngle
        betaAngleFinal=betaAngle
    }
    
    @IBAction func validateDistance(sender: AnyObject) {
        if (NSString(string:distance.text).intValue == 0){
            var alert=UIAlertController(title:"Distance not numeric",message:"The Distance is not numeric",preferredStyle:UIAlertControllerStyle.Alert);
            
            alert.addAction(UIAlertAction(title: "OK",style:UIAlertActionStyle.Default,handler:nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func showHeight(sender: AnyObject) {
        //var temp = calculateHeight(NSString(string:distance.text).doubleValue)
        var temp = calculateHeight(NSString(string:distance.text))
        heightObject.text = "\(temp)"
    }
    
    
    func calculateHeight(strDistance:String)-> Double{
        println(alphaAngleFinal!)
        println(betaAngleFinal!)
        println(distance)
        
        let dblDistance: Double? = NSString(string: strDistance).doubleValue
        
        if let distance = dblDistance {
            let alphaRadian = self.degreeToRadians(self.alphaAngleFinal)
            let betaRadian = self.degreeToRadians(self.betaAngleFinal)
            
            //let c = (distance / sin(alphaAngleFinal!) * sin(90))
            let c = distance / sin(alphaRadian)
            println(c)
            let gamma = ( 180 - alphaAngleFinal! - betaAngleFinal!)
            let gammaRadian = self.degreeToRadians(gamma)
            println(gamma)
            //let b=(c / sin(gamma) * sin(betaAngleFinal!))
            let b = (c / sin(gammaRadian) * sin(betaRadian))
            println(b)
            var g:Double!
            g = b
            
            return g
        }
        
        
        return 0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func degreeToRadians(degree: Double) -> Double {
        return degree * M_PI / 180
    }
    
}

