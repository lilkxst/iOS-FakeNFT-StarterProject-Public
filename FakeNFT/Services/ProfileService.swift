import Foundation

typealias ProfileCompletion = (Result<ProfileModelNetwork, Error>) -> Void

protocol ProfileServiceProtocol {
    func getProfile(completion: @escaping ProfileCompletion)
    func saveProfile(profileEditing: ProfileModelEditing, completion: ProfileCompletion?)
}

final class ProfileNetworkService: ProfileServiceProtocol {

    private let networkClient: NetworkClient
    private let profileStorage: ProfileStorageProtocol

    init(networkClient: NetworkClient, profileStorage: ProfileStorageProtocol) {
        self.networkClient = networkClient
        self.profileStorage = profileStorage
    }

    func getProfile(completion: @escaping ProfileCompletion) {
        if let profile = profileStorage.getProfile() {
            completion(.success(profile))
            return
        }
        let request = ProfileGetRequest()
        networkClient.send(request: request, type: ProfileModelNetwork.self) {
            [weak profileStorage] result in
            switch result {
            case .success(let profile):
                profileStorage?.saveProfile(profile)
                if let encodedData = try? JSONEncoder().encode(profile) {
                    UserDefaults.standard.set(encodedData, forKey: "profileJSON")
                }
                completion(.success(profile))
            case .failure(let error):
                if let encodedData = UserDefaults.standard.data(forKey: "profileJSON"),
                   let profile = try? JSONDecoder().decode(ProfileModelNetwork.self, from: encodedData) {
                    completion(.success(profile))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }

    func saveProfile(profileEditing: ProfileModelEditing, completion: ProfileCompletion?) {
        let request = ProfilePutRequest(profileModelEditing: profileEditing)
        networkClient.send(request: request, type: ProfileModelNetwork.self) {
            [weak profileStorage] result in
            switch result {
            case .success(let profile):
                profileStorage?.saveProfile(profile)
                completion?(.success(profile))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

}
