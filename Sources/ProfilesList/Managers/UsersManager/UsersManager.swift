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
    
    private let accountID: String
    private let profilesService: ProfilesNetworkServiceProtocol
    private let profileInfoService: ProfileInfoNetworkServiceProtocol
    
    init(accountID: String,
         profilesService: ProfilesNetworkServiceProtocol,
         profileInfoService: ProfileInfoNetworkServiceProtocol) {
        self.profilesService = profilesService
        self.profileInfoService = profileInfoService
        self.accountID = accountID
    }
}

extension UsersManager: UsersManagerProtocol {
    
    func getFirstProfiles(completion: @escaping (Result<[ProfileModelProtocol], Error>) -> Void) {
        profilesService.getFirstProfilesIDs(count: Limits.users.rawValue) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let ids):
                let group = DispatchGroup()
                var profilesIDs = ids
                if let firstIndex = profilesIDs.firstIndex(of: self.accountID) {
                    profilesIDs.remove(at: firstIndex)
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
                completion(.failure(error))
            }
        }
    }
    
    func getNextProfiles(completion: @escaping (Result<[ProfileModelProtocol], Error>) -> Void) {
        profilesService.getNextProfilesIDs(count: Limits.users.rawValue) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let ids):
                let group = DispatchGroup()
                var profilesIDs = ids
                if let firstIndex = profilesIDs.firstIndex(of: self.accountID) {
                    profilesIDs.remove(at: firstIndex)
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
                completion(.failure(error))
            }
        }
    }
}


