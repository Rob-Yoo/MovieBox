//
//  DiskCache2.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 10/14/24.
//

import Foundation

struct CacheState: Codable {
    let key: String
    let accessCount: Int
    let timeStamp: Date
}

final class ListNode {
    let key: String
    var accessCount: Int
    var timeStamp: Date
    var prev: ListNode?
    var next: ListNode?

    init(key: String, accessCount: Int = 0, timeStamp: Date = Date()) {
        self.key = key
        self.accessCount = accessCount
        self.timeStamp = timeStamp
    }
}

final class DiskCache {
    private var capacity: Int
    private var cache: [String: ListNode]
    private var head: ListNode
    private var tail: ListNode
    private var totalCacheSize: Int
    private var totalAccessCount: Int

    private let expirationInterval: TimeInterval = 24 * 60 * 60
    private let fileQueue = DispatchQueue(label: "diskCache.fileQueue")

    private let cacheDirectory: URL = {
        let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("DiskCache")
        if !FileManager.default.fileExists(atPath: directory.path) {
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        }
        return directory
    }()
    
    init(_ capacity: Int) {
        self.capacity = capacity
        self.cache = [String: ListNode](minimumCapacity: 100)
        self.totalCacheSize = 0
        self.totalAccessCount = 0
        
        head = ListNode(key: "")
        tail = ListNode(key: "")
        head.next = tail
        tail.prev = head
    }

    func put(_ imagePath: String, data: Data) {
        fileQueue.async { [weak self] in
            
            guard let self else { return }
            
            let fileName = imagePath.replacingOccurrences(of: "/", with: "")
            let fileURL = cacheDirectory.appending(path: fileName, directoryHint: .notDirectory)
            
            writeFile(fileName, data, to: fileURL)
            
            while totalCacheSize > capacity {
                removeLeastUsedAndFrequentlyUsedFile()
            }
            
            saveState()
        }
    }

    func get(_ imagePath: String) async -> Data? {
        return await withCheckedContinuation { [weak self] continuation in
            guard let self else { return }
            
            fileQueue.async {
                
                let fileName = imagePath.replacingOccurrences(of: "/", with: "")
                
                if let node = self.cache[fileName] {
                    let fileURL = self.cacheDirectory.appending(path: fileName, directoryHint: .notDirectory)
                    
                    if Date().timeIntervalSince(node.timeStamp) > self.expirationInterval {
                        self.deleteFile(node.key, at: fileURL.path)
                        continuation.resume(returning: nil)
                    }
                    
                    node.accessCount += 1
                    self.totalAccessCount += 1
                    node.timeStamp = Date()
                    self.moveToHead(node)
                    continuation.resume(returning: try? Data(contentsOf: fileURL))
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    private func removeLeastUsedAndFrequentlyUsedFile() {
        let averageAccessCount = Double(totalAccessCount) / Double(cache.count)
        var currentNode = tail.prev

        while currentNode !== head {
            if let node = currentNode {
                if node.accessCount <= Int(averageAccessCount) || Date().timeIntervalSince(node.timeStamp) > expirationInterval {
                    UserDefaults.standard.removeObject(forKey: node.key)
                    removeNode(node)
                    deleteFile(node.key, at: cacheDirectory.appending(component: node.key, directoryHint: .notDirectory).path)
                    return
                }
            }

            currentNode = currentNode?.prev
        }

    }

    func saveState() {
        var cacheArray: [CacheState] = []
        var currentNode = head.next

        while currentNode !== tail {
            if let node = currentNode {
                let cacheState = CacheState(key: node.key, accessCount: node.accessCount, timeStamp: node.timeStamp)
                cacheArray.append(cacheState)
            }
            currentNode = currentNode?.next
        }

        if let jsonData = try? JSONEncoder().encode(cacheArray) {
            UserDefaults.standard.set(jsonData, forKey: "CacheState")
        }
        UserDefaults.standard.set(totalAccessCount, forKey: "TotalAccessCount")
    }

    func loadState() {
        guard let jsonData = UserDefaults.standard.data(forKey: "CacheState"),
              let cacheArray = try? JSONDecoder().decode([CacheState].self, from: jsonData) else {
            print("CacheState가 없음")
            return
        }

        totalAccessCount = UserDefaults.standard.integer(forKey: "TotalAccessCount")
        let now = Date()

        for cacheState in cacheArray {
            if (now.timeIntervalSince(cacheState.timeStamp) > expirationInterval) {
                deleteFile(cacheState.key, at: cacheDirectory.appendingPathComponent(cacheState.key).path)
            } else {
                let node = ListNode(key: cacheState.key, accessCount: cacheState.accessCount, timeStamp: cacheState.timeStamp)
                cache[cacheState.key] = node
                addToHead(node)
            }
        }

        totalCacheSize = countCurrentDiskSize()
    }
}

// MARK: - 파일 I/O 처리
extension DiskCache {
    private func writeFile(_ key: String, _ data: Data, to fileURL: URL) {
        do {
            try data.write(to: fileURL, options: .atomic)
            insert(key, dataSize: data.count)
        } catch {
            print("Failed to write file: \(error)")
        }
    }

    private func deleteFile(_ key: String, at path: String) {
        do {
            let size = fileSize(atPath: path)
            self.totalCacheSize -= size
            self.cache.removeValue(forKey: key)
            self.totalAccessCount -= self.cache[key]?.accessCount ?? 0
            try FileManager.default.removeItem(atPath: path)
        } catch {
            print("Failed to delete file: \(error)")
            if let node = cache[key] {
                removeNode(node)
            }
        }
    }

    private func fileSize(atPath path: String) -> Int {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: path)
            return fileAttributes[.size] as? Int ?? 0
        } catch {
            return 0
        }
    }
}

// MARK: - 연결 리스트 관련 메서드
extension DiskCache {
    private func insert(_ key: String, dataSize: Int = 0) {
        let newNode = ListNode(key: key, accessCount: 1, timeStamp: .now)
        cache[key] = newNode
        addToHead(newNode)
        totalCacheSize += dataSize
        totalAccessCount += 1
    }

    private func moveToHead(_ node: ListNode) {
        removeNode(node)
        addToHead(node)
    }

    private func addToHead(_ node: ListNode) {
        node.prev = head
        node.next = head.next
        head.next?.prev = node
        head.next = node
    }
    
    private func removeNode(_ node: ListNode) {
        let prev = node.prev
        let next = node.next
        prev?.next = next
        next?.prev = prev
    }

    private func countCurrentDiskSize() -> Int {
        let cacheDirectoryPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        guard let path = cacheDirectoryPath else { return 0 }

        let diskCachePath = path.appendingPathComponent("DiskCache")
        guard let contents = try? FileManager.default.contentsOfDirectory(atPath: diskCachePath.path) else { return 0 }

        var totalSize = 0
        for content in contents {
            let fullContentPath = diskCachePath.appendingPathComponent(content)
            if let fileAttributes = try? FileManager.default.attributesOfItem(atPath: fullContentPath.path) {
                totalSize += fileAttributes[FileAttributeKey.size] as? Int ?? 0
            }
        }
        return totalSize
    }
    
    private func removeTail() -> ListNode? {
        guard let tailNode = tail.prev, tailNode !== head else {
            return nil
        }
        removeNode(tailNode)
        return tailNode
    }
}
