//
//  CedroTests.swift
//  CedroTests
//
//  Created by Everton Miranda Vitório on 02/05/18.
//  Copyright © 2018 Everton Miranda Vitório. All rights reserved.
//

import XCTest
@testable import CedroProva

class CedroTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //Testa se a validação de senha está funcionando
    func testPasswordRegex(){
        XCTAssertTrue(RegexValidator.isValidPassword(testStr: "AAAA@@1122"))
        XCTAssertFalse(RegexValidator.isValidPassword(testStr: "aboBoR@"))
    }
    
    //Testa se a validação do e-mail está funcionando
    func testEmailRegex(){
        XCTAssertTrue(RegexValidator.isValidEmail(testStr: "everton@email.com"))
        XCTAssertFalse(RegexValidator.isValidEmail(testStr: "everton@email."))
    }
    
    //Testa se a validação de url está funcionando
    func testURLRegex(){
        XCTAssertTrue(RegexValidator.isValidURL(testStr: "www.cedrotech.com"))
        XCTAssertTrue(RegexValidator.isValidURL(testStr: "cedrotech.com"))
        XCTAssertFalse(RegexValidator.isValidURL(testStr: "www.cedrotech."))
        XCTAssertFalse(RegexValidator.isValidURL(testStr: "cedrotech"))
        XCTAssertTrue(RegexValidator.isValidURL(testStr: "https://cedrotech.com"))
        XCTAssertTrue(RegexValidator.isValidURL(testStr: "http://cedrotech.com"))
    }
    
    
    
}
