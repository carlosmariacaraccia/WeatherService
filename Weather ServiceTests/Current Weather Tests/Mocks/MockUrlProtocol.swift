//
//  MockUrlProtocol.swift
//  OpenWeatherAppTests
//
//  Created by Carlos Caraccia on 3/29/21.
//

import Foundation


class MockUrlProtocol:URLProtocol {
    
    static var stubResponseData:Data?
    static var stubResponseError:Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let data = MockUrlProtocol.stubResponseData {
            self.client?.urlProtocol(self, didLoad: data)
        } else {
            self.client?.urlProtocol(self, didFailWithError: MockUrlProtocol.stubResponseError ?? NSError(domain: "", code: -1, userInfo: nil))
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
    
}
