//
//  QHAnimationImageViewController.swift
//  QHAnimationImageDemo
//
//  Created by Anakin chen on 2018/9/6.
//  Copyright © 2018年 Chen Network Technology. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import PhotosUI
import MobileCoreServices

import YYImage
import SVGAPlayer

enum QHAnimationType {
    case animation
    case gif
    case webP
    case svga
    case livePhoto
    case pngs2Gif
}

class QHAnimationImageViewController: UIViewController {
    
    var animationType = QHAnimationType.animation
    
    deinit {
        #if DEBUG
        print("[\(type(of: self)) \(#function)]")
        #endif
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        p_show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - Private
    
    func p_show() {
        switch animationType {
        case .animation:
            p_addAnimationImages()
        case .gif:
            p_addGif()
        case .webP:
            p_addWebP()
        case .svga:
            p_addSvga()
        case .livePhoto:
            p_addLivePhoto()
        case .pngs2Gif:
            p_addPngs2Gif()
        }
    }
    
    func p_addAnimationImages() {
//        var images = [UIImage]()
//        for index in 0...20 {
//            let id = index * 10
//            if let image = UIImage(named: "gif 2－\(id).png") {
//                images.append(image)
//            }
//        }
//        let imageIV = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        imageIV.center = view.center
//        imageIV.animationImages = images
//        imageIV.animationDuration = 10
//        imageIV.animationRepeatCount = 0;
//        view.addSubview(imageIV)
//        imageIV.startAnimating()
        
        var datas = [Data]()
        for index in 0...20 {
            let id = index * 10
            if let image = UIImage(named: "gif 2－\(id).png") {
                if let data = UIImagePNGRepresentation(image) {
                    datas.append(data)
                }
            }
        }
        let image = YYFrameImage(imageDataArray: datas, oneFrameDuration: 0.5, loopCount: 0)
        let imageIV = YYAnimatedImageView(image: image)
        imageIV.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        imageIV.center = view.center
        imageIV.backgroundColor = UIColor.clear
        view.addSubview(imageIV)
    }
    
    func p_addGif() {
        let imageIV = YYAnimatedImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        imageIV.contentMode = .scaleAspectFit
        imageIV.center = view.center
        view.addSubview(imageIV)
        let image = YYImage(named: "gif.gif")
        imageIV.image = image
    }
    
    func p_addWebP() {
        let imageIV = YYAnimatedImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        imageIV.backgroundColor = UIColor.clear
        imageIV.contentMode = .scaleAspectFit
        imageIV.center = view.center
        view.addSubview(imageIV)
        let image = YYImage(named: "ymb.webp")
        imageIV.image = image
    }
    
    func p_addSvga() {
        let svagePlayer = SVGAPlayer(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        svagePlayer.backgroundColor = UIColor.clear
        svagePlayer.clearsAfterStop = true
        svagePlayer.contentMode = .scaleAspectFit
        svagePlayer.center = view.center
        view.addSubview(svagePlayer)
        let parser = SVGAParser()
        parser.parse(withNamed: "ymb", in: nil, completionBlock: { (videoItem) in
            svagePlayer.videoItem = videoItem
            svagePlayer.startAnimation()
            
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
//                if let image = UIImage(named: "ggg") {
//                    svagePlayer.setImage(image, forKey: "Bitmap3")
//                }
//
//                let shadow = NSShadow()
//                shadow.shadowColor = UIColor.yellow
//                shadow.shadowOffset = CGSize(width: 0, height: 1)
//                let attributedString = NSAttributedString(string: "hello world", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30), NSAttributedStringKey.shadow: shadow])
//                svagePlayer.setAttributedText(attributedString, forKey: "Bitmap3")
//                svagePlayer.startAnimation()
//            })
        }) { (error) in
            print("\(error)")
        }
    }
    
    func p_addLivePhoto() {
        if let movPath = Bundle.main.path(forResource: "unknown", ofType: "mov") {
            let movUrl = URL(fileURLWithPath: movPath)
            let picPath: String = NSHomeDirectory() + "/Documents/unknown.jpg"
            var image: UIImage!
            if FileManager.default.fileExists(atPath: picPath) == false {
                if let firstFrameImage = firstFrame(videoUrl: movUrl) {
                    FileManager.default.createFile(atPath: picPath, contents: UIImagePNGRepresentation(firstFrameImage), attributes: nil)
                    image = firstFrameImage
                }
            }
            else {
                image = UIImage(contentsOfFile: picPath)
            }
            
            let outPath = NSHomeDirectory() + "/Documents"
            let outMovPath = outPath + "/IMG.MOV"
            let outPicPath = outPath + "/IMG.JPG"
            let assetIdentifier = UUID().uuidString
            if FileManager.default.fileExists(atPath: outPicPath) == false {
                JPEG(path: picPath).write(outPicPath,
                                          assetIdentifier: assetIdentifier)
            }
            if FileManager.default.fileExists(atPath: outMovPath) == false {
                QuickTimeMov(path: movPath).write(outMovPath,
                                          assetIdentifier: assetIdentifier)
            }
            
            let w: CGFloat = 200
            let h = w / image.size.width * image.size.height
            let livePhotoView = PHLivePhotoView(frame: CGRect(x: 0, y: 0, width: w, height: h))
            livePhotoView.center = view.center
            view.addSubview(livePhotoView)
            
            DispatchQueue.main.async {
                PHLivePhoto.request(withResourceFileURLs: [URL(fileURLWithPath: outMovPath), URL(fileURLWithPath: outPicPath)], placeholderImage: nil, targetSize: livePhotoView.bounds.size, contentMode: .aspectFit, resultHandler: { (livePhoto, info) in
                    print("info = \(info)")
                    livePhotoView.livePhoto = livePhoto
                    
                    // 保存相册
//                    PHPhotoLibrary.shared().performChanges({ () -> Void in
//                        let creationRequest = PHAssetCreationRequest.forAsset()
//                        let options = PHAssetResourceCreationOptions()
//
//                        creationRequest.addResource(with: PHAssetResourceType.pairedVideo, fileURL: URL(fileURLWithPath: outMovPath), options: options)
//                        creationRequest.addResource(with: PHAssetResourceType.photo, fileURL: URL(fileURLWithPath: outPicPath), options: options)
//
//                    }, completionHandler: { (success, error) -> Void in
//                        if !success {
//                            print((error?.localizedDescription)!)
//                        }
//                    })
                })
            }
        }
    }
    
    func p_addPngs2Gif() {
        var images = [UIImage]()
        for index in 0...20 {
            let id = index * 10
            if let image = UIImage(named: "gif 2－\(id).png") {
                images.append(image)
            }
        }
        let docs = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = docs[0]
        let gifPath = documentsDirectory + "/pngs2gif.gif"
        if let url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, gifPath as CFString, .cfurlposixPathStyle, false) {
            if let destion = CGImageDestinationCreateWithURL(url, kUTTypeGIF, images.count, nil) {
            
                // 设置 gif 图片属性，构建gif
                // 设置每帧之间播放时间
                let cgimagePropertiesDic = [kCGImagePropertyGIFDelayTime as String: 0.5]
                let cgimagePropertiesDestDic = [kCGImagePropertyGIFDictionary as String: cgimagePropertiesDic];
                for image in images {
                    if let cgImage = image.cgImage {
                        CGImageDestinationAddImage(destion, cgImage, cgimagePropertiesDestDic as CFDictionary);
                    }
                }
                
                var gifPropertiesDic = [String: Any]()
                gifPropertiesDic[kCGImagePropertyColorModel as String] = kCGImagePropertyColorModelRGB
                // 设置图像的颜色深度
                gifPropertiesDic[kCGImagePropertyDepth as String] = 16
                // 设置Gif执行次数
                gifPropertiesDic[kCGImagePropertyGIFLoopCount as String] = 0
                let gifDictionaryDestDic = [kCGImagePropertyGIFDictionary: gifPropertiesDic]
                
                CGImageDestinationSetProperties(destion, gifDictionaryDestDic as CFDictionary)
                CGImageDestinationFinalize(destion)
                
                let imageIV = YYAnimatedImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
                imageIV.contentMode = .scaleAspectFit
                imageIV.center = view.center
                view.addSubview(imageIV)
                let image = YYImage(contentsOfFile: gifPath)
                imageIV.image = image
            }
        }
    }
    
    // MARK - Public
    
    class func create() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let className = NSStringFromClass(self).components(separatedBy: ".").last!
        let viewController = storyboard.instantiateViewController(withIdentifier: className)
        
        return viewController
    }
    
    func show(type: QHAnimationType) {
        animationType = type
        p_show()
    }
    
    // MARK - Util
    
    func firstFrame(videoUrl: URL) -> UIImage? {
        let asset = AVURLAsset(url: videoUrl, options: nil)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        do {
            let cgImage = try generator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let image = UIImage(cgImage: cgImage)
            return image
        }
        catch {
            print("1 = \(error)")
            return nil
        }
    }
}
