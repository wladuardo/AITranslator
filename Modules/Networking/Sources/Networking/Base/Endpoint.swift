//
//  File.swift
//  
//
//  Created by Владислав Ковальский on 22.06.2023.
//

import Foundation

public protocol HTTPEndpoint {
    var url: URL? { get }
    var method: HTTPRequestMethods { get }
    var header: HTTPHeaders? { get }
    var body: HTTPBody { get }
}



public protocol HTTPEndpointConfigurable: HTTPEndpoint {
    var queryItems: [URLQueryItem]? { get }
    var path: String { get }
}

