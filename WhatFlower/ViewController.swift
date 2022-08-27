//
//  ViewController.swift
//  WhatFlower
//
//  Created by 罗帆 on 7/12/22.
//

import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let wikipediaURL = "https://en.wikipedia.org/w/api.php"
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Can't convert to CIImage")
            }
            
            detect(image: ciImage)
            
            imageView.image = userPickedImage
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else {
            fatalError("Cannot import model")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let classification = request.results?.first as? VNClassificationObservation else {
                fatalError("Cannot classify image.")
            }
            self.navigationItem.title = classification.identifier.capitalized
            self.requestInfo(flowerName: classification.identifier)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do{
            try handler.perform([request])
        } catch {
            print(error)
        }
        
    }
    
    func requestInfo(flowerName: String) {
        
        let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts|pageimages",
            "exintro" : "",
            "explaintext" : "",
            "titles" : flowerName,
            "redirects" : "1",
            "pithumbsize" : "500",
            "indexpageids" : ""
        ]
        
        AF.request(wikipediaURL, method: .get, parameters: parameters).validate(contentType: ["application/json"]).responseJSON { (response) in
            switch response.result {
            case let .success(value):
//                print(response.result)
                
                let flowerJSON = JSON(value)
                let flowerImageAddr = flowerJSON["query"]["pages"][0]["thumbnail"]["source"].stringValue
                if let pageId = flowerJSON["query"]["pageids"][0].string {
                    if let flowerDescription = flowerJSON["query"]["pages"][pageId]["extract"].string {
                        self.label.text = flowerDescription
//                        self.imageView.sd_setImage(with: URL(string: flowerImageAddr))

//                        if let flowerImageURL = URL(string: flowerImageAddr) {
//                            if let data = try? Data(contentsOf: flowerImageURL) {
//                                if let image = UIImage(data: data) {
//                                    DispatchQueue.main.async {
//                                        self.imageView.image = image
//                                    }
//                                }
//                            }
//                        }
                    }
                }
                
            case let .failure(error):
                print(error)
            }
            
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

//extension UIImageView {
//    func load(url: URL) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}

