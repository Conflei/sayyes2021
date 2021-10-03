//
//  PlaybackViewController.swift
//  Relatable
//
//  Created by Felix Izarra on 10/2/21.
//

import UIKit
import AVKit
import Photos

class CustomAVPlayerParentViewController: UIViewController, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
}

class PlaybackViewController: AVPlayerViewController {
    
    var acceptButton: UIButton!
    var backButton: UIButton!
    var replayButton: UIButton!
    var videoAsset: PHAsset!
    var assetDuration: Double?
    
    var videoPath: URL = URL.init(fileURLWithPath: "")
    
    var isPlaying: Bool {
        return player?.rate != 0.0 && player?.error == nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        acceptButton = UIButton(frame: .zero)
        acceptButton.setImage(UIImage(named: "accepted"), for: UIControl.State.normal)
        acceptButton.contentMode = .left
        acceptButton.addTarget(self, action: #selector(acceptButtonAction), for: .touchUpInside)
        acceptButton.isUserInteractionEnabled = true
        acceptButton.clipsToBounds = true
        self.contentOverlayView?.addSubview((acceptButton as UIButton))
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        
        let videoAsset = AVURLAsset(url: videoPath)
        assetDuration = CMTimeGetSeconds(videoAsset.duration)
        let imageGen = AVAssetImageGenerator(asset: videoAsset)
        //not sure about these settings
        imageGen.appliesPreferredTrackTransform = true
        imageGen.apertureMode = .encodedPixels
        
        let videoSize = videoAsset.tracks[0].naturalSize
        let videoWidth = videoSize.width
        let videoHeight = videoSize.height
        let videoIsLandscape = videoWidth >= videoHeight
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.player?.play()
        })
    }
    
    @objc func didPlayToEnd() {
        self.player!.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: 1))
    }
    
    @objc func acceptButtonAction(sender: UIButton!) {
    }
    @objc func backButtonAction(sender: UIButton!) {
    }
    @objc func replayButtonAction(sender: UIButton!) {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.player?.pause()
    }
    
    public func startPlaying() {
        if !isPlaying {
            playPauseButtonAction(sender: nil)
        }
    }
    
    @objc func playPauseButtonAction(sender: UIButton!) {
    
        print(isPlaying)
        
        if isPlaying {
            self.player!.pause()
         
            
        }
        else
        {
            player?.play()
          
           
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
