//
//  WXPageView.swift
//  WXPageView设计
//
//  Created by mac on 2016/12/4.
//  Copyright © 2016年 mac. All rights reserved.
//

import UIKit

class WXPageView: UIView {

    fileprivate var titles : [String]
    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    fileprivate var style : WXTileStyle
    
    fileprivate var titleView : WXTitleView!
    
    init(frame: CGRect,titles:[String],childVcs:[UIViewController],parentVc:UIViewController,style:WXTileStyle) {
    
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.style = style
        
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   }

// MARK:- 设置UI界面
extension WXPageView{
    
    fileprivate func setupUI() {
        setupTitleView()
        setupContentView()
    }
    
    private func setupTitleView() {
        
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        titleView = WXTitleView(frame: titleFrame, titles: titles,style:style)
        addSubview(titleView)
        titleView.backgroundColor = UIColor.randomColor()
    }
    
    private func setupContentView() {
        // ?.取到类型一定是可选类型
        let contentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = WXContentVIew(frame: contentFrame, childVcs: childVcs, parentVc: parentVc)
        
        titleView.delegate = contentView
        contentView.delegate = titleView
        addSubview(contentView)
        contentView.backgroundColor = UIColor.randomColor()
    }

}
