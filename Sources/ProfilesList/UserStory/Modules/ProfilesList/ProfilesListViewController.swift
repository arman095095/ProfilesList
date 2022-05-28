//
//  ProfilesListViewController.swift
//  
//
//  Created by Арман Чархчян on 28.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProfilesListViewInput: AnyObject {
    func setupInitialState()
}

final class ProfilesListViewController: UIPageViewController {
    var output: ProfilesListViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
}

extension ProfilesListViewController: ProfilesListViewInput {
    func setupInitialState() {
        self.delegate = self
        self.dataSource = self
    }
}

extension ProfilesListViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
}

