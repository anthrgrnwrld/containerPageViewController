//
//  ContainerPageView.swift
//  ContainerPageViewController
//
//  Created by Masaki Horimoto on 2022/02/13.
//

import UIKit

protocol ContainerPageViewDelegate: UIPageViewControllerDelegate {
    func containerPageView(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
}

extension ContainerPageViewDelegate {
    
}

class ContainerPageView: UIView, UIPageViewControllerDelegate {
    weak var delegate: ContainerPageViewDelegate?
    var containerPageViewController: ContainerPageViewController?
    
    //TabCollectionViewで表示するボタンのラベルとそれに紐づくstoryboardID
    private let tabButtonLabelStoryboardIDInfomations: [TabButtonLabelStoryboardIDInfo] = []
    
    //for code
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    //for storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    private func config() {
        //self.containerPageViewController!.delegate = self
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print("FGHJJJHGHNBVGFG")
        
        guard let delegate = delegate else {
            //処理なし
            return
        }
        
        delegate.containerPageView(pageViewController, didFinishAnimating: finished, previousViewControllers: previousViewControllers, transitionCompleted: completed)
        
    }
    
    @IBSegueAction func segeActionContainerPageViewController(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> ContainerPageViewController? {
        print("ksksksksksksksksksksks")
        return containerPageViewController
        
    }
    
    
}
