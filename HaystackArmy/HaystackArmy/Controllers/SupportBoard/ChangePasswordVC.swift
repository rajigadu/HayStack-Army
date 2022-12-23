//
//  ChangePasswordVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 13/05/21.
//

import UIKit

class ChangePasswordVC: UIViewController {
    @IBOutlet weak var OldPasswordTfref: UITextField!
    @IBOutlet weak var PasswordTfref: UITextField!
    @IBOutlet weak var ConfirmPasswordTfref: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backbtnref(_sender : Any){
        self.popToBackVC()
    }
    
    @IBAction func ChangePasswordbtnref(_sender : Any){
        switch self.ChangePasswordValidation() {
       case .Success:
           print("done")
           self.ChangePasswordMethod()
       case .Error(let errorStr) :
           print(errorStr)
            self.showToast(message: errorStr, font: .systemFont(ofSize: 12.0))
        }
    }

}
extension ChangePasswordVC: UITextFieldDelegate{
 
    func ChangePasswordValidation()-> ApiCheckValidation {
        if OldPasswordTfref.text ?? "" == "" || PasswordTfref.text ?? "" == "" || ConfirmPasswordTfref.text ?? "" == "" {
            return ApiCheckValidation.Error("All feilds are required...")
        }else if let Passstr = PasswordTfref.text,Passstr.count < 6 {
            return ApiCheckValidation.Error("Please enter Valid Password...")
        }else if let Passstr = PasswordTfref.text,let Passstr2 = ConfirmPasswordTfref.text {
            if Passstr != Passstr2 {
                return ApiCheckValidation.Error("Please enter Valid Password...")
            }else {
                return ApiCheckValidation.Success
            }
        } else {
            return ApiCheckValidation.Success
        }
    }
}
extension ChangePasswordVC {
   
    
    //MARK:- login func
    func ChangePasswordMethod(){
        indicator.showActivityIndicator()
    
        guard let OldPassword = OldPasswordTfref.text else{
            indicator.hideActivityIndicator()
            return}
        guard let password = PasswordTfref.text else{
            indicator.hideActivityIndicator()
            return}
        
        var UserId = ""
        if  LognedUserType == "Soldier" {
            UserId = UserDefaults.standard.string(forKey: "SoldierId") ?? ""
        }else {
            UserId = UserDefaults.standard.string(forKey: "SpouseId")  ?? ""
        }
        
        let parameters = [
             "oldpassword" : OldPassword,
            "newpassword" : password,
            
            "lognied_User":LognedUserType,
            "id":UserId
 
        ]
        NetworkManager.Apicalling(url: API_URl.ChangePassWordURL, paramaters: parameters, httpMethodType: .post, success: { (response:RegisterUserModel) in
            print(response.uid)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                
                let alertController = UIAlertController(title: kApptitle, message: response.message, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                    self.movetonextvc(id: "LoginVC", storyBordid: "Main")
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
                
                
               
                
             }else {
                indicator.hideActivityIndicator()
                self.ShowAlert(message: response.message ?? "Something went wrong...")
            }
        }) { (errorMsg) in
            
            indicator.hideActivityIndicator()
            if let err = errorMsg as? String{
                self.ShowAlert(message: err)
            }
        }
    }
}
