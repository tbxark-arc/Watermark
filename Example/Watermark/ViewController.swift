//
//  ViewController.swift
//  Watermark
//
//  Created by TBXark on 04/08/2019.
//  Copyright (c) 2019 TBXark. All rights reserved.
//

import UIKit
import Watermark


class ViewController: UIViewController {

    let imageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "demo")
        view.addSubview(imageView)
        
        
        DispatchQueue.global().async {
            guard let bilibili = UIImage(named: "bilibili"),
                let image = UIImage(named: "demo") else {
                return
            }
            let attr = NSAttributedString(string: "ID:2333333", attributes: [
                NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16),
                NSAttributedStringKey.foregroundColor: UIColor.white])
            let processor =  WatermarkProcessor()
            var layout: WatermarkProcessor.Media.Position = (
                horizontal: (offset: 20, alignment: .end),
                vertical: (offset: 20, alignment: .start)
            )
            processor.addMedia(WatermarkProcessor.Media(image: bilibili, layout: layout))
            layout.vertical.offset += bilibili.size.height + 10
            processor.addMedia(WatermarkProcessor.Media(text: attr, layout: layout))
            guard let result = processor.process(origin: image) else {
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = result
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

