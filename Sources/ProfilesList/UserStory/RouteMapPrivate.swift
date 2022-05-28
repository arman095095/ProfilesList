//
//  RouteMapPrivate.swift
//  
//
//  Created by Арман Чархчян on 28.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import ProfileRouteMap
import ProfilesListRouteMap
import ModelInterfaces

protocol RouteMapPrivate: AnyObject {
    func relationshipsModule() -> ProfilesListModule
    
    func profileModule(profile: ProfileModelProtocol, output: ProfileModuleOutput) -> ProfileModule
}
