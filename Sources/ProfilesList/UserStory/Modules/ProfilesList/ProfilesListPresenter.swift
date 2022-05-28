//
//  ProfilesListPresenter.swift
//  
//
//  Created by Арман Чархчян on 28.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import ProfilesListRouteMap
import ProfileRouteMap
import ModelInterfaces

protocol ProfilesListViewOutput: AnyObject {
    
}

final class ProfilesListPresenter {
    
    weak var view: ProfilesListViewInput?
    weak var output: ProfilesListModuleOutput?
    private let router: ProfilesListRouterInput
    private let interactor: ProfilesListInteractorInput
    
    init(router: ProfilesListRouterInput,
         interactor: ProfilesListInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension ProfilesListPresenter: ProfilesListViewOutput {
    
}

extension ProfilesListPresenter: ProfilesListInteractorOutput {

    func successInitialLoaded(profiles: [ProfileModelProtocol]) {
    }
    
    func successNextLoaded(profiles: [ProfileModelProtocol]) {
    }
    
    func failureLoad(message: String) {
    }
}

extension ProfilesListPresenter: ProfilesListModuleInput {
    
}
