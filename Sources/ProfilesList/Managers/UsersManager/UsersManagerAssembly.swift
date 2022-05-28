//
//  ProfilesManagerAssembly.swift
//  
//
//  Created by Арман Чархчян on 22.04.2022.
//

import Foundation
import Swinject
import NetworkServices
import Managers
import ModelInterfaces

final class UsersManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UsersManagerProtocol.self) { r in
            guard let profilesService = r.resolve(ProfilesNetworkServiceProtocol.self),
                  let profileInfoService = r.resolve(ProfileInfoNetworkServiceProtocol.self),
                  let profileStateDetermintator = r.resolve(ProfileStateDeterminatorProtocol.self),
                  let account = r.resolve(AccountModelProtocol.self),
                  let userID = r.resolve(QuickAccessManagerProtocol.self)?.userID else { fatalError(ErrorMessage.dependency.localizedDescription) }
            return UsersManager(accountID: userID,
                                account: account,
                                profilesService: profilesService,
                                profileInfoService: profileInfoService,
                                profileStateDeterminator: profileStateDetermintator)
        }.inObjectScope(.weak)
    }
}
