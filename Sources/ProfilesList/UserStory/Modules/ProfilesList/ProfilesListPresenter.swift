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
    func viewDidLoad()
}

final class ProfilesListPresenter {
    
    weak var view: ProfilesListViewInput?
    weak var output: ProfilesListModuleOutput?
    private let router: ProfilesListRouterInput
    private let interactor: ProfilesListInteractorInput
    private var profiles: [ProfileModelProtocol]
    
    init(router: ProfilesListRouterInput,
         interactor: ProfilesListInteractorInput) {
        self.router = router
        self.interactor = interactor
        self.profiles = []
    }
}

extension ProfilesListPresenter: ProfilesListViewOutput {
    func viewDidLoad() {
        interactor.loadFirstProfiles()
    }
}

extension ProfilesListPresenter: ProfilesListInteractorOutput {

    func successInitialLoaded(profiles: [ProfileModelProtocol]) {
        guard let profile = profiles.first else { return }
        self.profiles = profiles
        router.addChildProfile(profile: profile, output: self)
    }
    
    func successNextLoaded(profiles: [ProfileModelProtocol]) {
        self.profiles.append(contentsOf: profiles)
    }
    
    func failureLoad(message: String) {
        // TO DO
    }
}

extension ProfilesListPresenter: ProfilesListModuleInput {
    
}

extension ProfilesListPresenter: ProfilesListRouterOutput {
    func childAdded(viewController: UIViewController) {
        view?.addSubview(viewController.view)
    }
}

extension ProfilesListPresenter: ProfileModuleOutput {

    func ignoredProfile() {
        
    }
    
    func deniedProfile() {
        
    }
    
    func acceptedProfile() {
        
    }
    
    func requestedProfile() {
        
    }
}
