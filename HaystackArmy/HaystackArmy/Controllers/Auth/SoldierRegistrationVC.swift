//
//  SoldierRegistrationVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 12/05/21.
//

import UIKit

class SoldierRegistrationVC: UIViewController {
    @IBOutlet weak var headerVewref: UIView!
    
    @IBOutlet weak var FNametfref: UITextField!
    @IBOutlet weak var LnameTfref: UITextField!
     @IBOutlet weak var DodidTfref: UITextField!
    @IBOutlet weak var GovtEmailAddressTfref: UITextField!
    @IBOutlet weak var UserNameTfref: UITextField!
    @IBOutlet weak var PasswordTfref: UITextField!
    @IBOutlet weak var ConfirmPasswordTfref: UITextField!
    
    @IBOutlet weak var contentAcceptBtnref: UIButton!
    @IBOutlet weak var TermaAndConditionTfref: UIButton!
    
    var isContentSelected = false
    var istermsSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UserNameTfref.delegate = self
        // self.headerVewref.addBottomShadow()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func SignInBtnref(_ sender: Any) {
        //        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //       let vc = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        self.movetonextvc(id: "LoginVC", storyBordid: "Main")
        
        
    }
    
    
    @IBAction func ContentAceptBtnref(_ sender: Any){
        if istermsSelected {
            istermsSelected = false
            self.contentAcceptBtnref.setImage(#imageLiteral(resourceName: "CheckBox"), for: .normal)
        }else {
            istermsSelected = true
            self.contentAcceptBtnref.setImage(#imageLiteral(resourceName: "unselectBtn"), for: .normal)
        }
    }
    @IBAction func termaConditionTfref(_ sender: Any){
        if isContentSelected {
            isContentSelected = false
            self.TermaAndConditionTfref.setImage(#imageLiteral(resourceName: "CheckBox"), for: .normal)
        }else {
            isContentSelected = true
            self.TermaAndConditionTfref.setImage(#imageLiteral(resourceName: "unselectBtn"), for: .normal)
        }
    }
    
    @IBAction func SignUpBntref(_ sender: Any) {
//        //        let storyBoard: UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
//        //       let vc = storyBoard.instantiateViewController(withIdentifier: "mainTabvC") as! mainTabvC
//        //        self.navigationController?.pushViewController(vc, animated: true)
//        
//        self.movetonextvc(id: "mainTabvC", storyBordid: "DashBoard")
        
        switch self.RegistrationValidation() {
       case .Success:
           print("done")
           self.Registration()
       case .Error(let errorStr) :
           print(errorStr)
            self.showToast(message: errorStr, font: .systemFont(ofSize: 12.0))
        }
        
    }
    
    @IBAction func forgotPassbtnref(_ sender: Any) {
        
        //        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //       let vc = storyBoard.instantiateViewController(withIdentifier: "ForgotPassVC") as! ForgotPassVC
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        self.movetonextvc(id: "ForgotPassVC", storyBordid: "Main")
        
        
    }
    
}
extension SoldierRegistrationVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == UserNameTfref {
            if (string == " ") {
                return false
            }
        }
        return true
    }
    
    
    func RegistrationValidation()-> ApiCheckValidation {
        //DodidTfref.text ?? "" == "" ||
        if FNametfref.text ?? "" == "" || LnameTfref.text ?? "" == "" ||  GovtEmailAddressTfref.text ?? "" == "" || UserNameTfref.text ?? "" == "" || PasswordTfref.text ?? "" == "" || ConfirmPasswordTfref.text ?? "" == "" {
            return ApiCheckValidation.Error("All feilds are required...")
        }else if let Emailstr = GovtEmailAddressTfref.text,!isValidEmail(Emailstr) {
            return ApiCheckValidation.Error("Please enter Valid Email...")
        }else if let Passstr = PasswordTfref.text,Passstr.count < 6 {
            return ApiCheckValidation.Error("Please enter Valid Password...")
        }else if let Passstr = PasswordTfref.text,let Passstr2 = ConfirmPasswordTfref.text {
            if Passstr != Passstr2 {
                return ApiCheckValidation.Error("Please enter Valid Password...")
            }else {
                return ApiCheckValidation.Success
            }
        }else if self.contentAcceptBtnref.imageView?.image == UIImage(named: "unselectBtn") {
            return ApiCheckValidation.Error("Please check auth info button check!")
        }else if self.contentAcceptBtnref.imageView?.image == UIImage(named: "unselectBtn") {
            return ApiCheckValidation.Error("Please Terms and Conditions button check!")
        } else {
            return ApiCheckValidation.Success
        }
    }
}
extension SoldierRegistrationVC {
   
    
    //MARK:- login func
    func Registration(){
        indicator.showActivityIndicator()
          guard let FName = FNametfref.text else{
            indicator.hideActivityIndicator()
            return}
        guard let Lname = LnameTfref.text else{
            indicator.hideActivityIndicator()
            return}
//        guard let Dodid = DodidTfref.text else{
//            indicator.hideActivityIndicator()
//            return}
        guard let email = GovtEmailAddressTfref.text else{
            indicator.hideActivityIndicator()
            return}
        guard let UserName = UserNameTfref.text else{
            indicator.hideActivityIndicator()
            return}
        guard let password = PasswordTfref.text else{
            indicator.hideActivityIndicator()
            return}
        
        let parameters = [
            "fname":FName,
            "lname":Lname,
            "email":email,
            "username":UserName,
            "password":password,
            "dod_id":"",//Dodid,
            "device_type":"IOS",
            "device_id":UIDevice.current.identifierForVendor!.uuidString,
            "device_token":"3543546854564685451"
        ]
        NetworkManager.Apicalling(url: API_URl.SoldierSignUPURL, paramaters: parameters, httpMethodType: .post, success: { (response:RegisterUserModel) in
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
