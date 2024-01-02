//
//  OrderStorage.swift
//  FakeNFT
//
//  Created by Артём Костянко on 15.12.23.
//

import Foundation

protocol OrderStorage: AnyObject {
    func saveOrder(_ order: OrderDataModel)
    func getOrder(with id: String) -> OrderDataModel?
}

final class OrderStorageImpl: OrderStorage {

    private var storage: [String: OrderDataModel] = [:]

    private let syncQueue = DispatchQueue(label: "sync-order-queue")

    func saveOrder(_ order: OrderDataModel) {
        syncQueue.async { [weak self] in
            self?.storage[order.id] = order
        }
    }

    func getOrder(with id: String) -> OrderDataModel? {
        syncQueue.sync {
            storage[id]
        }
    }
}
