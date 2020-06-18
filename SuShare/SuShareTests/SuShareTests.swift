//
//  SuShareTests.swift
//  SuShareTests
//
//  Created by Matthew Ramos on 5/20/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import XCTest
import FirebaseStorage

@testable import SuShare

class SuShareTests: XCTestCase {

   //testing storage image
    func testUploadImageToStorage(){
       
        let exp = XCTestExpectation(description: "suShare photo upload")
        let queryPath = Bundle.main.path(forResource: "createSushare-wPlus", ofType: "png")
        
        guard let path = queryPath else {
            XCTFail("could not access the path")
            return
        }
        
        //act
        guard let jpgData = FileManager.default.contents(atPath: path) else {
            XCTFail("failed because contents inside of path is nil")
            return
        }
        
        let storageRef = FirebaseStorage.Storage.storage().reference()
        let photoRef = storageRef.child("Photo/appLogo")
        
        let metaData = StorageMetadata()
               metaData.contentType = "photo/png"
        
        
        // act
               photoRef.putData(jpgData, metadata: metaData) {
                   (metaData, error) in
                   exp.fulfill()
                   
                   // assert
                   if let error = error {
                       XCTFail("failure to upload video \(error.localizedDescription)")
                   }
                   
                   XCTAssert(true)
               }
                       
               wait(for: [exp], timeout: 10)
                 
           }
    
    
    }
    


