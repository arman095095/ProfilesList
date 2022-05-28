//
//  File.swift
//  
//
//  Created by Арман Чархчян on 17.04.2022.
//

import Foundation
import NetworkServices
import ModelInterfaces
import Services

protocol UsersManagerProtocol: AnyObject {
    func getFirstProfiles(completion: @escaping (Result<[ProfileModelProtocol], Error>) -> Void)
    func getNextProfiles(completion: @escaping (Result<[ProfileModelProtocol], Error>) -> Void)
}

final class UsersManager {
    
    enum Limits: Int {
        case users = 15
    }
    
    private let account: AccountModelProtocol
    private let accountID: String
    private let profilesService: ProfilesNetworkServiceProtocol
    private let profileInfoService: ProfileInfoNetworkServiceProtocol
    private let profileStateDeterminator: ProfileStateDeterminatorProtocol
    
    init(accountID: String,
         account: AccountModelProtocol,
         profilesService: ProfilesNetworkServiceProtocol,
         profileInfoService: ProfileInfoNetworkServiceProtocol,
         profileStateDeterminator: ProfileStateDeterminatorProtocol) {
        self.profilesService = profilesService
        self.profileInfoService = profileInfoService
        self.profileStateDeterminator = profileStateDeterminator
        self.accountID = accountID
        self.account = account
    }
}

extension UsersManager: UsersManagerProtocol {
    
    func getFirstProfiles(completion: @escaping (Result<[ProfileModelProtocol], Error>) -> Void) {
        guard let sex = requestsSex() else { return }
        profilesService.getFirstProfilesIDs(sex: sex.rawValue, count: Limits.users.rawValue) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let ids):
                let group = DispatchGroup()
                let profilesIDs = self.filter(ids: ids)
                var profiles = [ProfileModelProtocol]()
                profilesIDs.forEach {
                    group.enter()
                    self.profileInfoService.getProfileInfo(userID: $0) { result in
                        defer { group.leave() }
                        switch result {
                        case .success(let profile):
                            let profileModel = ProfileModel(profile: profile)
                            profiles.append(profileModel)
                        case .failure:
                            break
                        }
                    }
                }
                group.notify(queue: .main) {
                    completion(.success(profiles))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getNextProfiles(completion: @escaping (Result<[ProfileModelProtocol], Error>) -> Void) {
        guard let sex = requestsSex() else { return }
        profilesService.getNextProfilesIDs(sex: sex.rawValue, count: Limits.users.rawValue) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let ids):
                let group = DispatchGroup()
                let profilesIDs = self.filter(ids: ids)
                var profiles = [ProfileModelProtocol]()
                profilesIDs.forEach {
                    group.enter()
                    self.profileInfoService.getProfileInfo(userID: $0) { result in
                        defer { group.leave() }
                        switch result {
                        case .success(let profile):
                            let profileModel = ProfileModel(profile: profile)
                            profiles.append(profileModel)
                        case .failure:
                            break
                        }
                    }
                    group.notify(queue: .main) {
                        completion(.success(profiles))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension UsersManager {
    
    enum Sex: String {
        case male = "Мужчина"
        case female = "Женщина"
    }
    
    func filter(ids: [String]) -> [String] {
        let determinator = profileStateDeterminator
        return ids.filter { !(determinator.isProfileBlocked(userID: $0) || determinator.isProfileFriend(userID: $0) || determinator.isProfileRequested(userID: $0) || determinator.isProfileCurrent(userID: $0))  }
    }
    
    func requestsSex() -> Sex? {
        guard let sex = Sex(rawValue: account.profile.sex) else { return nil }
        switch sex {
        case .male:
            return .female
        case .female:
            return .male
        }
    }
}
