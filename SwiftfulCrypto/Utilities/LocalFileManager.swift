//
//  LocalFileManager.swift
//  SwiftfulCrypto
//
//  Created by Pavan Mikkilineni on 31/01/22.
//

import Foundation
import UIKit

class LocalFileManager{
    static let instance = LocalFileManager()
    private init(){}
    
    func saveImage(image:UIImage,imageName:String,folderName:String){
        
        createFolderIfNeeded(folderName: folderName)
        
        guard let data = image.pngData(),
              let url = getURLForImage(imageName: imageName, folderName: folderName)
        else{return}
        
        do{
            try data.write(to: url)
        }catch let err{
            print("Error Saving Image... \(err.localizedDescription)")
        }
    }
    
    func getImage(imageName:String,folderName:String)->UIImage?{
        guard let url = getURLForImage(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path)
        else{return nil}
        return UIImage(contentsOfFile: url.path)
        
    }
    
    private func createFolderIfNeeded(folderName:String){
        guard let url = getURLForFolder(folderName: folderName)
        else{return}
        if !FileManager.default.fileExists(atPath: url.path){
            do{
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            }catch let err{
                print("Error creating directory... \(err.localizedDescription)")
            }
        }
    }
    
    private func getURLForFolder(folderName:String)->URL?{
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(folderName)
        else{return nil}
        return url
    }
    
    private func getURLForImage(imageName:String,folderName:String)->URL?{
        guard let url = getURLForFolder(folderName:folderName)?.appendingPathComponent(imageName+".png")
        else{return nil}
        return url
    }
}
