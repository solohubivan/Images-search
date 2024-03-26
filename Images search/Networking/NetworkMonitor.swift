//
//  NetworkMonitor.swift
//  Images search
//
//  Created by Ivan Solohub on 18.03.2024.
//

import Foundation
import Network

final class NetworkMonitor {
    
    private let networkMonitoringQueue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    public private(set) var isConnected: Bool = false

    init() {
        monitor = NWPathMonitor()
    }

    public func startMonitoring() {
        monitor.start(queue: networkMonitoringQueue)
        monitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status != .unsatisfied
            DispatchQueue.main.async {
                self?.isConnected = isConnected
                self?.networkStatusChanged?(isConnected)
            }
        }
    }

    public func stopMonitoring() {
        monitor.cancel()
    }

    var networkStatusChanged: ((Bool) -> Void)?
}
