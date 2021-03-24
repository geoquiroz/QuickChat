//
//  CustomMessageCell.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/20/21.
//

import UIKit

class CustomeMessageCell: UITableViewCell {

    var messageBackground = UIView()
    var avatarImageView = UIImageView()
    var messageBody = UILabel()
    var senderUsername = UILabel()


    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        avatarImageView.layer.cornerRadius = 30
        avatarImageView.layer.borderColor = UIColor.black.cgColor
        avatarImageView.layer.borderWidth = 2
        avatarImageView.backgroundColor = .white
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        contentView.addSubview(avatarImageView) { make in
            make.width.height.equalTo(60)
            make.left.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }

        let stackView = UIStackView(axis: .vertical)
        stackView.spacing = 4
        contentView.addSubview(stackView) { make in
            make.left.equalTo(avatarImageView.snp.right).offset(16)
            make.top.lessThanOrEqualToSuperview().inset(14)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
            make.right.lessThanOrEqualToSuperview().inset(8)
        }

        senderUsername.textColor = .lightGray
        senderUsername.font = .boldSystemFont(ofSize: 12)
        senderUsername.numberOfLines = 2
        stackView.addArrangedSubview(senderUsername)

        messageBody.textColor = .black
        messageBody.font = .systemFont(ofSize: 18)
        messageBody.numberOfLines = 2
        stackView.addArrangedSubview(messageBody)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
