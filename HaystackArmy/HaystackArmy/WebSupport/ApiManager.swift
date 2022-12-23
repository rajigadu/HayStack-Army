//
//  ApiManager.swift
//  DeltaServices
//
//  Created by rajesh gandru on 01/05/21.
//

import Foundation
import CoreLocation
import GoogleMaps
import Alamofire
import ObjectMapper

enum DataNotFound:Error {
    case dataNotFound
}

typealias successs = (Data)-> Void
typealias failure = (Any)-> Void
typealias Response = [String:Any]
var AccessToken = String()


func header()->HTTPHeaders{
    let bearerToken = UserDefaults.standard.string(forKey:"Accesstoken") ?? ""
    var headerMessage :HTTPHeaders!
    if bearerToken != ""{
        headerMessage = [
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization":"Bearer \(bearerToken)"]
        
    }else{
        headerMessage = [
            "Content-Type":"application/x-www-form-urlencoded","Accept":"application/json" ]
    }
    return headerMessage
}

class NetworkManager{
    var alamoFireManager : SessionManager?
    private init(){}
    
    static  var alamoFireManager : SessionManager?
    
    
    
    static func Apicalling<T:Mappable>(
        url:String,
        paramaters:Response = [:],
        httpMethodType:HTTPMethod = .post ,
        success:@escaping(T)-> () ,
        failure: @escaping failure)
    {
        if Connectivity.isNotConnectedToInternet{
            failure("No Internet,Please Check")
        }
        guard let httpMethod = HTTPMethod(rawValue: httpMethodType.rawValue) else{
            assertionFailure("OOPS !!! HTTP Method Not Found \(httpMethodType)")
            return
        }
        print(" ---------- T ** Model  ---------- \n ","\(T.self)")
        print(" ---------- HTTP Method  ---------- \n",httpMethod)
        print(" ----------  URL  ---------- \n",url)
        print(" ---------- parameters  ---------- \n",paramaters)
        print(" ---------- Header  ---------- \n",header())
        
        let configuration = URLSessionConfiguration.default
        alamoFireManager = Alamofire.SessionManager(configuration: configuration)
        alamoFireManager?.request(url, method: httpMethod, parameters: paramaters, encoding:  URLEncoding.default, headers: header()).responseJSON { (response) in
            print(response.response?.statusCode as Any)
            switch response.result{
            case .success(let value):
                guard let responseDict = value as? Response else{return}
                print(" ---------- responseDict  ---------- \n",responseDict)
                guard let item = Mapper<T>.init().map(JSON: responseDict) else{
                    if let error = response.result.error{
                        failure(error)
                    }
                    return
                }
                print(" ---------- MODEL  ---------- \n",item)
                guard let statusCode = response.response?.statusCode,statusCode == 200 else{
                    if let errorMessage = responseDict["message"] as? String{
                        failure(errorMessage)
                    }
                    return
                }
                success(item)
            case .failure(let error):
                failure(error)
            }
        }.session.finishTasksAndInvalidate()
    }
    
    
}
class NetworkManager2{
    var alamoFireManager : SessionManager?
    private init(){}
    
    static  var alamoFireManager : SessionManager?
    
    
    
    static func Apicalling<T:Mappable>(
        url:String,
        paramaters:Response = [:],
        ImageData:Data?,
        httpMethodType:HTTPMethod = .post ,
        success:@escaping(T)-> () ,
        failure: @escaping failure)
    {
        if Connectivity.isNotConnectedToInternet{
            failure("No Internet,Please Check")
        }
        guard let httpMethod = HTTPMethod(rawValue: httpMethodType.rawValue) else{
            assertionFailure("OOPS !!! HTTP Method Not Found \(httpMethodType)")
            return
        }
        print(" ---------- T ** Model  ---------- \n ","\(T.self)")
        print(" ---------- HTTP Method  ---------- \n",httpMethod)
        print(" ----------  URL  ---------- \n",url)
        print(" ---------- parameters  ---------- \n",paramaters)
        print(" ---------- Header  ---------- \n",header())
        
        let configuration = URLSessionConfiguration.default
        alamoFireManager = Alamofire.SessionManager(configuration: configuration)
        alamoFireManager?.upload(multipartFormData: { (multipartFormData) in
                 for (key, value) in paramaters {
                     multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                 }

                 if let data = ImageData {
                    // multipartFormData.append(data, withName: "image", fileName: "image", mimeType: "image/png")
                    multipartFormData.append(data, withName: "image",fileName: "image.jpg", mimeType: "image/jpg")

                    
                  //  multipartFormData.append(data, withName: "file", fileName: "image", mimeType: "image/jpeg")


                 }

             }, usingThreshold: UInt64.init(), to: url, method: .post) { (result) in
            switch result{
                 case .success(let upload, _, _):
                     upload.responseJSON { response in
                         print("Succesfully uploaded  = \(response)")
                         if let err = response.error{
                              print(err)
                            failure(err)
                              
                         }

                        
                        guard let responseDict = response.value as? Response else{return}
                        print(" ---------- responseDict  ---------- \n",responseDict)
                        guard let item = Mapper<T>.init().map(JSON: responseDict) else{
                            if let error = response.result.error{
                                failure(error)
                            }
                            return
                        }
                        print(" ---------- MODEL  ---------- \n",item)
                        guard let statusCode = response.response?.statusCode,statusCode == 200 else{
                            if let errorMessage = responseDict["message"] as? String{
                                failure(errorMessage)
                            }
                            return
                        }
                        success(item)

                     }
                 case .failure(let error):
                     print("Error in upload: \(error.localizedDescription)")
                    failure(error)
                 }
             }
        
//        alamoFireManager?.request(url, method: httpMethod, parameters: paramaters, encoding:  URLEncoding.default, headers: header()).responseJSON { (response) in
//            print(response.response?.statusCode as Any)
//            switch response.result{
//            case .success(let value):
//                guard let responseDict = value as? Response else{return}
//                print(" ---------- responseDict  ---------- \n",responseDict)
//                guard let item = Mapper<T>.init().map(JSON: responseDict) else{
//                    if let error = response.result.error{
//                        failure(error)
//                    }
//                    return
//                }
//                print(" ---------- MODEL  ---------- \n",item)
//                guard let statusCode = response.response?.statusCode,statusCode == 200 else{
//                    if let errorMessage = responseDict["message"] as? String{
//                        failure(errorMessage)
//                    }
//                    return
//                }
//                success(item)
//            case .failure(let error):
//                failure(error)
//            }
//        }.session.finishTasksAndInvalidate()
    }
    
    
}


