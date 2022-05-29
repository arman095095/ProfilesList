//
//  File.swift
//  
//
//  Created by Арман Чархчян on 28.05.2022.
//

import Foundation

struct ProfilesListStringFactory: EmptyViewStringFactoryProtocol,
                                  ProfilesListStringFactoryProtocol {
    var emptyMessage: String = "Профилей больше нет"
    var title: String = "К сожалению, Вы просмотрели все профили"
    var description: String = "Но вы можете попробовать начать все заново"
    var buttonTitle: String = "Начать заново"
    var successMessage: String = "Поздравляем, у Вас образовалась новая пара"
}
