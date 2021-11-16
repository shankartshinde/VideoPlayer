//
//  ViewController.swift
//  DemoScrollView
//
//  Created by AyunaLabs on 15/11/21.
//

import UIKit

class ViewController: UIViewController {
    
        let pausePlayButton: UIButton = {
            let btn = UIButton()
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.setTitle("Play", for: .normal)
            btn.addTarget(self, action: #selector(playButtonTapped(sender:)), for: UIControl.Event.touchUpInside)
            btn.backgroundColor = .white
            btn.setTitleColor(.red, for: UIControl.State.normal)
    
            return btn
        }()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        print(String(format: "a float number: %.2f", 112.0321))

    }

        @objc func playButtonTapped(sender: AnyObject) {
            let vc = VideoPlayerViewController()
            self.present(vc, animated: true, completion: nil)
        }
    

}

