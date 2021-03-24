//
//  SeperatorView.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/19/21.
//

import UIKit

public class SeparatorView: UIView {
    private let height: CGFloat
    private let width: CGFloat
    private let separator: UIView

    private init(backgroundColor: UIColor, top: Int, left: Int, right: Int, bottom: Int, width: CGFloat, height: CGFloat, cornerRadius: CGFloat) {
        self.width = CGFloat(left + right) + width
        self.height = CGFloat(top) + height
        self.separator = UIView(backgroundColor: backgroundColor)
        super.init(frame: .zero)

        addSubview(separator)
        separator.layer.cornerRadius = cornerRadius
        separator.snp.makeConstraints { make in
            make.top.equalTo(self).inset(top)
            make.left.equalTo(self).inset(left)
            make.right.equalTo(self).inset(right).priority(.medium)
            make.bottom.equalTo(self).inset(bottom)
            if width != UIView.noIntrinsicMetric {
                make.width.equalTo(width)
            }
            if height != UIView.noIntrinsicMetric {
                make.height.equalTo(height)
            }
        }
    }

    public static func horizontal(backgroundColor: UIColor = .lightGray,
                                  top: Int = 0,
                                  left: Int = 0,
                                  right: Int = 0,
                                  bottom: Int = 0,
                                  width: CGFloat = UIView.noIntrinsicMetric,
                                  height: CGFloat = 1,
                                  cornerRadius: CGFloat = 0) -> SeparatorView {
        return SeparatorView(backgroundColor: backgroundColor, top: top, left: left, right: right, bottom: bottom, width: width, height: height, cornerRadius: cornerRadius)
    }

    public static func vertical(backgroundColor: UIColor = .lightGray,
                                top: Int = 0,
                                left: Int = 0,
                                right: Int = 0,
                                bottom: Int = 0,
                                width: CGFloat = 1,
                                height: CGFloat = UIView.noIntrinsicMetric,
                                cornerRadius: CGFloat = 0) -> SeparatorView {
        return SeparatorView(backgroundColor: backgroundColor, top: top, left: left, right: right, bottom: bottom, width: width, height: height, cornerRadius: cornerRadius)
    }

    public static func accent(backgroundColor: UIColor = .black,
                              top: Int = 0,
                              left: Int = 16,
                              right: Int = 0,
                              bottom: Int = 0,
                              width: CGFloat = 24,
                              height: CGFloat = 1,
                              cornerRadius: CGFloat = 0) -> SeparatorView {
        return SeparatorView(backgroundColor: backgroundColor, top: top, left: left, right: right, bottom: bottom, width: width, height: height, cornerRadius: cornerRadius)
    }

    public static func accentWithContainer(backgroundColor: UIColor = .black,
                                           top: Int = 0,
                                           left: Int = 16,
                                           right: Int = 0,
                                           bottom: Int = 0,
                                           width: CGFloat = 24,
                                           height: CGFloat = 1,
                                           cornerRadius: CGFloat = 0) -> UIView {
        let container = UIView()
        container.addSubview(SeparatorView.accent(backgroundColor: backgroundColor, top: top, left: left, right: right, width: width, height: height, cornerRadius: cornerRadius)) { make in
            make.top.bottom.equalTo(container)
        }
        return container
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
}
