//
//  ContainerPageView.swift
//  ContainerPageViewController
//
//  Created by Masaki Horimoto on 2022/02/13.
//

import UIKit

protocol ContainerPageViewDelegate: UIPageViewControllerDelegate {
    func containerPageView(selectedIndexAfterSwipe: Int)
}

extension ContainerPageViewDelegate {
    
}

class ContainerPageView: UIView {
    weak var delegate: ContainerPageViewDelegate?
    var containerPageViewController: ContainerPageViewController?
    
    //TabCollectionViewで表示するボタンのラベルとそれに紐づくstoryboardID
    var tabButtonLabelStoryboardIDInfomations: [TabButtonLabelStoryboardIDInfo] = []
    
    //for code
    init(frame: CGRect, tabButtonLabelStoryboardIDInfomations: [TabButtonLabelStoryboardIDInfo]) {
        super.init(frame: frame)
        self.tabButtonLabelStoryboardIDInfomations = tabButtonLabelStoryboardIDInfomations
        setConfig()
    }
    
    //for storyboard (not supported)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfig() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.containerPageViewController = storyboard.instantiateViewController(identifier: "ContainerPageViewController", creator: { coder in
            ContainerPageViewController(coder: coder, tabButtonLabelStoryboardIDInfomations: self.tabButtonLabelStoryboardIDInfomations)
        })
        //ContainerPageViewControllerを追加する
        self.containerPageViewController!.view.frame = self.bounds
        self.addSubview(self.containerPageViewController!.view)

        containerPageViewController?.delegate = self    //
    }
    
    //PageViewControllerの切り替え
    func changeContainerPageViewController(targetIndex: Int, currentIndex: Int) {
        self.containerPageViewController!.changeTabPageChildViewController(targetIndex: targetIndex, currentIndex: currentIndex)
    }

}

extension ContainerPageView: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            guard let delegate = delegate, let firstIndex = pageViewController.viewControllers?.first else {
                //処理なし
                return
            }
            if let index = self.containerPageViewController?.tabPageChildViewControllers.firstIndex(of: firstIndex) {
                delegate.containerPageView(selectedIndexAfterSwipe: index)
            }
        }
    }
}
