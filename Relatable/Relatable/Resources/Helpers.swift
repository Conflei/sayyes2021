//
//  Helpers.swift
//  Relatable
//
//  Created by Felix Izarra on 10/2/21.
//

import Foundation
import Photos

extension PHAsset {

    func getURL(originalFilename: String = "", completionHandler : @escaping ((_ originalFilename : String, _ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.isNetworkAccessAllowed = true
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(originalFilename, contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            options.isNetworkAccessAllowed = true
            
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    //print("WORKED: \(self) asset: \(asset?.debugDescription ?? "nil")")
                    let localVideoUrl: URL = urlAsset.url as URL
                    
                    completionHandler(originalFilename, localVideoUrl)
                } else {
                    //print("DIDN'T WORK: \(self) asset: \(asset?.debugDescription ?? "nil")")
                    completionHandler(originalFilename, nil)
                }
            })
        }
    }
    
   
}
