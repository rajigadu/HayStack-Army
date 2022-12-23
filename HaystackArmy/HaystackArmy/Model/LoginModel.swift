//
//  LoginModel.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 13/05/21.
//

import Foundation
import UIKit
import ObjectMapper


class UserModel:Codable,Mappable {
    var data : UserModelData?
    var status : String?
    var message : String?
    var lognied_User : String?
    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {
         data <- map["data"]
        status <- map["status"]
        message <- map["message"]
        lognied_User <- map["lognied_User"]
    }
}

class SoldierUser : Codable,Mappable {
    var id : String?
    var fname : String?
    var lname : String?
    var govt_email : String?
    var username : String?
    var dod_id : String?

    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {

        id <- map["id"]
        fname <- map["fname"]
        lname <- map["lname"]
        govt_email <- map["govt_email"]
        username <- map["username"]
        dod_id <- map["dod_id"]
    }

}

class UserModelData : Codable,Mappable {
    var soldier : SoldierUser?
    var spouse : SpouseUser?

    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {

        soldier <- map["soldier"]
        spouse <- map["spouse"]
    }

}

class SpouseUser : Codable,Mappable {
    var id : String?
    var sub_id : String?
    var fname : String?
    var lname : String?
    var sponsors_govt_email : String?
    var username : String?
    var sponsor_id : String?
    var relation_to_sm : String?

    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {

        id <- map["id"]
        sub_id <- map["sub_id"]
        fname <- map["fname"]
        lname <- map["lname"]
        sponsors_govt_email <- map["sponsors_govt_email"]
        username <- map["username"]
        sponsor_id <- map["sponsor_id"]
        relation_to_sm <- map["relation_to_sm"]
    }

}



class RegisterUserModel:Codable,Mappable {
    var status  = ""
    var message = ""
    var uid = ""
    required init?(map: Map) {}
    init() {}
    func mapping(map: Map) {
        status <- map ["status"]
        message <- map ["message"]
        uid <- map ["uid"]
    }
}

