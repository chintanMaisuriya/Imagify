import UIKit

// MARK: -

typealias ImageDownloadHandler = (_ image: UIImage?, _ url: URL?, _ indexPath: IndexPath?, _ error: Error?) -> Void

// MARK: -

final class ImageDownloadManager {
        
    static let shared = ImageDownloadManager()
    private var completionHandler: ImageDownloadHandler?
    private let imageCache = NSCache<NSString, UIImage>()
    
    private lazy var imageDownloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.test.imageDownloadqueue"
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    // MARK: -
    
    private init () {}
    
    // MARK: -
    
    func downloadImage(_ imageURL: String?, indexPath: IndexPath?, handler: @escaping ImageDownloadHandler) {
        completionHandler = handler
        guard let url = URL(string: imageURL ?? "") else { return }
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            /* check for the cached image for url, if YES then return the cached image */
            // debugPrint("Return cached Image for \(url)")
            completionHandler?(cachedImage, url, indexPath, nil)
            
        } else {
            /* check if there is a download task that is currently downloading the same image. */
            if let operations = (imageDownloadQueue.operations as? [ImageDownloadOperation])?
                .filter({$0.imageUrl.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true }),
               let operation = operations.first {
                // debugPrint("Increase the priority for \(url)")
                operation.queuePriority = .veryHigh
                
            }else {
                /* create a new task to download the image.  */
                // debugPrint("Create a new task for \(url)")
                let operation = ImageDownloadOperation(url: url, indexPath: indexPath)
                if indexPath == nil {
                    operation.queuePriority = .high
                }
                
                operation.downloadHandler = { [weak self] (image, url, indexPath, error) in
                    if let newImage = image, let url = url {
                        self?.imageCache.setObject(newImage, forKey: url.absoluteString as NSString)
                    }
                    
                    self?.completionHandler?(image, url, indexPath, error)
                }
                
                imageDownloadQueue.addOperation(operation)
            }
        }
    }
    
    /* FUNCTION to reduce the priority of the network operation in case the user scrolls and an image is no longer visible. */
    func slowDownImageDownloadTaskfor (_ imageURL: String?) {
        guard let url = URL(string: imageURL ?? "") else { return }
        
        if let operations = (imageDownloadQueue.operations as? [ImageDownloadOperation])?
            .filter({$0.imageUrl.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true }),
           let operation = operations.first {
            // debugPrint("Reduce the priority for \(url)")
            operation.queuePriority = .low
        }
    }
    
    func cancelAll() {
        imageDownloadQueue.cancelAllOperations()
    }
}
