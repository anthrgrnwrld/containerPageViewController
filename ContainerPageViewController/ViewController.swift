//
//  ViewController.swift
//  ContainerPageViewController
//
//  Created by Masaki Horimoto on 2022/02/06.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var ContainerPageView: ContainerPageView!
    @IBOutlet weak var TabCollectionView: UICollectionView!
    @IBOutlet weak var TabCollectionViewFromLayout: UICollectionViewFlowLayout!
    
    private var containerPageViewController: ContainerPageViewController?
    private var tabContentsInfomations: [TabPageContetntInfo] = []  //containerPageViewController内で表示しているページの内容の管理は本VCにて行う
    
    private struct TabPageContetntInfo {
        let tabButtonLabel: String
        let storyboardID: String
        var isSelected: Bool = false
        init(tabButtonLabel: String, storyboardID: String) {
            self.tabButtonLabel = tabButtonLabel
            self.storyboardID = storyboardID
        }
    }
    
    //TabCollectionViewで表示するボタンのラベルとそれに紐づくstoryboardID
    private let tabButtonLabelStoryboardIDInfomations: [TabButtonLabelStoryboardIDInfo] = [
        ("1.First","FirstViewController"),
        ("2.Second","SecondViewController"),
        ("3.Third","ThirdViewController"),
        ("4.First","FirstViewController"),
        ("5.Second","SecondViewController"),
        ("6.Third","ThirdViewController"),
        ("7.First","FirstViewController"),
        ("8.Second","SecondViewController"),
        ("9.Third","ThirdViewController"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //TabCollectionView初期化
        self.initTabCollectionView()
        
        self.ContainerPageView.delegate = self
    }

    @IBSegueAction func segeActionContainerPageViewController(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> ContainerPageViewController? {
        ContainerPageView.containerPageViewController =  ContainerPageViewController(coder: coder, tabButtonLabelStoryboardIDInfomations: tabButtonLabelStoryboardIDInfomations, testPram: "OK!!!!!!!!!!!!!!")
        ContainerPageView.containerPageViewController!.delegate = ContainerPageView
        return ContainerPageView.containerPageViewController
        
    }
}

//TabCollectionView初期化
extension ViewController {
    private func initTabCollectionView() {
        TabCollectionView.delegate = self
        TabCollectionView.dataSource = self
        ContainerPageView.delegate = self
        
//        containerPageViewController?.tabPageViewController.delegate = self
        
        tabButtonLabelStoryboardIDInfomations.forEach({
            self.tabContentsInfomations.append(TabPageContetntInfo.init(tabButtonLabel: $0.tabButtonLabel, storyboardID: $0.storyboardID))
        })
        
        tabContentsInfomations[0].isSelected = true
        
        let height = TabCollectionView.frame.height
        let width = height * 3
        TabCollectionViewFromLayout.estimatedItemSize = CGSize(width: width, height: height)
        TabCollectionViewFromLayout.scrollDirection = .horizontal   // 横スクロール
        TabCollectionViewFromLayout.minimumLineSpacing = 1          //列間
        TabCollectionViewFromLayout.minimumInteritemSpacing = 1     //Section間 (0にしたら横向きにしたら表示がおかしくなる)
    }
    
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        TabCollectionView.scrollToItem(at: IndexPath(row: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
        
        //containerPageViewControllerの中の表示ページを切り替える
        let currentIndex = tabContentsInfomations.firstIndex(where: { $0.isSelected == true }) ?? 0
        containerPageViewController?.changeTabPageChildViewController(targetIndex: indexPath.row, currentIndex: currentIndex)
        
        setSelectedTabContentsInfo(index: indexPath.row)
    }
    
    
    private func setSelectedTabContentsInfo(index: Int) {
        tabContentsInfomations.enumerated().forEach({
            tabContentsInfomations[$0.offset].isSelected = false
        })
        tabContentsInfomations[index].isSelected = true
        TabCollectionView.reloadData()
    }
    

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabContentsInfomations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TabItemCollectionViewCell
        cell.backgroundColor = UIColor.lightGray
        cell.TabPageLabel.textColor = UIColor.black
        cell.TabPageLabel.font = UIFont.systemFont(ofSize: 17)
        
        if tabContentsInfomations[indexPath.row].isSelected == true {
            cell.TabPageLabel.textColor = UIColor.systemBlue
            cell.TabPageLabel.font = UIFont.systemFont(ofSize: 17)
        }
        //cell.layer.cornerRadius = 10
        cell.TabPageLabel.text = tabContentsInfomations[indexPath.row].tabButtonLabel
        return cell
    }
}

extension ViewController: ContainerPageViewDelegate {
    func containerPageView(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let index = ContainerPageView.containerPageViewController!.tabPageChildViewControllers.firstIndex(of: pageViewController.viewControllers!.first!) {
//                let currentIndex = tabContentsInfo.firstIndex(where: { $0.isSelected == true }) ?? 0
//                if index != 0 || currentIndex != index {
//                    //タブの選択系の処理を書く処理を書く
//                }
                print("AAAAAAAAAAAAAAA")
            }
        }
    }
}

