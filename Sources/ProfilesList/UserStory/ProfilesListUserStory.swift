//
//  ProfilesListUserStory.swift
//  
//
//  Created by Арман Чархчян on 28.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Swinject
import Foundation
import Module
import ProfileRouteMap
import ProfilesListRouteMap
import UserStoryFacade
import ModelInterfaces

public final class ProfilesListUserStory {
    private let container: Container
    public init(container: Container) {
        self.container = container
    }
}

extension ProfilesListUserStory: ProfilesListRouteMap {
    public func rootModule() -> ProfilesListModule {
        relationshipsModule()
    }
}

extension ProfilesListUserStory: RouteMapPrivate {
    func relationshipsModule() -> ProfilesListModule {
        guard let profilesManager = container.resolve(UsersManagerProtocol.self) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        let module = ProfilesListAssembly.makeModule(profilesManager: profilesManager)
        return module
    }
    
    func profileModule(profile: ProfileModelProtocol, output: ProfileModuleOutput) -> ProfileModule {
        guard let module = container.synchronize().resolve(UserStoryFacadeProtocol.self)?.profile?.someAccountModule(profile: profile) else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        module.output = output
        return module
    }
}

enum ErrorMessage: LocalizedError {
    case dependency
}
