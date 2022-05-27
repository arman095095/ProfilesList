//
//  File.swift
//  
//
//  Created by Арман Чархчян on 27.05.2022.
//

import Swinject
import FirebaseFirestore

final class ProfilesNetworkServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ProfilesNetworkServiceProtocol.self) { r in
            ProfilesNetworkService(networkService: Firestore.firestore())
        }.inObjectScope(.weak)
    }
}
