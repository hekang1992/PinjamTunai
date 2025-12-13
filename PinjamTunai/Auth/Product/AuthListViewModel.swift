//
//  AuthListViewModel.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/8.
//

class AuthListViewModel {
    
    func productDetailInfo(json: [String: String]) async throws -> BaseModel {
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.upload("/ecutiveof/kissed", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
        
    }
    
    func reallyOrderInfo(json: [String: Any]) async throws -> BaseModel {
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.upload("/ecutiveof/stillness", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
        
    }
    
}
