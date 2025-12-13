//
//  MacMessageConfig.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/10.
//

import UIKit

class MacMessageConfig: NSObject {
    
    static let oneJson = LegsConfig.toJson()
    static let twoJson = ProudConfig.toJson()
    static let threeJson = AnchoriteConfig.toJson()
    static let fourJson = HelpConfig.toJson()
    static let fiveJson = DwellethConfig.toJson()
    static let sixJson = GainedConfig.toJson()
    
    static let bigJson: [String: Any] = {
        var dict: [String: Any] = [:]
        
        dict.merge(oneJson) { _, new in new }
        dict.merge(twoJson) { _, new in new }
        dict.merge(threeJson) { _, new in new }
        dict.merge(fourJson) { _, new in new }
        dict.merge(fiveJson) { _, new in new }
        dict.merge(sixJson) { _, new in new }
        
        return dict
    }()
    
}

class LegsConfig: NSObject {
    
    static func availableDiskSpace() -> UInt64 {
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
        do {
            let values = try tempURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
            return UInt64(values.volumeAvailableCapacityForImportantUsage ?? -1)
        } catch {
            return 0
        }
    }
    
    static var totalDiskSpace: UInt64 {
        guard let attributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
              let size = attributes[.systemSize] as? NSNumber else {
            return 0
        }
        return size.uint64Value
    }
    
    static var totalMemory: UInt64 {
        ProcessInfo.processInfo.physicalMemory
    }
    
    static func availableMemory() -> UInt64 {
        var stats = vm_statistics64()
        var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.size / MemoryLayout<integer_t>.size)
        
        let result = withUnsafeMutablePointer(to: &stats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
            }
        }
        
        guard result == KERN_SUCCESS else { return 0 }
        
        let pageSize = UInt64(vm_kernel_page_size)
        let free = UInt64(stats.free_count) * pageSize
        let inactive = UInt64(stats.inactive_count) * pageSize
        
        return free + inactive
    }
    
    static func toJson() -> [String: [String: String]] {
        return ["legs": ["pair": "\(availableDiskSpace())",
                         "goodly": "\(totalDiskSpace)",
                         "guide": "\(totalMemory)",
                         "dwelled": "\(availableMemory())"]]
    }
    
}
