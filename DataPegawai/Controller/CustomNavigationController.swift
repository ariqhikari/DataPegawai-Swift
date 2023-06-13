//
//  CustomNavigationController.swift
//  DataPegawai
//
//  Created by Ariq Hikari on 13/06/23.
//

import UIKit

class CustomNavigationController: UINavigationController {
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    navBarAppearance.backgroundColor = UIColor(displayP3Red: 47/255, green: 54/255, blue: 64/255, alpha: 1.0)
    
    navigationBar.prefersLargeTitles = true
    navigationBar.standardAppearance = navBarAppearance
    navigationBar.scrollEdgeAppearance = navBarAppearance
  }
}
