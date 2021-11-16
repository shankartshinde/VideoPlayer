//
//  VideoPlayerViewController.swift
//  DemoScrollView
//
//  Created by AyunaLabs on 15/11/21.
//

import Foundation
import UIKit

class VideoPlayerViewController: UIViewController {
    
    private var playerView: PlayerView = PlayerView()
    private var videoPlayer:VideoPlayer?
    
    let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    let parentContainerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
// Move all these in Single View - All controls
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()

    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = false
        
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        
        return button
    }()

    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    lazy var videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        
        return slider
    }()


    let mediaDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.italicSystemFont(ofSize: 16.0)
        label.textColor = .white
        label.backgroundColor = .blue
        label.text = """
            Developing for Apple platforms puts the cutting-edge technology of iOS, iPadOS, macOS, tvOS, and watchOS at your fingertips, giving you limitless ways to bring incredible apps to users around the world. These powerful platforms each offer unique capabilities and user experiences, yet integrate tightly to form a true ecosystem. Hardware, software, and services are designed from the ground up to work together so you can build intuitive, multi-faceted experiences that are genuinely seamless.
            
            Developing for Apple platforms puts the cutting-edge technology of iOS, iPadOS, macOS, tvOS, and watchOS at your fingertips, giving you limitless ways to bring incredible apps to users around the world. These powerful platforms each offer unique capabilities and user experiences, yet integrate tightly to form a true ecosystem. Hardware, software, and services are designed from the ground up to work together so you can build intuitive, multi-faceted experiences that are genuinely seamless.
            Developing for Apple platforms puts the cutting-edge technology of iOS, iPadOS, macOS, tvOS, and watchOS at your fingertips, giving you limitless ways to bring incredible apps to users around the world. These powerful platforms each offer unique capabilities and user experiences, yet integrate tightly to form a true ecosystem. Hardware, software, and services are designed from the ground up to work together so you can build intuitive, multi-faceted experiences that are genuinely seamless.
            
            Developing for Apple platforms puts the cutting-edge technology of iOS, iPadOS, macOS, tvOS, and watchOS at your fingertips, giving you limitless ways to bring incredible apps to users around the world. These powerful platforms each offer unique capabilities and user experiences, yet integrate tightly to form a true ecosystem. Hardware, software, and services are designed from the ground up to work together so you can build intuitive, multi-faceted experiences that are genuinely seamless.

            Developing for Apple platforms puts the cutting-edge technology of iOS, iPadOS, macOS, tvOS, and watchOS at your fingertips, giving you limitless ways to bring incredible apps to users around the world. These powerful platforms each offer unique capabilities and user experiences, yet integrate tightly to form a true ecosystem. Hardware, software, and services are designed from the ground up to work together so you can build intuitive, multi-faceted experiences that are genuinely seamless.
            
            Developing for Apple platforms puts the cutting-edge technology of iOS, iPadOS, macOS, tvOS, and watchOS at your fingertips, giving you limitless ways to bring incredible apps to users around the world. These powerful platforms each offer unique capabilities and user experiences, yet integrate tightly to form a true ecosystem. Hardware, software, and services are designed from the ground up to work together so you can build intuitive, multi-faceted experiences that are genuinely seamless.

            Developing for Apple platforms puts the cutting-edge technology of iOS, iPadOS, macOS, tvOS, and watchOS at your fingertips, giving you limitless ways to bring incredible apps to users around the world. These powerful platforms each offer unique capabilities and user experiences, yet integrate tightly to form a true ecosystem. Hardware, software, and services are designed from the ground up to work together so you can build intuitive, multi-faceted experiences that are genuinely seamless.
            
            Developing for Apple platforms puts the cutting-edge technology of iOS, iPadOS, macOS, tvOS, and watchOS at your fingertips, giving you limitless ways to bring incredible apps to users around the world. These powerful platforms each offer unique capabilities and user experiences, yet integrate tightly to form a true ecosystem. Hardware, software, and services are designed from the ground up to work together so you can build intuitive, multi-faceted experiences that are genuinely seamless.

        """
        
        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        preparePlayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoPlayer?.pause()
        videoPlayer?.delegate = nil
        videoPlayer?.cleanUp()
        playerView.player = nil
    }

    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(parentContainerView)
        
        let safeAreaLayout = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayout.topAnchor, constant: 20.0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayout.bottomAnchor),
            
            parentContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0.0),
            parentContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0.0),
            parentContainerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0.0),
            parentContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            parentContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        parentContainerView.addSubview(playerView)
        
        if let keyWindow = UIApplication.shared.keyWindow {
            //16 x 9 is the aspect ratio of all HD videos
            let height = keyWindow.frame.width * 9 / 16
            // set Constraints (if you do it purely in code)
            playerView.translatesAutoresizingMaskIntoConstraints = false
            playerView.topAnchor.constraint(equalTo: parentContainerView.topAnchor, constant: 10.0).isActive = true
            playerView.leadingAnchor.constraint(equalTo: parentContainerView.leadingAnchor, constant: 10.0).isActive = true
            playerView.trailingAnchor.constraint(equalTo: parentContainerView.trailingAnchor, constant: -10.0).isActive = true
            playerView.heightAnchor.constraint(equalToConstant: height).isActive = true
            //playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10.0).isActive = true
            
            parentContainerView.addSubview(pausePlayButton)
            //controlsContainerView.addSubview(pausePlayButton)
            pausePlayButton.centerXAnchor.constraint(equalTo: playerView.centerXAnchor).isActive = true
            pausePlayButton.centerYAnchor.constraint(equalTo: playerView.centerYAnchor).isActive = true
            pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            parentContainerView.addSubview(activityIndicatorView)
            activityIndicatorView.centerXAnchor.constraint(equalTo: playerView.centerXAnchor).isActive = true
            activityIndicatorView.centerYAnchor.constraint(equalTo: playerView.centerYAnchor).isActive = true
            
            parentContainerView.addSubview(videoLengthLabel)
            videoLengthLabel.rightAnchor.constraint(equalTo: playerView.rightAnchor, constant: -8).isActive = true
            videoLengthLabel.bottomAnchor.constraint(equalTo: playerView.bottomAnchor).isActive = true
            videoLengthLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
            videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
            
            parentContainerView.addSubview(currentTimeLabel)
            currentTimeLabel.leftAnchor.constraint(equalTo: playerView.leftAnchor, constant: 8).isActive = true
            currentTimeLabel.bottomAnchor.constraint(equalTo: playerView.bottomAnchor, constant: -2).isActive = true
            currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
            currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
            
            parentContainerView.addSubview(videoSlider)
            videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
            videoSlider.bottomAnchor.constraint(equalTo: playerView.bottomAnchor).isActive = true
            videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
            videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }


        parentContainerView.addSubview(mediaDescriptionLabel)
        
        NSLayoutConstraint.activate([
            
            mediaDescriptionLabel.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 20.0),
            mediaDescriptionLabel.leadingAnchor.constraint(equalTo: parentContainerView.leadingAnchor, constant: 0.0),
            mediaDescriptionLabel.trailingAnchor.constraint(equalTo: parentContainerView.trailingAnchor, constant: 0.0),
            parentContainerView.bottomAnchor.constraint(equalTo: mediaDescriptionLabel.bottomAnchor),
        ])
    }
    
    @objc func handleSliderChange() {
        print(videoSlider.value)
        videoPlayer?.seekToPosition(seconds: Float64(videoSlider.value))
    }
    
    @objc func handlePause() {
        if videoPlayer?.isPlaying() ?? false {
            videoPlayer?.pause()
            pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            videoPlayer?.play()
            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
    }

    
    private func preparePlayer() {
        let urlString = "https://www.hd9video.com/siteuploads/files/sfd2/743/Obulamma%20-%20Kondapolam-(Hd9video).mp4"
        if let url = URL(string: urlString) {
            let localVideoURL = url
            videoPlayer = VideoPlayer(urlAsset: localVideoURL,view: playerView, startAutoPlay : false)
            videoPlayer?.delegate = self
            if let player = videoPlayer {
                player.playerRate = 1
            }

        }
        
//        if let filePath = Bundle.main.path(forResource: "Obulamma_Kondapolam", ofType: "mp4") {
//            let fileURL = NSURL(fileURLWithPath: filePath)
//            videoPlayer = VideoPlayer(urlAsset: fileURL,view: playerView, startAutoPlay : false)
//            videoPlayer?.delegate = self
//            if let player = videoPlayer {
//                player.playerRate = 1
//            }
//        }
    }
}

extension VideoPlayerViewController : VideoPlayerDelegate {
    func downloadedProgress(progress: Double) {
        print("downloadedProgress:: \(progress)")
        activityIndicatorView.stopAnimating()
        self.videoLengthLabel.text = playerView.currentTime
    }
    
    func readyToPlay() {
        print("readyToPlay")
        activityIndicatorView.stopAnimating()
        //handlePause()
    }
    
    func didUpdateProgress(progress: Double) {
        print("didUpdateProgress :: \(String(format: "%.2f", progress))")
        self.currentTimeLabel.text = String(format: "%.2f", progress)
    }
    
    func didFinishPlayItem() {
        print("didFinishPlayItem")
    }
    
    func didFailPlayToEnd() {
        print("didFailPlayToEnd")
    }
    
    
}
