//
//  ContainerViewController.swift
//  ContainerPageViewController
//
//  Created by Masaki Horimoto on 2022/02/08.
//

import UIKit

class ContainerPageViewController: UIViewController {
    
    //UIViewControllerをUIPageViewControllerに変化させるために必要。このようにブリッジを咬ます方法じゃないと細かな設定が出来ない。
    private var tabPageViewController: UIPageViewController!
    private var tabPageChildViewControllers: [UIViewController] = []
    
    
    
    //タブ情報だけど今回はStoruboardの管理のみで使用する
    private struct TabPageContetntInfo {
        let tabButtonLabel: String
        let storyboardID: String
        var isSelected: Bool = false
        init(tabButtonLabel: String, storyboardID: String) {
            self.tabButtonLabel = tabButtonLabel
            self.storyboardID = storyboardID
        }
    }
    private var tabContentsInfo = [
        TabPageContetntInfo.init(tabButtonLabel: "First", storyboardID: "FirstViewController"),
        TabPageContetntInfo.init(tabButtonLabel: "Second", storyboardID: "SecondViewController"),
        TabPageContetntInfo.init(tabButtonLabel: "Third", storyboardID: "ThirdViewController"),
        TabPageContetntInfo.init(tabButtonLabel: "First", storyboardID: "FirstViewController"),
        TabPageContetntInfo.init(tabButtonLabel: "Second", storyboardID: "SecondViewController"),
        TabPageContetntInfo.init(tabButtonLabel: "Third", storyboardID: "ThirdViewController"),
        TabPageContetntInfo.init(tabButtonLabel: "First", storyboardID: "FirstViewController"),
        TabPageContetntInfo.init(tabButtonLabel: "Second", storyboardID: "SecondViewController"),
        TabPageContetntInfo.init(tabButtonLabel: "Third", storyboardID: "ThirdViewController"),
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //PageView初期化
        self.initTabPageView()
    }
    
}

//PageViewController初期化
extension ContainerPageViewController {
    private func initTabPageView(){
        //TabPageViewControllerで表示するViewControllerをインスタンス化
        tabContentsInfo.forEach({
            self.tabPageChildViewControllers.append(getViewController(storyboardID: $0.storyboardID))
        })

        //tabPageViewControllerの設定
        self.tabPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

        //最初に表示するViewControllerを指定する
        //pageIndex = 0
        self.tabPageViewController.setViewControllers([self.tabPageChildViewControllers[0]], direction: .forward, animated: true, completion: nil)
        tabContentsInfo[0].isSelected = true
        
        //PageViewControllerのDataSourceとの関連付け
        self.tabPageViewController.dataSource = self
        self.tabPageViewController.delegate = self
        
        //既存ViewControllerに追加
        self.addChild(self.tabPageViewController)
        self.view.addSubview(self.tabPageViewController.view!)
    }
    
    private func getViewController(storyboardID: String) -> UIViewController {
        return storyboard!.instantiateViewController(identifier: storyboardID)
    }
    
    private func changeTabPageChildViewController(targetIndex: Int) {
        let currentIndex = tabContentsInfo.firstIndex(where: { $0.isSelected == true }) ?? 0
        let direction: UIPageViewController.NavigationDirection
        if currentIndex < targetIndex {
            direction = .forward
            var array: [Int] = []
            for i in currentIndex ..< targetIndex {
                array.append(i + 1)
            }
            array.forEach({
                self.tabPageViewController.setViewControllers([self.tabPageChildViewControllers[$0]], direction: direction, animated: true, completion: nil)
            })
        } else if currentIndex > targetIndex {
            direction = .reverse
            var array: [Int] = []
            for i in targetIndex..<currentIndex {
                array.insert(i, at: 0)
            }
            array.forEach({
                self.tabPageViewController.setViewControllers([self.tabPageChildViewControllers[$0]], direction: direction, animated: true, completion: nil)
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

extension ContainerPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        //処理なし
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let index = self.tabPageChildViewControllers.firstIndex(of: pageViewController.viewControllers!.first!) {
                let currentIndex = tabContentsInfo.firstIndex(where: { $0.isSelected == true }) ?? 0
                if index != 0 || currentIndex != index {
                    //処理を書く
                }
            }
        }
    }
}
