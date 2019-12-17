//
//  ViewController.swift
//  SeeFood
//
//  Created by Tim Newton on 12/16/19.
//  Copyright © 2019 EduServe, Inc. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func detect(image:CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML model failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                guard let results = request.results as? [VNClassificationObservation] else {
                    fatalError("Model failed to process image.")
                }
                
                print(results)
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        }
        catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            picker.dismiss(animated: true, completion: nil)
        }
        
        guard let userImage = info[.originalImage] as? UIImage else { return }
        imageView.image = userImage
        
        guard let ciImage = CIImage(image: userImage) else {
            fatalError("Could not convert to CIImage.")
        }
        
        detect(image: ciImage)
    }
}

//MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {
    
}
