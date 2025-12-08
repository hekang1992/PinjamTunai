//
//  CenterViewModel.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/8.
//

class CenterViewModel {
    
    func centerInfo(json: [String: String]) async throws -> BaseModel {
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.get("/ecutiveof/sixty", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
        
    }
    
    
}
