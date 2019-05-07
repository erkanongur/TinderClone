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
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func likeButon(_ sender: Any) {
        UIView.animate(withDuration: 1.5) {
            self.anaResim.center = CGPoint(x: self.anaResim.center.x + (self.view.frame.width), y: self.anaResim.center.y)
        }
        /*
        self.resimBegeni.alpha = 1
        self.resimBegeni.image = UIImage(named: "begen")*/
        return
    }
    @IBAction func dislikeButon(_ sender: Any) {
        UIView.animate(withDuration: 1.5) {
            self.anaResim.center = CGPoint(x: self.anaResim.center.x - (self.view.frame.width), y: self.anaResim.center.y)
        }
        /*
        self.resimBegeni.alpha = 1
        self.resimBegeni.image = UIImage(named: "begenme")*/
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
            if anaResim.center.x < 60{
                UIView.animate(withDuration: 0.5) {
                    anaResim.center = CGPoint(x: anaResim.center.x - 200, y: anaResim.center.y + 50)
                }
                return
            }
            else if anaResim.center.x > (view.frame.width - 60){
                UIView.animate(withDuration: 0.5) {
                    anaResim.center = CGPoint(x: anaResim.center.x + 200, y: anaResim.center.y + 50)
                }
                return
            }
            
            UIView.animate(withDuration: 0.5) {
                anaResim.center = self.view.center
                self.resimBegeni.alpha = 0
                anaResim.transform = CGAffineTransform.identity
                
            }
        }
    }
    

}

