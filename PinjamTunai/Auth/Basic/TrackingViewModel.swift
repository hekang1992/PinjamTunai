//
//  TrackingViewModel.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/10.
//

class TrackingViewModel {
    
    func saveTrackingMessageIngo(json: [String: String]) async throws -> BaseModel {
        
        let tomorrow = DeviceIdentifierManager.readIDFVFromKeychain() ?? ""
        let seek = DeviceIdentifierManager.getIDFA() ?? ""
        var bigJson = ["drub": "1",
                       "tomorrow": tomorrow,
                       "seek": seek]
        
        bigJson.merge(json) { _, new in new }
        
        bigJson = bigJson.filter { !$0.value.isEmpty }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.upload("/ecutiveof/weddings", parameters: bigJson)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
        
    }
    
    
}
