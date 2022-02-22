//
//  UIViewExtension.swift
//  ContainerPageViewController
//
//  Created by Masaki Horimoto on 2022/02/21.
//

import UIKit

extension UIView {
    //親Viewとして想定される引数のView(parentView)のAutolayoutに一致させるメソッド
    func setSameConstraint(equalTo parentView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            self.topAnchor.constraint(equalTo: parentView.topAnchor),
            self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        ])
    }

}
