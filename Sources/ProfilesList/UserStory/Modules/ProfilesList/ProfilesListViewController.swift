//
//  ProfilesListViewController.swift
//  
//
//  Created by Арман Чархчян on 28.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProfilesListViewInput: AnyObject {
    
}

final class ProfilesListViewController: UIViewController {
    var output: ProfilesListViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension ProfilesListViewController: ProfilesListViewInput {
    
}
