//
//  FileDownloader.swift
//  one
//
//  Created by sidney on 2021/7/10.
//

import Foundation

protocol FileDownloadDelegate: class {
    func updateDownloadProgress(progress: Float, urlStr: String)
    func downloadSuccess(location: URL, urlStr: String)
    func downloadFail(error: Error, urlStr: String)
}


class FileDownloader: NSObject, URLSessionDownloadDelegate {
    
    private weak var delegate: FileDownloadDelegate?
    
    static func getFolder(urlStr: String) -> String {
        if urlStr.hasSuffix(".mp3") || urlStr.hasSuffix(".m4a") || urlStr.hasSuffix("wav") {
            return "music"
        }
        return "movie"
    }
    
    static func getFileUrl(originUrlStr: String) -> URL {
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let musicFolder = documentsDirectoryURL.appendingPathComponent(FileDownloader.getFolder(urlStr: originUrlStr))
        let destinationUrl = musicFolder.appendingPathComponent(URL(string: originUrlStr)!.lastPathComponent)
        return destinationUrl
    }
    
    func saveFile(originUrlStr: String, location: URL) {
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let musicFolder = documentsDirectoryURL.appendingPathComponent(FileDownloader.getFolder(urlStr: originUrlStr))
        let destinationUrl = musicFolder.appendingPathComponent(URL(string: originUrlStr)!.lastPathComponent)
        print("下载成功：\(originUrlStr), 本地tmp路径是：\(location.absoluteString), document路径：\(destinationUrl.absoluteString)")
        do {
            try FileManager.default.createDirectory(at: musicFolder, withIntermediateDirectories: true, attributes: nil)
            try FileManager.default.moveItem(at: location, to: destinationUrl)
            print("文件由tmp移动至指定文件夹成功！")
            Storage.mediaCache[originUrlStr] = destinationUrl.absoluteString
            DispatchQueue.main.async {
                self.delegate?.downloadSuccess(location: location, urlStr: originUrlStr)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let originUrlStr = session.configuration.identifier else { return }
        self.saveFile(originUrlStr: originUrlStr, location: location)
        DispatchQueue.main.async {
            self.delegate?.downloadSuccess(location: location, urlStr: originUrlStr)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error = error else {
            return
        }
        DispatchQueue.main.async {
            self.delegate?.downloadFail(error: error, urlStr: session.configuration.identifier ?? "")
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            self.delegate?.updateDownloadProgress(progress: Float(totalBytesWritten) / Float(totalBytesExpectedToWrite), urlStr: session.configuration.identifier ?? "")
        }
    }
    
    func download(urlStr: String, delegate: FileDownloadDelegate) {
        guard let url = URL(string: urlStr) else {
            print("url is invalid")
            return
        }
        self.delegate = delegate
        let sessionConfig = URLSessionConfiguration.background(withIdentifier: urlStr)
        let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        let task = session.downloadTask(with: url)
        task.resume()
    }
    
    
    
}
