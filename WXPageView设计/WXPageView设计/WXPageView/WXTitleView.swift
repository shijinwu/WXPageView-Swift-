//
//  WXTitleView.swift
//  WXPageView设计
//
//  Created by mac on 2016/12/4.
//  Copyright © 2016年 mac. All rights reserved.
//

import UIKit


protocol WXTitleViewDelegate:class {
    
    func titleView(_ titleView:WXTitleView,targetIndex:Int)
}


class WXTitleView: UIView {
    
    var isTaping:Bool = false
    
    weak var delegate:WXTitleViewDelegate?

    fileprivate var titles : [String]
    fileprivate var style : WXTileStyle
    
    fileprivate  lazy var  currentIndex:Int = 0
    
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    
    
    fileprivate lazy var scrollView : UIScrollView = {
        
        let scrollView = UIScrollView(frame:self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        
        return scrollView
        
    }()
    
    fileprivate lazy var bottomLine : UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.scrollLineColor
        bottomLine.frame.size.height = self.style.scrollLineHeight
        bottomLine.frame.origin.y = self.bounds.height - self.style.scrollLineHeight
        return bottomLine
    }()

    
    
    init(frame: CGRect, titles : [String],style:WXTileStyle) {
        self.titles = titles
        self.style = style
    
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension WXTitleView {
    
    fileprivate func setupUI(){
        
        
        // 1.将UIScrollVIew添加到view中
        addSubview(scrollView)
        
        // 2.将titleLabel添加到UIScrollView中
        setupTitleLabels()
        
        // 3.设置titleLabel的frame
        setupTitleLabelsFrame()

        // 4.添加滚动条
        if style.isShowScrollLine {
            scrollView.addSubview(bottomLine)
        }
        
    }
    
    private func setupTitleLabels(){
        
        
        for (i, title) in titles.enumerated() {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.systemFont(ofSize: style.fontSize)
            titleLabel.tag = i
            titleLabel.textAlignment = .center
            titleLabel.textColor = i == 0 ? style.selectColor : style.normalColor
            
            titleLabel.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action:#selector(titleLabelClick(_:)))
            titleLabel.addGestureRecognizer(tap)
            
            
            scrollView.addSubview(titleLabel)
            
            titleLabels.append(titleLabel)
        }
    }



   private func setupTitleLabelsFrame(){
    
        let count = titles.count
        for (i,label) in titleLabels.enumerated(){
            var w:CGFloat = 0
            let h:CGFloat = bounds.height
            var x:CGFloat = 0
            let y:CGFloat = 0
            
            
          
            if style.isScrollEnable{
                
                w = (titles[i] as NSString).boundingRect(with:CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:label.font], context: nil).width
                
                if i == 0 {
                    x = style.itemMargin * 0.5
                    
                    if style.isShowScrollLine {
                        bottomLine.frame.origin.x = x
                        bottomLine.frame.size.width = w
                    }
                }
                else{
                    let preLabel = titleLabels[i - 1]
                    x = preLabel.frame.maxX + style.itemMargin
                }
                
            }
            else{
                
                w = bounds.width/CGFloat(count)
                x = w*CGFloat(i)
                
                if i == 0 && style.isShowScrollLine {
                    bottomLine.frame.origin.x = 0
                    bottomLine.frame.size.width = w
                }
            }
            
            
        label.frame = CGRect(x: x, y: y, width: w, height: h)
           
        }
    
        scrollView.contentSize = style.isScrollEnable ? CGSize(width: titleLabels.last!.frame.maxX + style.itemMargin * 0.5, height: 0) : CGSize.zero
        
        
    }

}


// MARK: - 监听titleLabel点击事件
extension WXTitleView{
    
    @objc fileprivate func titleLabelClick(_ tapGes:UITapGestureRecognizer){
        
        isTaping = true
        
        let targetLabel = tapGes.view as! UILabel
        
        
        adjustTitleLabel(targetIndex: targetLabel.tag)
        
        
        delegate?.titleView(self, targetIndex: currentIndex)
        
 
        isTaping = false
    }
    
    fileprivate func adjustTitleLabel(targetIndex : Int) {
        
        if targetIndex == currentIndex { return }
        
        // 1.取出Label
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        // 2.切换文字的颜色
        sourceLabel.textColor = style.normalColor
        targetLabel.textColor = style.selectColor
       
        
        // 3.记录下标值
        currentIndex = targetIndex
        
        // 4.调整位置
        if style.isScrollEnable {
            var offsetX = targetLabel.center.x - scrollView.bounds.width * 0.5
            if offsetX < 0 {
                offsetX = 0
            }
            if offsetX > (scrollView.contentSize.width - scrollView.bounds.width) {
                offsetX = scrollView.contentSize.width - scrollView.bounds.width
            }
            scrollView.setContentOffset(CGPoint(x: offsetX, y : 0), animated: true)
        }
        
        // 3.调整bottomLine
        if style.isShowScrollLine {
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.width
            })
        }
    }

}

// MARK: - 遵守WXContentViewDelegate
extension WXTitleView:WXContentViewDelegate{
    
    func contentView(_ contentView: WXContentVIew, targetIndex: Int) {
        
        adjustTitleLabel(targetIndex: targetIndex)
        
    }
    
    func contentView(_ contentView: WXContentVIew, targetIndex: Int, progress: CGFloat) {
        
        guard !isTaping else {
            return
        }
        
        // 1.取出Label
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        // 2.颜色渐变
        let deltaRGB = UIColor.getRGBDelta(style.selectColor, style.normalColor)
        let selectRGB = style.selectColor.getRGB()
        let normalRGB = style.normalColor.getRGB()
        targetLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        sourceLabel.textColor = UIColor(r: selectRGB.0 - deltaRGB.0 * progress, g: selectRGB.1 - deltaRGB.1 * progress, b: selectRGB.2 - deltaRGB.2 * progress)
        
        
        // 3.bottomLine渐变过程
        if style.isShowScrollLine {
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
            bottomLine.frame.size.width = sourceLabel.frame.width + deltaW * progress
        }
    }
}
