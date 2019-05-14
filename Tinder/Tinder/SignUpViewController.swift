//
//  SignUpViewController.swift
//  Tinder
//
//  Created by Emre on 5.05.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var Header: UILabel!
    @IBOutlet weak var kullaniciAdi: UITextField!
    @IBOutlet weak var kullaniciMail: UITextField!
    @IBOutlet weak var kullaniciSifre: UITextField!
    @IBOutlet weak var hataMesaji: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Header.font = UIFont(name:"Bebas Neue", size: 30.0)
        hataMesaji.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUp_Button(_ sender: Any) {
        let user = PFUser()
        user.username = kullaniciAdi.text
        user.email = kullaniciMail.text
        user.password = kullaniciSifre.text
        
        user.signUpInBackground { (success, error) in
            if error != nil{
                if let signUperror = error as NSError?{
                    if let hataDetayi = signUperror.userInfo["error"] as? String{
                        self.hataMesaji.isHidden = false
                        self.hataMesaji.text = hataDetayi
                        
                    }
                }
            }else{
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LogInViewController
                print("Kaydınız Başarı ile Tamamlanmıştır..")
                self.present(loginVC, animated: true, completion: nil)
                
            }
        }
    }
    
}

