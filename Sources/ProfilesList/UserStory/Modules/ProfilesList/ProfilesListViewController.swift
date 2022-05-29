//
//  ProfilesListViewController.swift
//  
//
//  Created by Арман Чархчян on 28.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import DesignSystem

protocol ProfilesListViewInput: AnyObject {
    func setupInitialState()
    func setLoad(on: Bool)
}

final class ProfilesListViewController: UIPageViewController {
    var output: ProfilesListViewOutput?
    private let activityIndicator: CustomActivityIndicator = {
        let view = CustomActivityIndicator()
        view.strokeColor = UIColor.mainApp()
        view.lineWidth = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
}

extension ProfilesListViewController: ProfilesListViewInput {

    func setupInitialState() {
        setupActivity()
    }
    
    func setLoad(on: Bool) {
        DispatchQueue.main.async {
            if on {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startLoading()
            } else {
                self.activityIndicator.completeLoading(success: true)
                self.activityIndicator.isHidden = true
            }
        }
    }
}

private extension ProfilesListViewController {
    func setupActivity() {
        view.addSubview(activityIndicator)
        activityIndicator.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIScreen.main.bounds.height/2).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.constraint(equalTo: CGSize(width: 40, height: 40))
    }
}
