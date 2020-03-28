//
//  NetworkEngine.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 25/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Alamofire

typealias CompletionWithSuccessOrFailure = (_ state: ResponseState) -> Void
typealias ResponseState = Result<Any, NetworkError>

class NetworkEngine {
    
    /*
     
     Parameters
     
     T :- generic type it should confirm to URLBuildable protocol
     U :- generic type it should confirm to Parser protocol
     parser :- It will be Any type confirmed to Parser protocol, used for parsing the response in seperate class
     buildable : - It will be Any type confirmed to URLBuildable protocol. It will provide HTPP request parametes
     completion : - Call back with success or failure cases
     
     */
    
    final func fetch<T: URLBuildable, U: Parser > (_ buildable: T,
                                                   _ parser: U.Type,
                                                   _ completion: @escaping CompletionWithSuccessOrFailure) {
        if let topVc = UIApplication.topViewController(),
                   !topVc.isKind(of: UIAlertController.self) {
                   CommonLoader.showSpinner()
        }
        AF.request(buildable)
            .validate()
            .responseJSON {  (response) in
                CommonLoader.hideSpinner()
                switch response.result {
                case .success(let value):
                    self.getValue(parser, response: value, completion: completion)
                case .failure(let error):
                    completion(.failure(.otherError(error: error.localizedDescription)))
                }
        }
    }
    
    
    /*
     Parameters
     T :- generic type
     parser : - Parser class
     response : - Response recieved from request
     completion: Call back
     
     */
    private func getValue<T: Parser>(_ parser: T.Type, response: Any, completion: CompletionWithSuccessOrFailure) {
        if let parameters = response as? Parameters {
            self.parse(parser, parametes: parameters, completion: completion)
        } else {
            completion(.failure(.invalidResponse))
        }
    }
    
    /*
     Parameters
     T :- generic type
     parser : - Parser class
     parametes : - response in [String:Any] format
     */
    private func parse<T: Parser>(_ parser: T.Type,
                                  parametes: Parameters,
                                  completion: CompletionWithSuccessOrFailure) {
        let parsingStauts = T.parse(parametes)
        switch parsingStauts {
        case .success(let value):
            completion(.success(value))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
