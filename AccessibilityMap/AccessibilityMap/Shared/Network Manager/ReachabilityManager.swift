//
//  ReachabilityManager.swift
//  Reachability
//
//  Created by iOS Developer on 4/23/17.
//  Copyright © 2017 Ashley Mills. All rights reserved.
//

import ReachabilitySwift

public enum ConnectionStatus: CustomStringConvertible {
    case notReachable, reachableViaWiFi, reachableViaWWAN
    
    public var description: String {
        switch self {
        case .reachableViaWWAN: return "Cellular"
        case .reachableViaWiFi: return "WiFi"
        case .notReachable: return "No Connection"
        }
    }
}
public protocol NetworkStatusListener: class {
    func networkStatusDidChange(status: ConnectionStatus)
}

final class ReachabilityManager {
    
    fileprivate var hostName = "www.google.com"
    /// Reachability property
    open var reachability: Reachability?
    /// Network listener to check network status when it changes
//    weak var listener: NetworkStatusListener?
    var listeners = [NetworkStatusListener]()
    /// This property uses to validate network whether is reachable or not.
    open lazy var isReachable: Bool = {
        return ReachabilityManager.shared.reachability!.isReachable
    }()

    
    /// Private init
    private init() {
        reachability = Reachability(hostname: hostName)
        NotificationCenter.default.addObserver(self, selector:#selector(ReachabilityManager.reachabilityDidChanged(notification:)) , name: ReachabilityChangedNotification, object: reachability)
        do {
            try reachability?.startNotifier()
        } catch {
            print("-- Cannot start notifier --")
            return
        }
    }
    
    //MARK: Shared Instance
    static let shared: ReachabilityManager = ReachabilityManager()
    
    /// This method uses to notify when network is changed
    @objc func reachabilityDidChanged(notification: NSNotification) {
        let reachability = notification.object as! Reachability
        switch reachability.currentReachabilityStatus {
        case .reachableViaWiFi, .reachableViaWWAN:
            isReachable = true
            break
        case .notReachable:
            isReachable = false
            break
        }
        guard listeners.count > 0 else { return }
        for listener in listeners {
           notify(listener: listener, status: reachability.currentReachabilityStatus)
        }
    }
    
    fileprivate func notify(listener: NetworkStatusListener, status: Reachability.NetworkStatus) {
        switch status {
        case .notReachable:
            listener.networkStatusDidChange(status: .notReachable)
            break
        case .reachableViaWiFi:
            listener.networkStatusDidChange(status: .reachableViaWiFi)
            break
        case .reachableViaWWAN:
            listener.networkStatusDidChange(status: .reachableViaWWAN)
            break
        }

    }
    
    open func addListener(listener: NetworkStatusListener) {
        listeners.append(listener)
    }
    
    open func removeListener(listener: NetworkStatusListener) {
        listeners = listeners.filter { $0 !== listener }
    }
    
    fileprivate func stopNotifier() {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        reachability = nil
    }
    
    deinit {
        stopNotifier()
    }
}
