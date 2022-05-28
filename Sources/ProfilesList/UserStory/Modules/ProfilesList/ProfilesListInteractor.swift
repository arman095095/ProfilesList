//
//  ProfilesListInteractor.swift
//  
//
//  Created by Арман Чархчян on 28.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import ModelInterfaces

protocol ProfilesListInteractorInput: AnyObject {
    func loadFirstProfiles()
    func loadNextProfiles()
}

protocol ProfilesListInteractorOutput: AnyObject {
    func successInitialLoaded(profiles: [ProfileModelProtocol])
    func successNextLoaded(profiles: [ProfileModelProtocol])
    func failureLoad(message: String)
}

final class ProfilesListInteractor {
    
    weak var output: ProfilesListInteractorOutput?
    private let profilesManager: UsersManagerProtocol
    
    init(profilesManager: UsersManagerProtocol) {
        self.profilesManager = profilesManager
    }
}

extension ProfilesListInteractor: ProfilesListInteractorInput {
    func loadFirstProfiles() {
        profilesManager.getFirstProfiles { [weak self] result in
            switch result {
            case .success(let profiles):
                self?.output?.successInitialLoaded(profiles: profiles)
            case .failure(let error):
                self?.output?.failureLoad(message: error.localizedDescription)
            }
        }
    }
    
    func loadNextProfiles() {
        profilesManager.getNextProfiles { [weak self] result in
            switch result {
            case .success(let profiles):
                self?.output?.successNextLoaded(profiles: profiles)
            case .failure(let error):
                self?.output?.failureLoad(message: error.localizedDescription)
            }
        }
    }
}
