//
//  LRUCache.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 10/4/24.
//

import Foundation

final class ListNode {
    var key: String
    var prev: ListNode?
    var next: ListNode?
    
    init(key: String) {
        self.key = key
    }
}

// LRU Disk Cache Class with Non-Blocking I/O
final class DiskCache {
    private var capacity: Int
    private var cache: [String: ListNode]
    private var head: ListNode?
    private var tail: ListNode?
    private var totalCacheSize: Int
    
    private let cacheDirectory: URL = {
        let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("DiskCache")
        if !FileManager.default.fileExists(atPath: directory.path) {
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        }
        return directory
    }()
    private let fileQueue = DispatchQueue(label: "diskCache.fileQueue")
    
    init(_ capacity: Int) {
        self.capacity = capacity
        self.cache = [String: ListNode](minimumCapacity: 1000)
        self.totalCacheSize = 0
        
        // Create dummy head and tail for the doubly linked list
        head = ListNode(key: "")
        tail = ListNode(key: "")
        head?.next = tail
        tail?.prev = head
    }

    func get(_ key: String) async -> Data? {
        let newKey = key.suffix(from: key.index(key.startIndex, offsetBy: 7))
        let fileName = newKey.replacingOccurrences(of: "/", with: "-")
        
        if let node = cache[fileName] {
            let fileURL = cacheDirectory.appending(path: fileName, directoryHint: .notDirectory)
            
            moveToHead(node)
            return await readFile(at: fileURL)
        }
        return nil
    }

    func put(_ key: String, data: Data) async {
        let newKey = key.suffix(from: key.index(key.startIndex, offsetBy: 7))
        let fileName = "\(newKey.replacingOccurrences(of: "/", with: "-"))"
        let fileURL = cacheDirectory.appending(path: fileName, directoryHint: .notDirectory)
        
        await writeFile(fileName, data, to: fileURL)

        if totalCacheSize > capacity {
            await removeLeastRecentlyUsedFile()
        }
    }
    
    func saveState() {
        var cacheArray: [String] = []
        var currentNode = tail?.prev

        while currentNode !== head {
            cacheArray.append(currentNode!.key)
            currentNode = currentNode?.prev
        }
//        print(cacheArray.map { $0 })
        
        UserDefaults.standard.setValue(cacheArray, forKey: "CacheState")
    }
    
    // 디스크에서 상태를 로드
    func loadState() {
        
        guard let loadedCacheState = UserDefaults.standard.array(forKey: "CacheState") as? [String] else {
            print("CacheState가 없음")
            return
        }
        
//        print(loadedCacheState.map { $0 })
        
        loadedCacheState.forEach { insert($0) }
        totalCacheSize = countCurrentDiskSize()
    }
}

//MARK: - File I/O
extension DiskCache {
    
    private func fileSize(atPath path: String) -> Int {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: path)
            let size = fileAttributes[.size] as? Int ?? 0
            return size
        } catch {
            print("Failed to get file size: \(error)")
            return 0
        }
    }
    
    private func writeFile(_ key: String, _ data: Data, to fileURL: URL) async {
        await withCheckedContinuation { continuation in
            fileQueue.async { [weak self] in
                do {
                    try data.write(to: fileURL, options: .atomic)
                    self?.insert(key, dataSize: data.count)
                    continuation.resume()
                } catch {
                    print("Failed to write file: \(error)")
                    continuation.resume()
                }
            }
        }
    }
    
    private func readFile(at path: URL) async -> Data? {
        await withCheckedContinuation { continuation in
            do {
                let data = try Data(contentsOf: path)
                continuation.resume(returning: data)
            } catch {
                print("Failed to read file: \(error)")
                continuation.resume(returning: nil)
            }
        }
    }
    
    private func deleteFile(_ key: String, at path: String) async {
        await withCheckedContinuation { continuation in
            fileQueue.async { [weak self] in
                guard let self else { return }
                
                do {
                    let size = fileSize(atPath: path)
                    try FileManager.default.removeItem(atPath: path)
                    cache.removeValue(forKey: key)
                    totalCacheSize -= size
//                    print(key, " 삭제")
                    continuation.resume()
                } catch {
                    print("Failed to delete file: \(error)")
                    continuation.resume()
                }
            }
        }
    }
    
    private func removeLeastRecentlyUsedFile() async {
//        print("LRU 시작...")
//        print("")

        if let tailNode = removeTail() {
            let filePath = cacheDirectory.appending(component: tailNode.key, directoryHint: .notDirectory).path
            
            await deleteFile(tailNode.key, at: filePath)
        }
    }
    
    private func countCurrentDiskSize() -> Int {
        let cacheDirectoryPath = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask)
        guard let path = cacheDirectoryPath.first else {
            return 0
        }
        
        let diskCachePath = path.appendingPathComponent("DiskCache")
        guard let contents = try? FileManager.default.contentsOfDirectory(atPath: diskCachePath.path) else {
            return 0
        }
        // TODO: - 현재는 CacheState.json 파일까지 같이 totalSize로 들어감
        var totalSize = 0
        for content in contents {
            let fullContentPath = diskCachePath.appendingPathComponent(content)
            let fileAttributes = try? FileManager.default.attributesOfItem(atPath: fullContentPath.path)
            totalSize += fileAttributes?[FileAttributeKey.size] as? Int ?? 0
        }
        return totalSize
    }
}

// MARK: - Linked List Methods
extension DiskCache {
    private func insert(_ key: String, dataSize: Int = 0) {
        let newNode = ListNode(key: key)
        cache[key] = newNode
        addToHead(newNode)
        
        totalCacheSize += dataSize
    }

    private func moveToHead(_ node: ListNode) {
        removeNode(node)
        addToHead(node)
    }

    private func addToHead(_ node: ListNode) {
        node.prev = head
        node.next = head?.next
        head?.next?.prev = node
        head?.next = node
    }
    
    private func removeNode(_ node: ListNode) {
        let prev = node.prev
        let next = node.next
        prev?.next = next
        next?.prev = prev
    }
    
    private func removeTail() -> ListNode? {
        guard let tailNode = tail?.prev, tailNode !== head else {
            return nil
        }
        removeNode(tailNode)
        return tailNode
    }
}
