//
//  SplashViewController.swift
//  Clima
//
//  Created by Atalay Okun on 19.10.2025.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import UIKit
import ImageIO

class SplashViewController: UIViewController {

    let gifImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Arka plan Launch Screen ile uyumlu olacak şekilde system teal
        view.backgroundColor = .systemTeal

        // GIF’i yükle
        if let path = Bundle.main.path(forResource: "cloudy_icon", ofType: "gif"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            let image = UIImage.animatedImage(withAnimatedGIFData: data)
            gifImageView.image = image
        }

        // Launch Screen ile aynı boyut ve konum
        gifImageView.frame = CGRect(x: 65, y: 310, width: 263, height: 233)
        gifImageView.contentMode = .scaleAspectFit
        view.addSubview(gifImageView)

        // Animasyon süresi kadar sonra ana ekrana geç
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showMainApp()
        }
    }

    private func showMainApp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve
        self.present(mainVC, animated: true)
    }
}

// GIF oynatma extension
extension UIImage {

    public class func animatedImage(withAnimatedGIFData data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        var duration: Double = 0

        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: cgImage))
                if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [CFString: Any],
                   let gifInfo = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any],
                   let delay = gifInfo[kCGImagePropertyGIFUnclampedDelayTime] as? Double {
                    duration += delay
                }
            }
        }

        return UIImage.animatedImage(with: images, duration: duration)
    }
}



