//
//  ReceiptViewModel.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/9.
//

class ReceiptViewModel {
    
    func getBasicInfo(json: [String: String]) async throws -> BaseModel {
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.upload("/ecutiveof/singer", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
        
    }
    
    func saveBasicInfo(json: [String: String]) async throws -> BaseModel {
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.upload("/ecutiveof/handsome", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
        
    }
    
}
