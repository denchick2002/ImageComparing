//
//  ViewController.swift
//  ImageComparing
//
//  Created by Денис Андриевский on 1/31/20.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit
import CocoaImageHashing

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var percentageLabel: UILabel!
    private var sourceNumber: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func choose1BtnPressed(_ sender: Any) {
        sourceNumber = 1
        presentImagePickerController()
    }
    @IBAction func choose2BtnPressed(_ sender: Any) {
        sourceNumber = 2
        presentImagePickerController()
    }
    
    @IBAction func compareBtnPressed(_ sender: Any) {
        if compareImages() {
            percentageLabel.text = "Similar"
        } else {
            percentageLabel.text = "Not Similar"
        }
    }
    
    private func presentImagePickerController() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if sourceNumber == 1 {
                image1.image = selectedImage.fixOrientation()
                image1.contentMode = .scaleAspectFill
                image1.clipsToBounds = true
            } else {
                image2.image = selectedImage.fixOrientation()
                image2.contentMode = .scaleAspectFill
                image2.clipsToBounds = true
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func compareImages() -> Bool {
        guard let imageData1 = image1.image?.pngData(), let imageData2 = image2.image?.pngData() else { presentNoDataAlert(); return false }
        let lhsData = OSImageHashing.sharedInstance().hashImageData(imageData1, with: .pHash)
        let rhsData = OSImageHashing.sharedInstance().hashImageData(imageData2, with: .pHash)
        let result = OSImageHashing.sharedInstance().hashDistance(lhsData, to: rhsData, with: .pHash)
        return result < 10
    }
    
    func presentNoDataAlert() {
        let alertController = UIAlertController(title: "Oops..", message: "No Data Provided for some photoes", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

