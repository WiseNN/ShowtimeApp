
import UIKit

let isMain = false
typealias DownloaderCH = (URL?) -> ()

class Downloader: NSObject {
    let config : URLSessionConfiguration
    let dispatchq = DispatchQueue.global(qos:.background)
    let queue : OperationQueue = {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 1
        return q
    }()
   
    lazy var session : URLSession = {
        let queue = (isMain ? .main : self.queue)
        return URLSession(configuration:self.config, delegate:DownloaderDelegate(), delegateQueue:queue)
    }()
    init(configuration config:URLSessionConfiguration) {
        self.config = config
        super.init()
        print("printing on main thread")
    }
    
    @discardableResult
    func download(url:URL, completionHandler ch : @escaping DownloaderCH) -> URLSessionTask {
        let task = self.session.downloadTask(with:url)
        let del = self.session.delegate as! DownloaderDelegate
        //comm with DownloaderDelegate on its own queue
        self.session.delegateQueue.addOperation {
            del.appendHandler(ch, task: task)
        }
        
        //resume/return task immediately
        //no delegate msgs can arrive until affter appendHandler executs
        task.resume()
        return task
    }
    
    private class DownloaderDelegate : NSObject, URLSessionDownloadDelegate {
        private var handlers = [Int:DownloaderCH]()
        func appendHandler(_ ch:@escaping DownloaderCH, task:URLSessionTask) {
            print("adding completion for task \(task.taskIdentifier)")
            self.handlers[task.taskIdentifier] = ch
        }
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo url: URL) {
            print("finished download for task \(downloadTask.taskIdentifier)")
            let ch = self.handlers[downloadTask.taskIdentifier]
            if isMain {
                ch?(url)
            } else {
                DispatchQueue.main.sync {
                    ch?(url)
                }
            }
        }
        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            print("removing completion for task \(task.taskIdentifier)")
            // if error != nil { self.handlers[task.taskIdentifier]?(nil) }
            let ch = self.handlers[task.taskIdentifier]
            self.handlers[task.taskIdentifier] = nil
            
            // return nil if we get error
            if let error = error
            {
                print("error?", error)
                if isMain
                {
                    ch?(nil)
                }
                else
                {
                    DispatchQueue.main.sync {
                        ch?(nil)
                    }
                }
            }
        }
        deinit {
            print("bye from Delegate", self.handlers.count)
        }
    }
    
    
    //    func cancelAllTasks() {
    //        self.session.invalidateAndCancel()
    //    }
    
    deinit {
        print("bye from Downloader")
        self.session.invalidateAndCancel()
    }
    
}

