//
//  OrderVC.swift
//  customSwipableTabbarTutorial
//
//  Created by Dustin on 2021/01/22.
//

import UIKit

class OrderVC: UIViewController {
    
    let tabsView = TabsView()
    
    var pageIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.addSubview(tabsView)
        tabsView.anchor(top:view.topAnchor,left: view.leftAnchor,right: view.rightAnchor,height: 55)
        view.backgroundColor = .gray
    }

}
