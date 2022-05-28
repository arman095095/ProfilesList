//
//  ProfilesListRouter.swift
//  
//
//  Created by Арман Чархчян on 28.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProfilesListRouterInput: AnyObject {

}

final class ProfilesListRouter {
    weak var transitionHandler: UIViewController?
}

extension ProfilesListRouter: ProfilesListRouterInput {
    
}
