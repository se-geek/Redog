//
//  CacheManager.swift
//  Redog
//
//  Created by Srinivas on 04/05/24.
//

import Foundation

class LRUCache {
    var cache: [URL: Data] = [:]
    private var order: [URL] = []
    private let capacity: Int = 20
    private let cacheKey = "LRUCache"
    private let orderKey = "LRUCacheOrder"
    
    static let shared = LRUCache()
    
    private init() {
        loadCacheFromPersistence()
    }
    
    func getImageData(for url: URL) -> Data? {
        if let imageData = cache[url] {
            return imageData
        }
        return nil
    }
    
    func setImageData(_ data: Data, for url: URL) {
        if cache.count == capacity, let lastURL = order.last {
            cache.removeValue(forKey: lastURL)
            order.removeLast()
        }
        cache[url] = data
        order.insert(url, at: 0)
        saveCacheToPersistence()
        print("orders---\(order)")
    }
    
    private func loadCacheFromPersistence() {
        if let cacheData = UserDefaults.standard.data(forKey: cacheKey),
           let decodedCache = try? JSONDecoder().decode([URL: Data].self, from: cacheData) {
            cache = decodedCache
            
            // Load order from UserDefaults
            if let orderData = UserDefaults.standard.data(forKey: cacheKey + "Order"),
               let decodedOrder = try? JSONDecoder().decode([URL].self, from: orderData) {
                order = decodedOrder
            }
        }
    }
    
    private func saveCacheToPersistence() {
        if let encodedCache = try? JSONEncoder().encode(cache) {
            UserDefaults.standard.set(encodedCache, forKey: cacheKey)
            
            // Save order to UserDefaults
            if let encodedOrder = try? JSONEncoder().encode(order) {
                UserDefaults.standard.set(encodedOrder, forKey: cacheKey + "Order")
            }
        }
    }
    
    
    func printCacheURLs()  {
        print("Cached URLs:")
        for url in cache.keys {
            print(url.absoluteString)
        }
    }
    
    func getCachedURLs() -> [URL] {
        return order
    }
    
    func clearCache() {
        
        cache.removeAll()
        order.removeAll()
        UserDefaults.standard.removeObject(forKey: cacheKey)
        UserDefaults.standard.removeObject(forKey: cacheKey + "Order")
    }
    
}
