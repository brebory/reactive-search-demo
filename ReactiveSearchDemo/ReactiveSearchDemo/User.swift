//
//  User.swift
//  ReactiveSearchDemo
//
//  Created by Brendon Roberto on 7/11/16.
//  Copyright © 2016 Snackpack Games. All rights reserved.
//

import UIKit

public class User: NSObject {
    class func fromJSON(json: AnyObject!) -> User? {
        guard let dictionary = json as? Dictionary<String, AnyObject>
            else { return nil }

        guard let gender = Gender(rawValue: dictionary["gender"] as? String ?? "")
            else { return nil }

        guard let title = (dictionary["name"] as? Dictionary<String, String> ?? [:])["title"]
            else { return nil }
        guard let first = (dictionary["name"] as? Dictionary<String, String> ?? [:])["first"]
            else { return nil }
        guard let last = (dictionary["name"] as? Dictionary<String, String> ?? [:])["last"]
            else { return nil }

        let name = Name(title: title, first: first, last: last)

        guard let email = dictionary["email"] as? String
            else { return nil }
        
        return User(gender: gender, name: name, email: email)
    }

    public enum Gender: String {
        case Female = "female"
        case Male = "male"
        case Other = "other"
    }

    public struct Name {
        let title: String
        let first: String
        let last: String

        public init(title: String, first: String, last: String) {
            self.title = title
            self.first = first
            self.last = last
        }
    }

    public var gender: Gender
    public var name: Name
    public var email: String

    public init(gender: Gender, name: Name, email: String) {
        self.gender = gender
        self.name = name
        self.email = email
    }

    public convenience init(gender: Gender, title: String, first: String, last: String, email: String) {
        self.init(gender: gender, name: Name(title: title, first: first, last: last), email: email)
    }
}
