//
//  SFIntroViewController.swift
//  Starfly
//
//  Created by Arturs Derkintis on 11/21/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit

class SFIntroViewController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .whiteColor()
        
        let imageView = UIImageView(image: UIImage(named: "splash"))
        addSubviewSafe(imageView)
        imageView.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(236)
            make.width.equalTo(240)
            make.center.equalTo(self.view)
        }
        
        //Blinking Animation
        let basicAnim = CABasicAnimation(keyPath: "opacity")
        basicAnim.fromValue = 1.0
        basicAnim.toValue = 0.5
        basicAnim.duration = 0.5
        basicAnim.autoreverses = true
        basicAnim.repeatCount = 4
        imageView.layer.addAnimation(basicAnim, forKey: "opacity")
        
        //Fade Animation
        UIView.animateWithDuration(0.3, delay: 2.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.view.alpha = 0.0
            imageView.transform = CGAffineTransformMakeScale(0.01, 0.01)
            }) { (fin) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        }

        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
