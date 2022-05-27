//
//  ProfilesService.swift
//  
//
//  Created by Арман Чархчян on 10.04.2022.
//

import FirebaseFirestore
import NetworkServices

enum URLComponents {
    enum Paths: String {
        case users
    }
    
    enum Parameters: String {
        case lastActivity
    }
}

public protocol ProfilesNetworkServiceProtocol {
    func getFirstProfilesIDs(count: Int, completion: @escaping (Result<[String],Error>) -> Void)
    func getNextProfilesIDs(count: Int, completion: @escaping (Result<[String],Error>) -> Void)
}

final class ProfilesNetworkService {
    private let networkServiceRef: Firestore
    private var lastProfile: DocumentSnapshot?
    
    private var usersRef: CollectionReference {
        return networkServiceRef.collection(URLComponents.Paths.users.rawValue)
    }
    
    init(networkService: Firestore) {
        self.networkServiceRef = networkService
    }
}

extension ProfilesNetworkService: ProfilesNetworkServiceProtocol {

    public func getFirstProfilesIDs(count: Int, completion: @escaping (Result<[String],Error>) -> Void) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            completion(.failure(ConnectionError.noInternet))
        }
        let query = usersRef.order(by: URLComponents.Parameters.lastActivity.rawValue, descending: true).limit(to: count)
        getFirstUsersIDs(query: query, completion: completion)
    }
    
    public func getNextProfilesIDs(count: Int, completion: @escaping (Result<[String],Error>) -> Void) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            completion(.failure(ConnectionError.noInternet))
        }
        let query = usersRef.order(by: URLComponents.Parameters.lastActivity.rawValue, descending: true).limit(to: count)
        getNextUsersIDs(count: count, query: query, completion: completion)
    }
}

private extension ProfilesNetworkService {

    func getFirstUsersIDs(query: Query, completion: @escaping (Result<[String],Error>) -> Void) {
        query.getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let querySnapshot = querySnapshot else { return }
            self.lastProfile = querySnapshot.documents.last
            completion(.success(querySnapshot.documents.map { $0.documentID }))
        }
    }
    
    func getNextUsersIDs(count: Int, query: Query, completion: @escaping (Result<[String],Error>) -> Void) {
        guard let lastDocument = lastProfile else { return }
        query.start(afterDocument: lastDocument).limit(to: count).getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let querySnapshot = querySnapshot else { return }
            self.lastProfile = querySnapshot.documents.last
            completion(.success(querySnapshot.documents.map { $0.documentID }))
        }
    }
}

