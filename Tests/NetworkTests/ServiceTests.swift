//
//  File.swift
//  
//
//  Created by Iván Galaz Jeria on 01-05-21.
//

import XCTest
@testable import Network
import Hippolyte
import RxSwift

final class ServiceTests: XCTestCase {
    
    func test_load() {
        let disposeBag = DisposeBag()
        let url = URL(string: "https://dequin.cl")!
        var stub = StubRequest(method: .GET, url: url)
        var response = StubResponse()
        let path = Bundle.module.path(forResource: "sample", ofType: "json")!
        response.body = NSData(contentsOfFile: path)! as Data
        stub.response = response
        Hippolyte.shared.add(stubbedRequest: stub)
        Hippolyte.shared.start()
        
        let expectation = self.expectation(description: #fileID)
        let resource = Resource<SampleModel>(url: URL(string: "https://dequin.cl")!)
        APIService.load(resource: resource)
            .materialize()
            .subscribe(onNext: { event in
                expectation.fulfill()
                XCTAssertNotNil(event)
            })
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 2)
    }
}
