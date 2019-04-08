//
//  ViewController.swift
//  Watermark
//
//  Created by TBXark on 04/08/2019.
//  Copyright (c) 2019 TBXark. All rights reserved.
//

import UIKit

public class WatermarkProcessor {

    public struct Media {
        public enum Source {
            case image(UIImage)
            case text(NSAttributedString)
        }
        public struct Layout {
            public struct Position {
                public enum Alignment {
                    case start, center, end
                }
                public var horizontal: (offset: CGFloat, alignment: Alignment)
                public var vertical: (offset: CGFloat, alignment: Alignment)
            }
            public var position: Position
            public var size: CGSize

            func convert(from content: CGSize) -> CGRect {
                var rect = CGRect(origin: CGPoint.zero, size: size)
                switch position.horizontal.alignment {
                case .start:
                    rect.origin.x = position.horizontal.offset
                case .center:
                    rect.origin.x = position.horizontal.offset + content.width/2
                case .end:
                    rect.origin.x = -position.horizontal.offset + (content.width - size.width)
                }
                switch position.vertical.alignment {
                case .start:
                    rect.origin.y = position.vertical.offset
                case .center:
                    rect.origin.y = position.vertical.offset + content.height/2
                case .end:
                    rect.origin.y = -position.vertical.offset + (content.height - size.height)
                }
                return rect
            }
        }

        public var source: Source
        public var layout: Layout

        public init(text: NSAttributedString, layout: Layout.Position) {
            self.source = .text(text)
            self.layout = Layout(position: layout, size: text.size())
        }

        public init(image: UIImage, layout: Layout.Position) {
            self.source = .image(image)
            self.layout = Layout(position: layout, size: image.size)
        }
    }

    private var items = [Media]()

    public init() {}

    public func addMedia(_ media: Media) {
        items.append(media)
    }

    public func process(origin: UIImage) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(origin.size, false, origin.scale)
        origin.draw(in: CGRect(origin: CGPoint.zero, size: origin.size))
        for item in items {
            let rect = item.layout.convert(from: origin.size)
            switch item.source {
            case .image(let img):
                img.draw(in: rect)
            case .text(let str):
                str.draw(in: rect)
            }
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
