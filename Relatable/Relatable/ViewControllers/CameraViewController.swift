//
//  CameraViewController.swift
//  Relatable
//
//  Created by Felix Izarra on 10/2/21.
//

import UIKit
import NextLevel
import AVKit
import Photos

class CameraViewController: BaseViewController{
    
    var previewView: UIView?
    
    @IBOutlet weak var buttonAction: UIButton!
    
    var recording: Bool = false
    
    var lastURL: URL = URL(fileURLWithPath: "")
    var mirrored : Bool = false
    var comingFromPlayback: Bool = false
    var urlToSave: String = ""
    
    @IBOutlet weak var confirmationView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NextLevel.shared.delegate = self
        NextLevel.shared.deviceDelegate = self
        NextLevel.shared.videoDelegate = self
        

        // modify .videoConfiguration, .audioConfiguration, .photoConfiguration properties
        // Compression, resolution, and maximum recording time options are available
        NextLevel.shared.videoConfiguration.maximumCaptureDuration = CMTimeMakeWithSeconds(5, preferredTimescale: 600)
        NextLevel.shared.audioConfiguration.bitRate = 44000
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        checkAuthAndStart()
       refreshFeed()
    }
    
    @objc func rotated() {
        
        refreshFeed()
    }
    
    public func refreshFeed()
    {
        DispatchQueue.main.async {
        self.previewView?.removeFromSuperview()
        
        self.previewView = UIView(frame: UIScreen.main.bounds)
        if let previewView = self.previewView {
         
            previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            previewView.backgroundColor = UIColor.black
            NextLevel.shared.previewLayer.frame = previewView.bounds
             
            previewView.layer.addSublayer(NextLevel.shared.previewLayer)
            self.view.addSubview(previewView)
            self.view.sendSubviewToBack(previewView)
            //NextLevel.shared.previewLayer.connection?.isEnabled = true
         
        }
     }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        checkAuthorizations()
        initNextLevel()
        
        if !mirrored
        {
            NextLevel.shared.flipCaptureDevicePosition()
            NextLevel.shared.mirroringMode = .on
            mirrored = true
        }
        
       
        
        print("VIEW DID APPEAR")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if comingFromPlayback
        {
            confirmationView.isHidden = false
            confirmationView.isUserInteractionEnabled = true
            comingFromPlayback = false
            self.confirmationView.alpha = 1.0
        }
    }
    
    public func checkAuthorizations()
    {
        NextLevel.requestAuthorization(forMediaType: .video) { (media, status) in
            DispatchQueue.main.async {
                if status == .authorized {
                    
                    AVAudioSession.sharedInstance().requestRecordPermission { granted in
                        DispatchQueue.main.async {
                            if granted {
                                
                                PHPhotoLibrary.requestAuthorization { (status) in
                                    DispatchQueue.main.async {
                                        if status == PHAuthorizationStatus.authorized {
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
    }
    }
    
    public func initNextLevel(_ preset: AVCaptureSession.Preset = AVCaptureSession.Preset.hd1280x720)
    {
        print("Init Next Level")
        
        NextLevel.shared.videoConfiguration.preset = preset

        NextLevel.shared.videoConfiguration.bitRate = 5500000
        NextLevel.shared.videoConfiguration.maxKeyFrameInterval = 120
        NextLevel.shared.mirroringMode = .off
        NextLevel.shared.videoZoomFactor = 1
        NextLevel.shared.captureMode = .video
        NextLevel.shared.automaticallyUpdatesDeviceOrientation = true
        NextLevel.shared.videoConfiguration.profileLevel = AVVideoProfileLevelH264HighAutoLevel
        
        //nextLevelInitialized = true
        
    }
    
    @IBAction func recorderAction(_ sender: Any) {
        if recording
        {
            DispatchQueue.main.asyncAfter(deadline: .now()+2.0, execute: {
                NextLevel.shared.pause(withCompletionHandler: self.saveVideoAndSend)
            })
            
            buttonAction.setTitle("Record", for: .normal)
        }
        else
        {
            
            do {
                try NextLevel.shared.record()
            } catch {
                
            }
            buttonAction.setTitle("Stop Recording", for: .normal)
            
        }
        
        recording = !recording
    }
    
    func saveVideoAndSend()
    {
        if(NextLevel.shared.session?.clips.count ?? 0>0)
        {
            if let session = NextLevel.shared.session {

                if let lastClipUrl = session.lastClipUrl {
                saveVideo(withURL: lastClipUrl)
                }
            }
        }else
        {
            print("No video was found")
        }
    }
    
    func checkAuthAndStart()
    {
        if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
            NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
            do {
                if (NextLevel.shared.session == nil)
                {
                    try NextLevel.shared.start()
                    
                }else
                {
                    print("Existing session")
                }
            } catch {
                print("NextLevel, failed to start camera session")
            }
        } else {
            NextLevel.requestAuthorization(forMediaType: AVMediaType.video) { (mediaType, status) in
                print("NextLevel, authorization updated for media \(mediaType) status \(status)")
                if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
                    NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
                    do {
                        let nextLevel = NextLevel.shared
                        try nextLevel.start()
                    } catch {
                        print("NextLevel, failed to start camera session")
                    }
                } else if status == .notAuthorized {
                    // gracefully handle when audio/video is not authorized
                    print("NextLevel doesn't have authorization for audio or video")
                }
            }
            NextLevel.requestAuthorization(forMediaType: AVMediaType.audio) { (mediaType, status) in
                print("NextLevel, authorization updated for media \(mediaType) status \(status)")
                if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
                    NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
                    do {
                        let nextLevel = NextLevel.shared
                        try nextLevel.start()
                    } catch {
                        print("NextLevel, failed to start camera session")
                    }
                } else if status == .notAuthorized {
                    // gracefully handle when audio/video is not authorized
                    print("NextLevel doesn't have authorization for audio or video")
                }
            }
        }
    }
    
    internal func saveVideo(withURL url: URL) {
        NSLog ("Saving in storage...")
        lastURL = url
        PHPhotoLibrary.shared().performChanges({
            let albumAssetCollection = self.albumAssetCollection(withTitle: "Relatable")
            if albumAssetCollection == nil {
                
                let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: "Relatable")
                let _ = changeRequest.placeholderForCreatedAssetCollection
            }}, completionHandler: { (success1: Bool, error1: Error?) in
                
                if let albumAssetCollection = self.albumAssetCollection(withTitle: "Relatable") {
                    
                    PHPhotoLibrary.shared().performChanges({
                        
                        if let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url) {
                            
                            let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                            let enumeration: NSArray = [assetChangeRequest.placeholderForCreatedAsset!]
                            assetCollectionChangeRequest?.addAssets(enumeration)
                        }
                        
                    }, completionHandler: { (success2: Bool, error2: Error?) in
                        
                        if success2 == true {
                            
                            print("Success 2")
                            DispatchQueue.main.async {
                               
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 2000)) {
                                    
                                    if let session = NextLevel.shared.session {
                                        print("Remove clips after saving")
                                            session.removeAllClips()
                                        self.playbackLastVideo()
                                    }
                                        
                                }
                            }
                        } else {
                            // prompt that the video has been saved
                            DispatchQueue.main.async {
                               print("Video saved")
                            }
                            
                        }
                    })
                }
        })
    }
    
    public func playbackLastVideo()
    {
        var urlToPlay: String = ""
        
        
        
        PHPhotoLibrary.shared().performChanges({
            let albumAssetCollection = self.albumAssetCollection(withTitle: "Relatable")
            if albumAssetCollection == nil {
                print("There is not such an album or picture creating album")
                let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: "Relatable")
                let _ = changeRequest.placeholderForCreatedAssetCollection
            }else{
                let options = PHFetchOptions()
                options.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
                let assetsFromCollection = PHAsset.fetchAssets(in: albumAssetCollection!, options: options)
                
                if(assetsFromCollection.count > 0)
                {
                    let resources = PHAssetResource.assetResources(for: assetsFromCollection[0])
                    
                    
                    
                    urlToPlay = (resources.first!).originalFilename
                    assetsFromCollection[0].getURL(originalFilename: urlToPlay, completionHandler: {
                        (string, url) in
                        DispatchQueue.main.async {
                            self.urlToSave = url?.absoluteString ?? "undefined"
                            
                            let player = AVPlayer(url: url!)
                            self.comingFromPlayback = true
                                let playerViewController = AVPlayerViewController()
                                playerViewController.player = player
                                self.present(playerViewController, animated: true) {
                                  playerViewController.player?.play()
                                }
                        }
                    })
                    print("URL to play \(urlToPlay) amount of videos created: \(assetsFromCollection.count)")
                    print("We will be playing the video at \(urlToPlay)")
                       
                    
                   
                }
            }
        })

    }
    
    

    internal func albumAssetCollection(withTitle title: String) -> PHAssetCollection? {
        let predicate = NSPredicate(format: "localizedTitle = %@", title)
        let options = PHFetchOptions()
        options.predicate = predicate
        let result = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        if result.count > 0 {
            let _ = result.firstObject
            
            return result.firstObject
        }
        return nil
    }
    
    
    @IBAction func acceptVideo(_ sender: Any) {
        let message = StaticData.shared.conversation.count > 2 ? "\(StaticData.shared.conversation  )-B=V=\(urlToSave)" : "B=V=\(urlToSave)"
        StaticData.shared.conversation = message
        StaticData.convoPieces = StaticData.shared.conversation.split(separator: "-")
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func retakeVideo(_ sender: Any) {
        
        confirmationView.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.5) {
            self.confirmationView.alpha = 0.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.confirmationView.isHidden = true
        })
    }
    
    
}

extension CameraViewController: NextLevelDelegate, NextLevelDeviceDelegate, NextLevelVideoDelegate
{
    func nextLevel(_ nextLevel: NextLevel, didChangeLensPosition lensPosition: Float) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didUpdateVideoZoomFactor videoZoomFactor: Float) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, willProcessRawVideoSampleBuffer sampleBuffer: CMSampleBuffer, onQueue queue: DispatchQueue) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, renderToCustomContextWithImageBuffer imageBuffer: CVPixelBuffer, onQueue queue: DispatchQueue) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, willProcessFrame frame: AnyObject, timestamp: TimeInterval, onQueue queue: DispatchQueue) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSetupVideoInSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSetupAudioInSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didStartClipInSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCompleteClip clip: NextLevelClip, inSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didAppendVideoSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSkipVideoSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didAppendVideoPixelBuffer pixelBuffer: CVPixelBuffer, timestamp: TimeInterval, inSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSkipVideoPixelBuffer pixelBuffer: CVPixelBuffer, timestamp: TimeInterval, inSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didAppendAudioSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSkipAudioSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCompleteSession session: NextLevelSession) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCompletePhotoCaptureFromVideoFrame photoDict: [String : Any]?) {
        
    }
    
    func nextLevelDevicePositionWillChange(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelDevicePositionDidChange(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didChangeDeviceOrientation deviceOrientation: NextLevelDeviceOrientation) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didChangeDeviceFormat deviceFormat: AVCaptureDevice.Format) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didChangeCleanAperture cleanAperture: CGRect) {
        
    }
    
    
    func nextLevelWillStartFocus(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelDidStopFocus(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelWillChangeExposure(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelDidChangeExposure(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelWillChangeWhiteBalance(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelDidChangeWhiteBalance(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didUpdateVideoConfiguration videoConfiguration: NextLevelVideoConfiguration) {
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didUpdateAudioConfiguration audioConfiguration: NextLevelAudioConfiguration) {
        
    }
    
    func nextLevelSessionWillStart(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelSessionDidStart(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelSessionDidStop(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelSessionWasInterrupted(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelSessionInterruptionEnded(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelCaptureModeWillChange(_ nextLevel: NextLevel) {
        
    }
    
    func nextLevelCaptureModeDidChange(_ nextLevel: NextLevel) {
        
    }
}
