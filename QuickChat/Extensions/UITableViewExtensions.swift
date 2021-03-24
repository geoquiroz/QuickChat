//
//  UITableViewExtensions.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/20/21.
//

import UIKit

extension UITableView {
    public func register(cell: UITableViewCell.Type) {
        register(cell, forCellReuseIdentifier: cell.identifier)
    }

    public func register(cells: [UITableViewCell.Type]) {
        cells.forEach { register(cell: $0) }
    }

    func reloadData(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }

    func reloadSections(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadSections(IndexSet.init(integer: .zero), with: .automatic)
        }, completion: { _ in
            completion()
        })
    }
}
