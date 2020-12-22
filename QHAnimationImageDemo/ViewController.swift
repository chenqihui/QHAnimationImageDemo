//
//  ViewController.swift
//  QHAnimationImageDemo
//
//  Created by Anakin chen on 2018/9/6.
//  Copyright © 2018年 Chen Network Technology. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func go(type: QHAnimationType) {
        let vc = QHAnimationImageViewController.create() as! QHAnimationImageViewController
        vc.animationType = type
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func animationAction(_ sender: Any) {
        go(type: .animation)
    }
    
    @IBAction func gifAction(_ sender: Any) {
        go(type: .gif)
    }
    
    @IBAction func webPAction(_ sender: Any) {
        go(type: .webP)
    }
    
    @IBAction func svgaAction(_ sender: Any) {
        go(type: .svga)
    }
    
    @IBAction func livePhotoAction(_ sender: Any) {
        go(type: .livePhoto)
    }
    
    @IBAction func pngs2GifAction(_ sender: Any) {
        go(type: .pngs2Gif)
    }
    
}

