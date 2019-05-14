//
//  ViewController.swift
//  Tinder
//
//  Created by Emre on 1.05.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var resimBegeni: UIImageView!
    @IBOutlet weak var anaResim: UIView!
    @IBOutlet weak var ortaResim: UIImageView!
    @IBOutlet weak var arkaResim: UIImageView!
    @IBOutlet weak var kullaniciAdi: UILabel!
    var sayi = 0
    var userId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        kullaniciGetir()
    }
    
    @IBAction func likeButon(_ sender: Any) {
        self.resimBegeni.alpha = 1
        self.resimBegeni.image = UIImage(named: "begen")
        var likeOrUnlike:String! = ""
        likeOrUnlike = "liked"
        self.kisiBegen(likeOrUnlike: likeOrUnlike)
        UIView.animate(withDuration: 1.0) {
            self.anaResim.center = CGPoint(x: self.anaResim.center.x - (self.view.frame.width), y: self.anaResim.center.y)
        }
        kullaniciGetirArkaResim()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.resimBegeni.alpha = 0
            self.ortaResim.alpha = 0
        }
        
        
        self.animate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            if self.ortaResim.image != self.arkaResim.image{
                self.ortaResim.image = self.arkaResim.image
            }
            else{
                self.ortaResim.image = UIImage(named: "bosresim")
                self.arkaResim.image = self.ortaResim.image
                self.kullaniciAdi.text = "Gösterilecek Başka Kişi Kalmadı.."
            }
            self.ortaResim.alpha = 1
        }
        return
    }
    @IBAction func dislikeButon(_ sender: Any) {
        self.resimBegeni.alpha = 1
        self.resimBegeni.image = UIImage(named: "begenme")
        var likeOrUnlike:String! = ""
        likeOrUnlike = "unliked"
        self.kisiBegen(likeOrUnlike: likeOrUnlike)
        UIView.animate(withDuration: 1.0) {
            self.anaResim.center = CGPoint(x: self.anaResim.center.x + (self.view.frame.width), y: self.anaResim.center.y)
        }
        kullaniciGetirArkaResim()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.resimBegeni.alpha = 0
            self.ortaResim.alpha = 0
        }
        
        
        self.animate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            if self.ortaResim.image != self.arkaResim.image{
                self.ortaResim.image = self.arkaResim.image
            }
            else{
                self.ortaResim.image = UIImage(named: "bosresim")
                self.arkaResim.image = self.ortaResim.image
                self.kullaniciAdi.text = "Gösterilecek Başka Kişi Kalmadı.."
            }
            self.ortaResim.alpha = 1
        }
        return
    }
    @IBAction func kaydirResim(_ sender: UIPanGestureRecognizer) {
        
        //Resmin merkezini değiştirerek kaydırma
        guard let anaResim = sender.view else {return}
        let kaydirma = sender.translation(in: view)
        anaResim.center = CGPoint(x: view.center.x + kaydirma.x, y: view.center.y)
        
        //Resmin sağa mı sola mı kaydığını anlama ve dondurme
        let xMerkezeUzaklik = anaResim.center.x - view.center.x
        let donme = CGAffineTransform(rotationAngle: (abs(xMerkezeUzaklik) / view.center.x)/2)
        let pozitifBoyutVeDonme = donme.scaledBy(x: 1-((abs(xMerkezeUzaklik) / view.center.x) / 2), y: 1-((abs(xMerkezeUzaklik) / view.center.x) / 2))
        let negatifBoyutVeDonme = donme.scaledBy(x: (1-((abs(xMerkezeUzaklik) / view.center.x) / 2)), y: (1-((abs(xMerkezeUzaklik) / view.center.x) / 2)))
        if xMerkezeUzaklik > 0 {
            resimBegeni.alpha = 1
            resimBegeni.image = UIImage(named: "begen")
            anaResim.transform = pozitifBoyutVeDonme
        }else{
            resimBegeni.image = UIImage(named: "begenme")
            resimBegeni.alpha = 1
            anaResim.transform = negatifBoyutVeDonme
        }
        
        resimBegeni.alpha = abs(xMerkezeUzaklik) / view.center.x
        
        
        
        
        //Resmi Merkeze Döndürme Animasyonu
        if sender.state == UIGestureRecognizer.State.ended{
            
            var likeOrUnlike:String! = ""
            
            
            if anaResim.center.x < 60{
                UIView.animate(withDuration: 0.5) {
                    anaResim.center = CGPoint(x: anaResim.center.x - 200, y: anaResim.center.y + 50)
                    //Beğenilmediği anlamına geliyor
                    
                }
                likeOrUnlike = "unliked"
                kisiBegen(likeOrUnlike : likeOrUnlike)
                self.kullaniciGetirArkaResim()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    self.resimBegeni.alpha = 0
                    self.ortaResim.alpha = 0
                }
                animate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    if self.ortaResim.image == self.arkaResim.image{
                        self.ortaResim.image = UIImage(named: "bosresim")
                        self.ortaResim.alpha = 1
                        self.arkaResim.image = UIImage(named: "bosresim")
                        self.kullaniciAdi.text = "Gösterilecek Başka Kişi Kalmadı.."
                    }
                    else{
                        self.ortaResim.image = self.arkaResim.image
                        self.ortaResim.alpha = 1
                    }
                }
                return
            }
            else if anaResim.center.x > (view.frame.width - 60){
                UIView.animate(withDuration: 0.5) {
                    anaResim.center = CGPoint(x: anaResim.center.x + 200, y: anaResim.center.y + 50)
                    //Beğenildiği anlamına geliyor
                }
                likeOrUnlike = "liked"
                kisiBegen(likeOrUnlike: likeOrUnlike)
                self.kullaniciGetirArkaResim()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    self.resimBegeni.alpha = 0
                    self.ortaResim.alpha = 0
                }
                animate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    if self.ortaResim.image == self.arkaResim.image{
                        self.ortaResim.image = UIImage(named: "bosresim")
                        self.ortaResim.alpha = 1
                        self.arkaResim.image = UIImage(named: "bosresim")
                        self.kullaniciAdi.text = "Gösterilecek Başka Kişi Kalmadı.."
                    }
                    else{
                        self.ortaResim.image = self.arkaResim.image
                        self.ortaResim.alpha = 1
                    }
                    
                }
                return
            }
            animate()
            
        }
    }
    func kisiBegen(likeOrUnlike : String){
        if likeOrUnlike != "" && userId != ""{
            PFUser.current()?.addUniqueObject(userId, forKey: likeOrUnlike)
            PFUser.current()?.saveInBackground()
        }
    }
    func animate(){
        UIView.animate(withDuration: 0.5) {
            self.anaResim.center = self.view.center
            self.resimBegeni.alpha = 0
            self.anaResim.transform = CGAffineTransform.identity
            
        }
    }
    
    
    
    //Veritabanından kullanıcı resimlerinin belli bir koşula göre çekilmesi
    func kullaniciGetir(){
        if let sorgu = PFUser.query(){
            sorgu.whereKey("interest", equalTo: PFUser.current()!["gender"])
            sorgu.whereKey("gender", equalTo: PFUser.current()!["interest"])
            
            //Beğenilmiş veya Beğenilmemiş kullanıcıların birdaha gösterilmemesi
            var gosterme = [String]()
            if let likedUser = PFUser.current()?["liked"] as? [String]{
                gosterme.append(contentsOf: likedUser)
            }
            if let unLikedUser = PFUser.current()?["unliked"] as? [String]{
                gosterme.append(contentsOf: unLikedUser)
            }
            sorgu.whereKey("objectId", notContainedIn: gosterme)
            
            sorgu.findObjectsInBackground { (kullanicilar, error) in
                    if let kisiler = kullanicilar{
                        for kisi in kisiler{
                            if let kullanici = kisi as? PFUser{
                                if let imgFile = kullanici["profilePhoto"] as? PFFileObject{
                                    imgFile.getDataInBackground(block: { (data, error) in
                                        if let imgData = data{
                                            self.ortaResim.image = UIImage(data: imgData)
                                            self.kullaniciAdi.text = kullanici["username"] as? String
                                        }
                                        if let objectId = kisi.objectId{
                                            self.userId = objectId
                                        }
                                    })
                                }
                            }
                        }
                    }
            }
        }
    }
    func kullaniciGetirArkaResim(){
        if let sorgu = PFUser.query(){
            sorgu.whereKey("interest", equalTo: PFUser.current()!["gender"])
            sorgu.whereKey("gender", equalTo: PFUser.current()!["interest"])
            
            //Beğenilmiş veya Beğenilmemiş kullanıcıların birdaha gösterilmemesi
            var gosterme = [String]()
            if let likedUser = PFUser.current()?["liked"] as? [String]{
                gosterme.append(contentsOf: likedUser)
            }
            if let unLikedUser = PFUser.current()?["unliked"] as? [String]{
                gosterme.append(contentsOf: unLikedUser)
            }
            sorgu.whereKey("objectId", notContainedIn: gosterme)
            
            sorgu.findObjectsInBackground { (kullanicilar, error) in
                if let kisiler = kullanicilar{
                    for kisi in kisiler{
                        if let kullanici = kisi as? PFUser{
                            if let imgFile = kullanici["profilePhoto"] as? PFFileObject{
                                imgFile.getDataInBackground(block: { (data, error) in
                                    if let imgData = data{
                                        self.arkaResim.image = UIImage(data: imgData)
                                        self.kullaniciAdi.text = kullanici["username"] as? String
                                    }
                                    if let objectId = kisi.objectId{
                                        self.userId = objectId
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
}

