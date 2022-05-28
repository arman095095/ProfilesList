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
    func addChildProfile(profile: ProfileModelProtocol, output: ProfileModuleOutput)
}

protocol ProfilesListRouterOutput: AnyObject {
    func childAdded(viewController: UIViewController)
}

final class ProfilesListRouter {
    weak var transitionHandler: UIViewController?
    weak var output: ProfilesListRouterOutput?
    private let routeMap: RouteMapPrivate
    
    init(routeMap: RouteMapPrivate) {
        self.routeMap = routeMap
    }
}

extension ProfilesListRouter: ProfilesListRouterInput {
    func addChildProfile(profile: ProfileModelProtocol, output: ProfileModuleOutput) {
        let module = routeMap.profileModule(profile: profile, output: output)
        transitionHandler?.addChild(module.view)
        self.output?.childAdded(viewController: module.view)
        module.view.didMove(toParent: transitionHandler)
    }
}
