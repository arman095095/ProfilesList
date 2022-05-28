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
import AlertManager

protocol ProfilesListViewOutput: AnyObject {
    func viewDidLoad()
}

protocol ProfilesListStringFactoryProtocol {
    var emptyMessage: String { get }
}

final class ProfilesListPresenter {
    
    weak var view: ProfilesListViewInput?
    weak var output: ProfilesListModuleOutput?
    private let router: ProfilesListRouterInput
    private let interactor: ProfilesListInteractorInput
    private let stringFactory: ProfilesListStringFactoryProtocol
    private let alertManager: AlertManagerProtocol
    private var profiles: [ProfileModelProtocol]
    private var index: Int
    
    init(router: ProfilesListRouterInput,
         interactor: ProfilesListInteractorInput,
         alertManager: AlertManagerProtocol,
         stringFactory: ProfilesListStringFactoryProtocol) {
        self.router = router
        self.interactor = interactor
        self.alertManager = alertManager
        self.stringFactory = stringFactory
        self.index = 0
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
        self.profiles = profiles
        guard let profile = profiles.first else {
            alertManager.present(type: .error, title: stringFactory.emptyMessage)
            router.addChildEmptyModule(output: self)
            return
        }
        router.addChildProfileModule(profile: profile, output: self)
    }
    
    func successNextLoaded(profiles: [ProfileModelProtocol]) {
        self.profiles.append(contentsOf: profiles)
    }
    
    func failureLoad(message: String) {
        alertManager.present(type: .error, title: message)
    }
}

extension ProfilesListPresenter: ProfilesListModuleInput {
    
}

extension ProfilesListPresenter: EmptyViewOutput {
    func initialLoad() {
        index = 0
        interactor.loadFirstProfiles()
    }
}

extension ProfilesListPresenter: ProfileModuleOutput {

    func ignoredProfile() {
        loadNextProfilesIfNeeded()
        nextProfile()
    }
    
    func deniedProfile() {
        loadNextProfilesIfNeeded()
        nextProfile()
    }
    
    func acceptedProfile() {
        loadNextProfilesIfNeeded()
        nextProfile()
    }
    
    func requestedProfile() {
        loadNextProfilesIfNeeded()
        nextProfile()
    }
}

private extension ProfilesListPresenter {

    func loadNextProfilesIfNeeded() {
        if index == profiles.count - (UsersManager.Limits.users.rawValue/2) {
            interactor.loadNextProfiles()
        }
    }

    func nextProfile() {
        if index == profiles.count - 1 {
            router.addChildEmptyModule(output: self)
            return
        }
        index += 1
        router.addChildProfileModule(profile: profiles[index], output: self)
    }
}
