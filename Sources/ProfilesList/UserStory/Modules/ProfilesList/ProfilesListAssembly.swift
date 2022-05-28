//
//  ProfilesListAssembly.swift
//  
//
//  Created by Арман Чархчян on 28.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module
import ProfilesListRouteMap

enum ProfilesListAssembly {
    static func makeModule(profilesManager: UsersManagerProtocol) -> ProfilesListModule {
        let view = ProfilesListViewController()
        let router = ProfilesListRouter()
        let interactor = ProfilesListInteractor(profilesManager: profilesManager)
        let presenter = ProfilesListPresenter(router: router, interactor: interactor)
        view.output = presenter
        interactor.output = presenter
        presenter.view = view
        router.transitionHandler = view
        return ProfilesListModule(input: presenter, view: view) {
            presenter.output = $0
        }
    }
}
