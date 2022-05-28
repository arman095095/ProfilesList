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

enum UsersManagerError: LocalizedError {
    case another(Error)
    case notUsers
    
    var errorDescription: String? {
        switch self {
        case .another(let error):
            return error.localizedDescription
        case .notUsers:
            return "Пользователей не осталось"
        }
    }
}

protocol UsersManagerProtocol: AnyObject {
    func getFirstProfiles(completion: @escaping (Result<[ProfileModelProtocol], UsersManagerError>) -> Void)
    func getNextProfiles(completion: @escaping (Result<[ProfileModelProtocol], UsersManagerError>) -> Void)
}

final class UsersManager {
    
    enum Limits: Int {
        case users = 15
    }
    
    private let accountID: String
    private let profilesService: ProfilesNetworkServiceProtocol
    private let profileInfoService: ProfileInfoNetworkServiceProtocol
    private let profileStateDeterminator: ProfileStateDeterminatorProtocol
    
    init(accountID: String,
         profilesService: ProfilesNetworkServiceProtocol,
         profileInfoService: ProfileInfoNetworkServiceProtocol,
         profileStateDeterminator: ProfileStateDeterminatorProtocol) {
        self.profilesService = profilesService
        self.profileInfoService = profileInfoService
        self.profileStateDeterminator = profileStateDeterminator
        self.accountID = accountID
    }
}

extension UsersManager: UsersManagerProtocol {
    
    func getFirstProfiles(completion: @escaping (Result<[ProfileModelProtocol], UsersManagerError>) -> Void) {
        profilesService.getFirstProfilesIDs(count: Limits.users.rawValue) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let ids):
                let group = DispatchGroup()
                let profilesIDs = self.filter(ids: ids)
                guard !profilesIDs.isEmpty else {
                    completion(.failure(.notUsers))
                    return
                }
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
                completion(.failure(.another(error)))
            }
        }
    }
    
    func getNextProfiles(completion: @escaping (Result<[ProfileModelProtocol], UsersManagerError>) -> Void) {
        profilesService.getNextProfilesIDs(count: Limits.users.rawValue) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let ids):
                let group = DispatchGroup()
                let profilesIDs = self.filter(ids: ids)
                guard !profilesIDs.isEmpty else {
                    completion(.failure(.notUsers))
                    return
                }
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
                completion(.failure(.another(error)))
            }
        }
    }
}

private extension UsersManager {
    func filter(ids: [String]) -> [String] {
        let determinator = profileStateDeterminator
        return ids.filter { !(determinator.isProfileBlocked(userID: $0) || determinator.isProfileFriend(userID: $0) || determinator.isProfileRequested(userID: $0) || determinator.isProfileCurrent(userID: $0))  }
    }
}
