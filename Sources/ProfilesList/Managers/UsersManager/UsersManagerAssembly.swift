//
//  ProfilesManagerAssembly.swift
//  
//
//  Created by Арман Чархчян on 22.04.2022.
//

import Foundation
import Swinject
import NetworkServices

final class UsersManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UsersManagerProtocol.self) { r in
            guard let profilesService = r.resolve(ProfilesNetworkServiceProtocol.self), let userID = r.resolve(QuickAccessManagerProtocol.self)?.userID else { fatalError(ErrorMessage.dependency.localizedDescription) }
            return UsersManager(accountID: userID, profileService: profilesService)
        }.inObjectScope(.weak)*/
    }
}
