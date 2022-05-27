//
//  File.swift
//  
//
//  Created by Арман Чархчян on 27.05.2022.
//

import ModelInterfaces
import Foundation

final class ProfileModel: ProfileModelProtocol {
    var userName: String
    var info: String
    var sex: String
    var imageUrl: String
    var id: String
    var country: String
    var city: String
    var birthday: String
    var removed: Bool
    var online: Bool
    var lastActivity: Date?
    var postsCount: Int
    
    init(profile: ProfileNetworkModelProtocol) {
        self.userName = profile.userName
        self.info = profile.info
        self.sex = profile.sex
        self.imageUrl = profile.imageUrl
        self.id = profile.id
        self.country = profile.country
        self.city = profile.city
        self.birthday = profile.birthday
        self.removed = profile.removed
        self.online = profile.online
        self.lastActivity = profile.lastActivity
        self.postsCount = profile.postsCount
    }
}
