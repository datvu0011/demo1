//
//  Register_ViewController.swift
//  demo
//
//  Created by Dat  on 11/3/20.
//

import UIKit

class Register_ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var txt_Username: UITextField!
    
    
    @IBOutlet weak var imgAvartar: UIImageView!
    @IBOutlet weak var txt_Password: UITextField!
    @IBOutlet weak var txt_HoTen: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_DiaChi: UITextField!
    @IBOutlet weak var txt_DienThoai: UILabel!
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
//    var name: Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        spinner.isHidden = true
        
//        if let name = name {
//            print("\(name.count)")
//        }
        
//        guard let name = self.name else {
//            return
//        }
//
//        print("\(name.count)")
        
        
    }
    
    
    @IBAction func RegisterNewUrser(_ sender: Any) {
        
        var url = URL(string: Config.ServerUrl + "/uploadFile")
        //let url = URL(string: "http://172.18.94.37:3000/uploadFile")
        let boundary = UUID().uuidString
        let session = URLSession.shared
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"hinhdaidien\"; filename=\"avartar.png\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append((imgAvartar.image?.pngData())!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                let jasonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jasonData as? [String: Any]{
                    if(json["kq"] as! Int == 1 ){
                        let urlFile = json["urlFile"] as! [String:Any]
                        //print(urlFile["filename"])
                        
                        DispatchQueue.main.sync {
                            url = URL(string: Config.ServerUrl + "/register")
                            var request = URLRequest(url: url!)
                            request.httpMethod = "POST"
                             
                            let fileName = urlFile["filename"] as! String
                            var sData = "Username=" + self.txt_Username.text!
                            sData += "&Password=" + self.txt_Password.text!
                            sData += "&Name=" + self.txt_HoTen.text!
                            sData += "&Image=" + fileName
                            sData += "&Email=" + self.txt_Email.text!
                            sData += "&Address=" + self.txt_DiaChi.text!
                            sData += "&PhoneNumber=" + self.txt_DienThoai.text!
                            
                            let postdata = sData.data(using: .utf8)
                            request.httpBody = postdata
                            
                            let taskUserRegister = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
                                guard error == nil else {return}
                                guard let data = data else {return}
                                
                                DispatchQueue.main.sync {
                                    self.spinner.isHidden = false
                                }
                                
                                do {
                                    guard let json = try JSONSerialization.jsonObject(with:  data, options: .mutableContainers) as? [String:Any] else {return}
                                    print(json)
                                    if(json["kq"] as! Int == 1){
                                        //thanh cong
                                        //push login
                                    }else{
                                        DispatchQueue.main.sync {
                                            if let message = json["errMsg"] as? String {
                                                let alerview = UIAlertController(title: "THONG BAO", message: message, preferredStyle: .alert)
                                                alerview.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                                                self.present(alerview , animated: true, completion: nil)
                                            }
                                        }
                                    }
                                    
                                }catch let error { print(error.localizedDescription) }
                            })
                            taskUserRegister.resume()
                        }
                        
                    }else{ print("upload Failed")}
                }
            }
        }).resume()
        
    }
    
    
    @IBAction func ChooseImageFromPhotoGallery(_ sender: Any) {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            imgAvartar.image = image
        } else { }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func UploadImageToSever(_ sender: Any) {
        
//        let url = URL(string: "http://192.168.1.5:3000/uploadFile")
        //let url = URL(string: "http://172.18.94.37:3000/uploadFile")
        let boundary = UUID().uuidString
        let session = URLSession.shared
        
        guard let url = URL(string: "http://192.168.1.5:3000/uploadFile") else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"hinhdaidien\"; filename=\"avartar.png\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append((imgAvartar.image?.pngData())!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                let jasonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jasonData as? [String: Any]{
                    print(json)
                }
            }
        }).resume()
        
    }
    
    
}




                            
