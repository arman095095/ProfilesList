//
//  File.swift
//  
//
//  Created by Арман Чархчян on 27.05.2022.
//

import Foundation

enum GetUserInfoError: LocalizedError {
    case getData
    case convertData
    
    var errorDescription: String? {
        switch self {
        case .getData:
            return NSLocalizedString("Ошибка получения данных", comment: "")
        case .convertData:
            return NSLocalizedString("Ошибка конвертации данных", comment: "")
        }
    }
}
