//
//  ProfilesListRouter.swift
//  
//
//  Created by Арман Чархчян on 28.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import ProfileRouteMap
import ModelInterfaces

protocol ProfilesListRouterInput: AnyObject {
    func addChildProfileModule(profile: ProfileModelProtocol, output: ProfileModuleOutput)
    func addChildEmptyModule(output: EmptyViewOutput)
}

final class ProfilesListRouter {
    weak var transitionHandler: UIPageViewController?
    private let routeMap: RouteMapPrivate
    
    init(routeMap: RouteMapPrivate) {
        self.routeMap = routeMap
    }
}

extension ProfilesListRouter: ProfilesListRouterInput {
    func addChildProfileModule(profile: ProfileModelProtocol, output: ProfileModuleOutput) {
        let module = routeMap.profileModule(profile: profile, output: output)
        transitionHandler?.setViewControllers([module.view], direction: .forward, animated: true)
    }
    
    func addChildEmptyModule(output: EmptyViewOutput) {
        let view = EmptyViewController()
        view.output = output
        transitionHandler?.setViewControllers([view], direction: .forward, animated: true)
    }
}
