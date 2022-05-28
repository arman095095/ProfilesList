//
//  ProfilesListUserStoryAssembly.swift
//  
//
//  Created by Арман Чархчян on 28.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Swinject
import ProfilesListRouteMap

public final class ProfilesListUserStoryAssembly: Assembly {
    
    public init() { }

    public func assemble(container: Container) {
        ProfileInfoNetworkServiceAssembly().assemble(container: container)
        ProfilesNetworkServiceAssembly().assemble(container: container)
        ProfileStateDeterminatorAssembly().assemble(container: container)
        UsersManagerAssembly().assemble(container: container)
        container.register(ProfilesListRouteMap.self) { r in
            ProfilesListUserStory(container: container)
        }
    }
}
