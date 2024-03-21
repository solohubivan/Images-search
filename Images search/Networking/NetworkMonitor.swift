//
//  NetworkMonitor.swift
//  Images search
//
//  Created by Ivan Solohub on 18.03.2024.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    var networkStatusChanged: ((Bool) -> Void)?

    private let networkMonitoringQueue = DispatchQueue.global()
    private let monitor: NWPathMonitor

    public private(set) var isConnected: Bool = false

    private init() {
        monitor = NWPathMonitor()
    }

    public func startMonitoring() {
        monitor.start(queue: networkMonitoringQueue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
        }
    }

    public func stopMonitoring() {
        monitor.cancel()
    }
}
