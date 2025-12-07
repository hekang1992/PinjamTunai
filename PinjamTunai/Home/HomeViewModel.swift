//
//  HomeViewModel.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/7.
//

class HomeViewModel {
    
    func homeMessageInfo() async throws -> BaseModel {
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.get("/ecutiveof/shown")
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
        
    }
    
}
