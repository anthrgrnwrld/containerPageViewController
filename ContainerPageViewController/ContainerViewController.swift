//
//  ContainerViewController.swift
//  ContainerPageViewController
//
//  Created by Masaki Horimoto on 2022/02/08.
//

import UIKit

class ContainerPageViewController: UIPageViewController {
    
    private var tabButtonLabelStoryboardIDInfomations: [TabButtonLabelStoryboardIDInfo] = []
    
    // MARK: - Init     // iOS13以上
    //for code
    init?(coder: NSCoder, tabButtonLabelStoryboardIDInfomations: [TabButtonLabelStoryboardIDInfo]) {
        self.tabButtonLabelStoryboardIDInfomations = tabButtonLabelStoryboardIDInfomations
        super.init(coder: coder)
    }
    
    //for storyboard (not suported)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    var tabPageChildViewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initTabPageView()  //PageView初期化
    }
    
}

//PageViewController初期化
extension ContainerPageViewController {
    private func initTabPageView(){
        //TabPageViewControllerで表示するViewControllerをインスタンス化
        tabButtonLabelStoryboardIDInfomations.forEach({
            self.tabPageChildViewControllers.append(getViewController(storyboardID: $0.storyboardID))
        })

        //PageViewControllerの設定(コードで行う場合)
        //self.(UIPageViewController型) = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

        //最初に表示するViewControllerを指定する
        if !self.tabPageChildViewControllers.isEmpty {
            self.setViewControllers([self.tabPageChildViewControllers[0]], direction: .forward, animated: true, completion: nil)
        }
                
        //PageViewControllerのDataSourceとの関連付け
        self.dataSource = self
    }
    
    private func getViewController(storyboardID: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: storyboardID)
    }
    
    func changeTabPageChildViewController(targetIndex: Int, currentIndex: Int) {
        let direction: UIPageViewController.NavigationDirection
        if currentIndex < targetIndex {
            direction = .forward
            var array: [Int] = []
            for i in currentIndex ..< targetIndex {
                array.append(i + 1)
            }
            array.forEach({
                self.setViewControllers([self.tabPageChildViewControllers[$0]], direction: direction, animated: true, completion: nil)
            })
        } else if currentIndex > targetIndex {
            direction = .reverse
            var array: [Int] = []
            for i in targetIndex..<currentIndex {
                array.insert(i, at: 0)
            }
            array.forEach({
                self.setViewControllers([self.tabPageChildViewControllers[$0]], direction: direction, animated: true, completion: nil)
            })
        } else {
            //処理無し
        }
    }
}

extension ContainerPageViewController: UIPageViewControllerDataSource {
    // スクロールするページ数
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.tabPageChildViewControllers.count
    }

    // 左にスワイプした時の処理
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = self.tabPageChildViewControllers.firstIndex(of: viewController), index <= self.tabPageChildViewControllers.count - 1 {
            if index != self.tabPageChildViewControllers.count - 1 {
                return self.tabPageChildViewControllers[index + 1]
            } else {
                return nil
            }
        } else {
            print("error")
            return nil
        }
    }
    
    // 右にスワイプした時の処理
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = self.tabPageChildViewControllers.firstIndex(of: viewController), index >= 0 {
            if index != 0 {
                return self.tabPageChildViewControllers[index - 1]
            } else {
                return nil
            }
        } else {
            print("error")
            return nil
        }
    }
    
}
