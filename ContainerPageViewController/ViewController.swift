//
//  ViewController.swift
//  ContainerPageViewController
//
//  Created by Masaki Horimoto on 2022/02/06.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak private var containerParentView: UIView!
    @IBOutlet weak private var TabCollectionView: UICollectionView!
    @IBOutlet weak private var TabCollectionViewFromLayout: UICollectionViewFlowLayout!
    private var containerPageView: ContainerPageView!
    
    //TabCollectionViewで表示するTabボタンのラベルとそれに紐づくStoryboardID
    //以下に設定したTabボタンのラベル用の文字列とそれに紐づくUIViewControllerのStoryboarIDによってcontainerPageViewに表示されるものが決まる
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
    
    //containerPageViewController内で表示しているページの内容の管理は本VCにて行う
    private var tabContentsInfomations: [TabPageContetntInfo] = []
    private struct TabPageContetntInfo {
        let tabButtonLabel: String
        let storyboardID: String
        var isSelected: Bool = false
        init(tabButtonLabel: String, storyboardID: String) {
            self.tabButtonLabel = tabButtonLabel
            self.storyboardID = storyboardID
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ContainerPageViewを追加
        containerPageView = ContainerPageView(frame: CGRect.zero, tabButtonLabelStoryboardIDInfomations: tabButtonLabelStoryboardIDInfomations)
        containerParentView.addSubview(containerPageView)
        
        //ConttainerPageViewの表示位置をStoryboardで配置しているcontainerParentViewと一致させる
        containerPageView.setSameConstraint(equalTo: containerParentView)
        
        //containerPageViewDelegateを設定
        containerPageView.delegate = self
        
        //TabCollectionView初期化
        self.initTabCollectionView()
    }
}

//TabCollectionView初期化
extension ViewController {
    private func initTabCollectionView() {
        //TabCollectionViewのdelegateを設定
        TabCollectionView.delegate = self
        TabCollectionView.dataSource = self
        
        //Tabの表示文字列と紐づくStoryboardIDを配列にセットする
        tabButtonLabelStoryboardIDInfomations.forEach({
            self.tabContentsInfomations.append(TabPageContetntInfo.init(tabButtonLabel: $0.tabButtonLabel, storyboardID: $0.storyboardID))
        })
        
        if !tabContentsInfomations.isEmpty {
            //選択Tabの初期値をセット(0番目)
            tabContentsInfomations[0].isSelected = true
        }
        
        //TabCollectionViewのUI設定
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
        //TabCollectionViewを選択Tabにスクロールする
        TabCollectionView.scrollToItem(at: IndexPath(row: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
        
        //containerPageViewControllerの中の表示ページを切り替える
        let currentIndex = tabContentsInfomations.firstIndex(where: { $0.isSelected == true }) ?? 0
        containerPageView.changeContainerPageViewController(targetIndex: indexPath.row, currentIndex: currentIndex)
        setSelectedTabContentsInfo(index: indexPath.row)    //現在選択されているタブ情報を更新
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
    //ContainerPageViewをスワイプ完了後に実行される
    func containerPageView(selectedIndexAfterSwipe: Int) {
            TabCollectionView.scrollToItem(at: IndexPath(row: selectedIndexAfterSwipe, section: 0), at: .centeredHorizontally, animated: true)
            setSelectedTabContentsInfo(index: selectedIndexAfterSwipe)
    }
}

