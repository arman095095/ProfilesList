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
import AlertManager

enum ProfilesListAssembly {
    static func makeModule(profilesManager: UsersManagerProtocol,
                           alertManager: AlertManagerProtocol,
                           routeMap: RouteMapPrivate) -> ProfilesListModule {
        let view = ProfilesListViewController()
        let router = ProfilesListRouter(routeMap: routeMap)
        let interactor = ProfilesListInteractor(profilesManager: profilesManager)
        let stringFactory = ProfilesListStringFactory()
        let presenter = ProfilesListPresenter(router: router,
                                              interactor: interactor,
                                              alertManager: alertManager,
                                              stringFactory: stringFactory)
        view.output = presenter
        interactor.output = presenter
        presenter.view = view
        router.transitionHandler = view
        return ProfilesListModule(input: presenter, view: view) {
            presenter.output = $0
        }
    }
}
