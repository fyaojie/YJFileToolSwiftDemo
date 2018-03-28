//
//  YJFileToolSwift.swift
//  YJFileToolSwiftDemo
//
//  Created by o dream boy on 2018/3/27.
//  Copyright © 2018年 child. All rights reserved.
//

import Foundation

class YJFileToolSwift: NSObject {
    
    // MARK:- 获取项目名称
    /// 获取项目名称
    @discardableResult
    class func yj_getProjectName() -> String {
        guard let infoDictionary = Bundle.main.infoDictionary else {
            return "unknown"
        }
        
        guard let projectName = infoDictionary[String(kCFBundleExecutableKey)] as? String else {
            return "unknown"
        }
        
        return  projectName
    }
    
    // MARK:- 返回缓存根目录 "caches"
    /// 返回缓存根目录 "caches"
    @discardableResult
    class func yj_getCachesDirectory() -> String {
        
        guard let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return "error"
        }
        
        return cachesPath + "/" + yj_getProjectName();
    }
    
    // MARK:- 根目录路径 "document"
    ///返回根目录路径 "document"
    @discardableResult
    class func yj_getDocumentPath() -> String {
        guard let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return "error"
        }
        
        return documentPath + "/" + yj_getProjectName();
    }
    
    // MARK:- 判断文件是否存在
    /// 判断文件是否存在
    @discardableResult
    class func yj_isExist(atPath filePath : String) -> Bool {
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    // MARK:- 创建文件目录
    /// 创建文件目录
    @discardableResult
    class func yj_creatDir(atPath dirPath : String) -> Bool {
        
        if yj_isExist(atPath: dirPath) {
            return false
        }
        
        do {
            try FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    // MARK:- 删除文件 或者目录
    /// 删除文件 或者目录
    @discardableResult
    class func yj_delete(atPath filePath : String) -> Bool {
        guard yj_isExist(atPath: filePath) else {
            return false
        }
        do {
            try FileManager.default.removeItem(atPath: filePath)
            return true
        } catch  {
            print(error)
            return false
        }
    }
    
    // MARK:- 移动文件夹
    ///移动文件夹
    @discardableResult
    class func yj_moveDir(atPath srcPath : String, toPath desPath : String) -> Bool {
        do {
            try FileManager.default.moveItem(atPath: srcPath, toPath: desPath)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    // MARK:- 创建文件
    ///创建文件
    @discardableResult
    class func yj_creatFile(atPath filePath : String, data : Data) -> Bool {
        return FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
    }
    
    // MARK:- 通过文件路径读取文件
    ///通过文件路径读取文件
    @discardableResult
    class func yj_readDataFile(atPath filePath : String) -> Data? {
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath), options: Data.ReadingOptions.mappedIfSafe) else {
            return nil
        }
        return data
    }
    
    // MARK:- 通过文件名读取文件
    ///通过文件名读取文件
    @discardableResult
    class func yj_readDataFile(atName fileName : String) -> Data? {
        return yj_readDataFile(atPath: yj_getFilePath(fileName))
    }
    
    // MARK:- 获取文件路径
    /// 获取文件路径
    @discardableResult
    class func yj_getFilePath(_ fileName : String) -> String {
        return yj_getDocumentPath() + "/" + fileName
    }
    
    // MARK:- 文件写入
    /// 文件写入
    @discardableResult
    class func yj_writeDataToFile(_ fileName : String,data : Data) -> Bool {
        return yj_creatFile(atPath: yj_getFilePath(fileName), data: data)
    }
    
    // MARK:- 获取单个文件的大小
    /// 获取单个文件的大小
    @discardableResult
    class func yj_getFileSize(atPath filePath : String) -> Float {
        guard yj_isExist(atPath: filePath) else {
            return 0
        }
        
        guard let dict = try? FileManager.default.attributesOfItem(atPath: filePath) as NSDictionary else {
            return 0
        }
        
        return Float(dict.fileSize())
    }
    
    // MARK:- 遍历文件夹获取目录下的所有的文件 遍历计算大小
    /// 遍历文件夹获取目录下的所有的文件 遍历计算大小
    @discardableResult
    class func yj_folderSizeAtPath(folderPath:String) -> Float
    {
        if folderPath.count == 0 {
            return 0
        }
        
        guard yj_isExist(atPath: folderPath) else {
            return 0
        }
        
        var fileSize:Float = 0.0
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: folderPath)
            for file in files {
                let path = yj_getDocumentPath() + "/\(file)"
                fileSize = fileSize + yj_getFileSize(atPath: path)
            }
        }   catch{
        }
        
        return fileSize/(1000.0*1000.0)
    }
    
    // MARK:- 遍历文件，删除文件夹下的所有文件
    /// 遍历文件，删除文件夹下的所有文件
    class func yj_folderDelete(folderPath:String) {
        guard yj_isExist(atPath: folderPath) else {
            return
        }
        guard let childFilePaths = FileManager.default.subpaths(atPath: folderPath) else {
            return
        }
        
        for path in childFilePaths {
            self.yj_delete(atPath: folderPath + path)
        }
    }
    
    // MARK:- 读取缓存文件大小
    /// 读取缓存文件大小
    @discardableResult
    class func yj_readCacheSize() -> String {
        return String(format: "%.2f", self.yj_folderSizeAtPath(folderPath: NSHomeDirectory()))
    }
    
    // MARK:- 清除项目下的所有缓存
    /// 清除项目下的所有缓存
    
    class func yj_cleanCache() {
        yj_folderDelete(folderPath: NSHomeDirectory())
    }
}
