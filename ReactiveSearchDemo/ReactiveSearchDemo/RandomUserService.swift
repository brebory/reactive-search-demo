//
//  RandomUserService.swift
//  ReactiveSearchDemo
//
//  Created by Brendon Roberto on 7/11/16.
//  Copyright © 2016 Snackpack Games. All rights reserved.
//

import UIKit
import Alamofire
import ReactiveCocoa

public class RandomUserService: NSObject { 

    private class Errors {
        static let Domain = "com.snackpack.reactivesearchdemo.randomuserservice"

        private class JSONParsing {
            static let Message = "There was an error parsing the JSON response."
            static let Code = 101
        }

        private class Operation {
            static let Message = "There was an error completing the operation."
            static let Code = 102
        }
    }

    private class Constants {
        static let BaseURLString = "https://api.randomuser.me/"
        static let ResultsParameterKey = "results"
    }

    private class var JSONParseError: NSError {
        return NSError(domain: Errors.Domain,
                       code: Errors.JSONParsing.Code,
                       userInfo: [NSLocalizedDescriptionKey: Errors.JSONParsing.Message])
    }

    private class var operationError: NSError {
        return NSError(domain: Errors.Domain,
                       code: Errors.Operation.Code,
                       userInfo: [NSLocalizedDescriptionKey: Errors.Operation.Message])
    }

    public func getUsers(count: Int) -> SignalProducer<[User], NSError> {
        let producer = SignalProducer<NSArray, NSError> { [weak self] observer, disposable in

            guard let strongSelf = self
                else { return observer.sendFailed(RandomUserService.operationError) }

            let request = strongSelf.getUsersRequest(count)

            request.responseJSON { response in
                switch response.result {

                case .Success(let json):

                    guard let results = (json as? NSDictionary)?[Constants.ResultsParameterKey] as? NSArray
                        else { return observer.sendFailed(RandomUserService.JSONParseError) }

                    observer.sendNext(results)
                    observer.sendCompleted()

                case .Failure(let error):
                    observer.sendFailed(error)
                }
            }

            disposable.addDisposable { [request] in
                request.cancel()
            }
        }

        return producer.flatMap(.Latest) { results -> SignalProducer<[User], NSError> in

            let filteredResults = results.map { json in
                return User.fromJSON(json)
            }.flatMap { $0 }

            return SignalProducer<[User], NSError>(value: filteredResults)
        }
    }

    private func getUsersRequest(count: Int) -> Alamofire.Request {
        return Alamofire.request(.GET,
                                 Constants.BaseURLString,
                                 parameters: [Constants.ResultsParameterKey : count],
                                 encoding: .URL,
                                 headers: nil)
    }
}