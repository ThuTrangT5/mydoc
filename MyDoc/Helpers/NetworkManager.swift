//
//  NetworkManager.swift
//  MyDoc
//
//  Created by ThuTrangT5 on 6/19/20.
//  Copyright © 2020 ThuTrangT5. All rights reserved.
//

import Foundation
import Network

class NetworkManager: NSObject {
    
    static let shared: NetworkManager = { return NetworkManager() }()
    var monitor: NWPathMonitor?
    
    private var isMonitoring = false
    private var latestNetworkStatus: NWPath.Status = .requiresConnection
    
    var networkStatusChangedHandler: ((_ isOnline: Bool)->Void)?
    
    
    override init() {
        super.init()
        
    }
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkManager_Monitor")
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { [weak self] (path) in
            self?.networkStatusChanged(path)
        }
        
        isMonitoring = true
    }
    
    func stopMonitoring() {
        guard isMonitoring, let monitor = monitor else { return }
        
        monitor.cancel()
        self.monitor = nil
        isMonitoring = false
    }
    
    func networkStatusChanged(_ path: NWPath) {
        print("Network status: \(path.status)")
        
        if self.latestNetworkStatus == path.status {
            //            print("NW status does not change")
            return
        }
        
        var isOnline = false
        if path.status == .satisfied {
            isOnline = true
        }
        self.latestNetworkStatus = path.status
        
        DispatchQueue.main.async { [weak self] () in
            self?.networkStatusChangedHandler?(isOnline)
        }
        
    }
    
    func isOnline() -> Bool {
        guard let monitor = monitor else { return false }
        return monitor.currentPath.status == .satisfied
    }
    
}
