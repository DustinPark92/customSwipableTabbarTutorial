//
//  TabsView.swift
//  customSwipableTabbarTutorial
//
//  Created by Dustin on 2021/01/22.
//


import UIKit

protocol TabsDelegate {
    func tabsViewDidSelectItemAt(position: Int)
}

enum TabMode {
    case fixed
    case scrollable
}

struct Tab {
    var icon: UIImage?
    var title: String
}

class TabsView: UIView {
    var tabMode: TabMode = .scrollable {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var tabs: [Tab] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var titleColor: UIColor = .black {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var titleFont: UIFont = UIFont.systemFont(ofSize: 20, weight: .regular) {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var iconColor: UIColor = .black {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var indicatorColor: UIColor = .black {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var collectionView: UICollectionView!
    
    var delegate: TabsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createView()
    }
    
    private func createView() {
        // Create Flow Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        // Create CollectionView
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TabCell.self, forCellWithReuseIdentifier: "TabCell")
        addSubview(collectionView)
        
        // ColletionView Constraints
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}

extension TabsView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCell", for: indexPath) as? TabCell else {
            return UICollectionViewCell()
        }
        cell.tabViewModel = Tab(icon: tabs[indexPath.item].icon, title: tabs[indexPath.item].title)
        
        // Change Icon Color
        cell.tabIcon.image = cell.tabIcon.image?.withRenderingMode(.alwaysTemplate)
        cell.tabIcon.tintColor = iconColor
        
        // Change Title Color
        cell.tabTitle.font = titleFont
        cell.tabTitle.textColor = titleColor
        cell.indicatorColor = indicatorColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.tabsViewDidSelectItemAt(position: indexPath.item)
    }
}

extension TabsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch tabMode {
        case .scrollable:
            let tabSize = CGSize(width: 500, height: self.frame.height)
            let tabTitle = tabs[indexPath.item].title
            
            // Add more space left and right the tab
            var addSpace: CGFloat = 20
            if tabs[indexPath.item].icon != nil {
                // Icon exist, add space for the icon width
                addSpace += 40
            }
            // Calculate the width of the Tab Title string
            let titleWidth = NSString(string: tabTitle).boundingRect(with: tabSize, options: .usesLineFragmentOrigin, attributes: [.font: titleFont], context: nil).size.width
            
            let tabWidth = titleWidth + addSpace
            
            return CGSize(width: tabWidth, height: self.frame.height)
        case .fixed:
            return CGSize(width: self.frame.width / CGFloat(tabs.count), height: self.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}



extension UIView {
    
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        paddingTop : CGFloat = 0,
        paddingLeft : CGFloat = 0,
        paddingBottom : CGFloat = 0,
        paddingRight : CGFloat = 0,
        width: CGFloat? = nil,
        height: CGFloat? = nil) {
        
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    
    
    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo:view.centerYAnchor , constant: yConstant!).isActive = true
        
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil,bottomAnchor:NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0,paddingBottm: CGFloat? = 0 ) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
        
        if let bottomAnchor = bottomAnchor{
            self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -paddingBottm!).isActive = true
        }
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat? = nil,
                 constant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant!).isActive = true
        
        if let leftAnchor = leftAnchor, let padding = paddingLeft {
            
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        }
    }
    
    
    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func addConstraintsToFillView(_ view: UIView) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    func makeAborderWidth(border: CGFloat, color: CGColor) {
        
        self.layer.borderColor = color
        self.layer.borderWidth = border
        
    }
    
    func makeAcircle( dimension : Int) {
        
        self.layer.cornerRadius = CGFloat(dimension / 2)
        self.clipsToBounds = true
        self.setDimensions(width: CGFloat(dimension), height: CGFloat(dimension))
        
        
    }
    
    func makeAborder(radius: Int) {
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
    }
}
