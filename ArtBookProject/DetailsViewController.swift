//
//  DetailsViewController.swift
//  ArtBookProject
//
//  Created by ProSmart on 19.8.21..
//

import UIKit
//Uvozimo core data da bbi dosli do suporta za database
import CoreData

class DetailsViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var yearText: UITextField!
    
    var chosenArt = ""
    var chosenArtId : UUID?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if chosenArt != "" {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Slika")
            
            let idString = chosenArtId?.uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                
                
                
                
            }catch{
                print("error")
            }
            
            
        }else{
            nameText.text = ""
            artistText.text = ""
            yearText.text = ""
        }

        //hiding keyboard
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        //Opening Gallery with image click
        imageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectPhoto))
        imageView.addGestureRecognizer(imageTapRecognizer)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func selectPhoto(){
        let picker = UIImagePickerController()
        //moraju se uvesti klase UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
        
    }
    
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    

    @IBAction func saveButtonClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newArt = NSEntityDescription.insertNewObject(forEntityName: "Slika", into: context)
        
        
        newArt.setValue(nameText.text!, forKey: "name")
        newArt.setValue(UUID() , forKey: "id")
        newArt.setValue(artistText.text!, forKey: "artist")
        
        if let year = Int(yearText.text!){
            newArt.setValue(year, forKey: "year")
        }
        
        newArt.setValue(imageView.image?.jpegData(compressionQuality: 0.5), forKey: "image")
        
        do {
            try context.save()
            print("saved")
        }catch {
            print("error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    

}
