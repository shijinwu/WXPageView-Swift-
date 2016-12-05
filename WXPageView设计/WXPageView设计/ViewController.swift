//
//  ViewController.swift
//  WXPageView设计
//
//  Created by mac on 2016/12/4.
//  Copyright © 2016年 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        automaticallyAdjustsScrollViewInsets = false
        
        // 1.标题
        let titles = ["推荐", "热点", "视频", "北京", "社会", "娱乐", "图片", "科技","汽车","体育"]
       // let titles = ["推荐", "手游", "娱乐", "游戏", "趣玩"]
        let style = WXTileStyle()
        style.isScrollEnable = true
        style.isShowScrollLine = true
        // style.titleHeight = 44
        
        // 2.所以得子空间器
        var childVcs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVcs.append(vc)
        }
        
        // 3.pageView的frame
        let pageFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height-64)
        
        // 4.创建HYPageView,并且添加到控制器的view中
        let pageView = WXPageView(frame: pageFrame, titles: titles, childVcs: childVcs, parentVc: self, style : style)
        view.addSubview(pageView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

