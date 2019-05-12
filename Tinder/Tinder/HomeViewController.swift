//
//  HomeViewController.swift
//  Tinder
//
//  Created by Emre on 5.05.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import UIKit
import Parse
class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var kullanici_ismi : String?
    var resimPicker = UIImagePickerController()
    
    
    
    @IBOutlet weak var profilResim: UIImageView!
    
    @IBOutlet weak var k_hidden: UILabel!
    @IBOutlet weak var kullanici_isim: UILabel!
    
    @IBOutlet weak var ilgiAlaniTextField: UITextField!
    @IBOutlet weak var cinsiyetTextField: UITextField!
    
    @IBOutlet weak var basariMesaji: UILabel!
    @IBOutlet weak var hataMesaji: UILabel!
    
    //Seçilen pickerView'in tutulduğu değişken
    var selectedGender:String?
    var selectedInterest:String?
    
    var genderPickerView = UIPickerView()
    let interestPickerView = UIPickerView()
    
    var data = ["Seçiniz", "Bay", "Bayan"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kullanici_isim.text = kullanici_ismi
        profilResim.setRounded()
        
        //PickerView Ayarları
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        
        interestPickerView.delegate = self
        interestPickerView.dataSource = self
        
        cinsiyetTextField.inputView = genderPickerView
        ilgiAlaniTextField.inputView = interestPickerView
        
        genderPickerView.tag = 1
        interestPickerView.tag = 2
        
        bittiButon()
        
        //Profil Bilgilerini VeriTabanından Okuma
        if let currentUser = PFUser.current(){
            if let gender = currentUser["gender"]{
                cinsiyetTextField.text = gender as? String
            }
            if let interest = currentUser["interest"]{
                ilgiAlaniTextField.text = interest as? String
            }
            if let photo = currentUser["profilePhoto"] as? PFFileObject{
                photo.getDataInBackground { (data, error) in
                    if let resimDosya = data{
                        if let resim = UIImage(data: resimDosya){
                            self.profilResim.image = resim
                        }
                    }
                }
            }
        }
    }
    
    //PickerView Fonksiyonları
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1{
            selectedGender = data[row]
            cinsiyetTextField.text = selectedGender
        }else if pickerView.tag == 2{
            selectedInterest = data[row]
            ilgiAlaniTextField.text = selectedInterest
        }else{
            return
        }
    }
    //BİTTİ BUTONU İŞLEMLERİ
    func bittiButon(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let bittiButon = UIBarButtonItem(title: "Bitti", style: .plain, target: self, action: #selector(dismissPicker))
        toolBar.setItems([bittiButon], animated: true)
        toolBar.isUserInteractionEnabled = true
        cinsiyetTextField.inputAccessoryView = toolBar
        ilgiAlaniTextField.inputAccessoryView = toolBar
    }
    @objc func dismissPicker(){
        view.endEditing(true)
    }
    //Çıkış Yap Butonu
    @IBAction func Cikis_btn(_ sender: Any) {
        PFUser.logOut()
        print ("buton çalıstı 1")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        self.present(loginVC, animated: true, completion: nil)
        print ("buton çalıstı 2")
    }
    
    //Kaydet Butonu
    @IBAction func kaydet(_ sender: Any) {
        print("Buton Çalıştı")
        PFUser.current()?["gender"] = selectedGender
        PFUser.current()?["interest"] = selectedInterest
        
        let image = self.profilResim.image
        let imageData = image?.pngData()
        let imageFile = PFFileObject(name: "photo.png", data: imageData!)
                PFUser.current()?["profilePhoto"] = imageFile
                PFUser.current()?.saveInBackground(block: { (succes, error) in
                    if error != nil {
                        if let saveError = error as NSError?{
                            if let errorDetail = saveError.userInfo["error"] as? String{
                                self.hataMesaji.isHidden = false
                                self.hataMesaji.text = errorDetail
                                print("Resim KAYDEDİLEMEDİ")
                            }
                        }
                    }
                    else{
                        self.basariMesaji.isHidden = false
                        self.basariMesaji.text = "Bilgileriniz Kaydedildi.."
                        let swipeVC = self.storyboard?.instantiateViewController(withIdentifier: "SwipeVC") as! ViewController
                        self.present(swipeVC, animated: true, completion: nil)
                    }
                })
    }
    
    @IBAction func resimDegistir(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Profil Resmi", message: "Resim Seçiniz", preferredStyle: .actionSheet)
        let resimGalerisi = UIAlertAction(title: "Resimler", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum){
                self.resimPicker.delegate = self
                self.resimPicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
                self.resimPicker.allowsEditing = true
                self.present(self.resimPicker, animated: true, completion: nil)
            }
        }
        let kamera = UIAlertAction(title: "Kamera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                self.resimPicker.delegate = self
                self.resimPicker.sourceType = UIImagePickerController.SourceType.camera
                self.resimPicker.allowsEditing = true
                self.present(self.resimPicker, animated: true,completion: nil)
            }
        }
        
        actionSheet.addAction(resimGalerisi)
        actionSheet.addAction(kamera)
        
        actionSheet.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //Profil resmini anlık olarak değiştirir
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else{
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        profilResim.image = image
        self.dismiss(animated: true, completion: nil)
    }
}
extension UIImageView{
    func setRounded(){
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = true
    }
}
