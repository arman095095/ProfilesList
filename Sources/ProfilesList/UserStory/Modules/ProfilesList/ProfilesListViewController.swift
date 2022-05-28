//
//  ProfilesListViewController.swift
//  
//
//  Created by Арман Чархчян on 28.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProfilesListViewInput: AnyObject {
    func addSubview(_ view: UIView)
}

final class ProfilesListViewController: UIViewController {
    var output: ProfilesListViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
}

extension ProfilesListViewController: ProfilesListViewInput {
    func addSubview(_ view: UIView) {
        self.view.addSubview(view)
        view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
}
