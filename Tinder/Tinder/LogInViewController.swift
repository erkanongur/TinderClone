//
//  LogInViewController.swift
//  Tinder
//
//  Created by Emre on 5.05.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import UIKit
import Parse
class LogInViewController: UIViewController {

    @IBOutlet weak var kullaniciAdi: UITextField!
    @IBOutlet weak var kullaniciSifre: UITextField!
    @IBOutlet weak var hataMesaji: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        hataMesaji.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logIn_Button(_ sender: Any) {
        let kAdi = kullaniciAdi.text
        let kSifre = kullaniciSifre.text
        
        PFUser.logInWithUsername(inBackground: kAdi!, password: kSifre!) { (user, error) in
            if error != nil{
                if let logInError = error as NSError?{
                    if let hataDetayi = logInError.userInfo["error"] as? String{
                        self.hataMesaji.isHidden = false
                        self.hataMesaji.text = hataDetayi
                        print(hataDetayi)
                    }
                }
            }else{
                if let currentUser = PFUser.current(){
                    let gender = currentUser["gender"]
                    if gender != nil{
                        let swipeVC = self.storyboard?.instantiateViewController(withIdentifier: "SwipeVC") as! ViewController
                        self.present(swipeVC, animated: true, completion: nil)
                    }
                }
                
                let HomeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
                HomeVC.kullanici_ismi = user?.username // HomeVC sayfasına kullanıcı adını taşıma işlemi
                print("Anasayfaya Hoş Geldiniz !!!")
                self.present(HomeVC, animated: true, completion: nil)
            }
        }
    }
    
}
