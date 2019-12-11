//
//  UITableView+Extensions.swift
//  Dizzy
//
//  Created by ジャティン on 2019/11/15.
//  Copyright © 2019 Me. All rights reserved.
//

import UIKit

public extension UITableView {

    /// Gets the currently visibleCells of a section.
    ///
    /// - Parameter section: The section to filter the cells.
    /// - Returns: Array of visible UITableViewCell in the argument section.
    func visibleCells(in section: Int) -> [UITableViewCell] {
        return visibleCells.filter { indexPath(for: $0)?.section == section }
    }
    
    func fadeReload() {
        UIView.transition(with: self, duration: 0.35, options: .transitionCrossDissolve, animations: {
            self.reloadData()
        })
    }
    
    func addActivityIndicator() {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.bounds.width, height: CGFloat(44))
        self.tableFooterView = spinner
        self.tableFooterView?.isHidden = false
    }
}
