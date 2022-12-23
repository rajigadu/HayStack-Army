//
//  LoginVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 12/05/21.
//

import UIKit
enum ApiCheckValidation {
    case Success
    case Error(String)
}
class LoginVC: UIViewController {
    @IBOutlet weak var backViewHeightref: NSLayoutConstraint!
    
    @IBOutlet weak var Passwordtfref: UITextField!
    @IBOutlet weak var Emailtfref: UITextField!

    var UserDataModel : UserModel?
    var SpouseUserDataModel : SpouseUser?
    var SoldierUserDataModel : SoldierUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.backViewHeightref.constant = self.view.frame.height/2  - 35
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
 
    @IBAction func SignInBtnref(_ sender: Any) {
 
      //  self.movetonextvc(id: "mainTabvC", storyBordid: "DashBoard")

        
        switch self.LoginUserValidation() {
       case .Success:
           print("done")
           self.login()
       case .Error(let errorStr) :
           print(errorStr)
            self.showToast(message: errorStr, font: .systemFont(ofSize: 12.0))
        }


    }
    
    
    @IBAction func SignUpBntref(_ sender: Any) {
 
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//       let vc = storyBoard.instantiateViewController(withIdentifier: "RegistrationPickerVC") as! RegistrationPickerVC
//        self.navigationController?.pushViewController(vc, animated: true)
        
        self.movetonextvc(id: "RegistrationPickerVC", storyBordid: "Main")

    }
    
    @IBAction func forgotPassbtnref(_ sender: Any) {
 
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//       let vc = storyBoard.instantiateViewController(withIdentifier: "ForgotPassVC") as! ForgotPassVC
//        self.navigationController?.pushViewController(vc, animated: true)
        
        self.movetonextvc(id: "ForgotPassVC", storyBordid: "Main")

    }
    
}
extension LoginVC{
    func LoginUserValidation()-> ApiCheckValidation {
        if Emailtfref.text ?? "" == "" || Passwordtfref.text ?? "" == ""{
            return ApiCheckValidation.Error("Please enter your credentials...")
//        }else if let Emailstr = Emailtfref.text,!isValidEmail(Emailstr) {
//            return ApiCheckValidation.Error("Please enter Valid Email...")
        }else if let Passstr = Passwordtfref.text,Passstr.count < 6 {
            return ApiCheckValidation.Error("Please enter Valid Password...")
        }else {
            return ApiCheckValidation.Success
        }
    }
}
extension LoginVC {
   
    
    //MARK:- login func
    func login(){
        indicator.showActivityIndicator()
        guard let email = Emailtfref.text else{
            indicator.hideActivityIndicator()
            return}
        guard let password = Passwordtfref.text else{
            indicator.hideActivityIndicator()
            return}
        
        let parameters = [
            "username":email,
            "password":password,
            "device_type":"IOS",
            "device_id":UIDevice.current.identifierForVendor!.uuidString,
            "device_token":newDeviceId
        ]
        NetworkManager.Apicalling(url: API_URl.LogINURL, paramaters: parameters, httpMethodType: .post, success: { (response:UserModel) in
            print(response.data)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                if response.lognied_User == "Soldier"{
                    LognedUserType = response.lognied_User ?? "Soldier"
                    UserDefaults.standard.set(response.lognied_User, forKey: "LoginedUserType")
                    self.UserDataModel = response
                    UserDefaults.standard.set(true, forKey: "IsUserLogined")
                    self.SoldierUserDataModel = response.data?.soldier
                    UserDefaults.standard.set(self.SoldierUserDataModel?.id, forKey: "SoldierId")
                  
                    UserDefaults.standard.set(self.SoldierUserDataModel?.fname, forKey: "Soldierfname")
                    UserDefaults.standard.set(self.SoldierUserDataModel?.lname, forKey: "Soldierlname")
                    UserDefaults.standard.set(self.SoldierUserDataModel?.govt_email, forKey: "SoldierGovt_email")
                    UserDefaults.standard.set(self.SoldierUserDataModel?.username, forKey: "SoldierUsername")
                    UserDefaults.standard.set(self.SoldierUserDataModel?.dod_id, forKey: "SoldierDod_id")
                    
                }else {
                    LognedUserType = response.lognied_User ?? "Spouse"
                    UserDefaults.standard.set(response.lognied_User, forKey: "LoginedUserType")
                    self.SpouseUserDataModel = response.data?.spouse
                    UserDefaults.standard.set(true, forKey: "IsUserLogined")
                     //Spouse
                    UserDefaults.standard.set(self.SpouseUserDataModel?.id, forKey: "SpouseId")
                    UserDefaults.standard.set(self.SpouseUserDataModel?.sub_id, forKey: "SpouseSubId")
                    UserDefaults.standard.set(self.SpouseUserDataModel?.fname, forKey: "Spousefname")
                    UserDefaults.standard.set(self.SpouseUserDataModel?.lname, forKey: "Spouselname")
                    UserDefaults.standard.set(self.SpouseUserDataModel?.sponsors_govt_email, forKey: "SpouseSponsors_govt_email")
                    UserDefaults.standard.set(self.SpouseUserDataModel?.username, forKey: "SpouseUserName")
                    UserDefaults.standard.set(self.SpouseUserDataModel?.sponsor_id, forKey: "SpouseSponsor_id")
                    UserDefaults.standard.set(self.SpouseUserDataModel?.relation_to_sm, forKey: "SpouseRelation_to_sm")
                    //Soldier
                    self.SoldierUserDataModel = response.data?.soldier
                    UserDefaults.standard.set(self.SoldierUserDataModel?.id, forKey: "SoldierId")
                    UserDefaults.standard.set(self.SoldierUserDataModel?.fname, forKey: "Soldierfname")
                    UserDefaults.standard.set(self.SoldierUserDataModel?.lname, forKey: "Soldierlname")
                    UserDefaults.standard.set(self.SoldierUserDataModel?.govt_email, forKey: "SoldierGovt_email")
                    UserDefaults.standard.set(self.SoldierUserDataModel?.username, forKey: "SoldierUsername")
                    UserDefaults.standard.set(self.SoldierUserDataModel?.dod_id, forKey: "SoldierDod_id")
                }
 
                //self.movetonextvc(id: "mainTabvC", storyBordid: "DashBoard")
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                var navigation = UINavigationController()
                let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
                let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "mainTabvC") as! mainTabvC
                appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
                    navigation = UINavigationController(rootViewController: initialViewControlleripad)
              
                appDelegate.window?.rootViewController = navigation
                appDelegate.window?.makeKeyAndVisible()

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
