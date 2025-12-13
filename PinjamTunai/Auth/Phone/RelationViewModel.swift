//
//  RelationViewModel.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/9.
//

class RelationViewModel {
    
    func getRelationInfo(json: [String: String]) async throws -> BaseModel {
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.upload("/ecutiveof/drop", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
        
    }
    
    func saveRelationInfo(json: [String: String]) async throws -> BaseModel {
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.upload("/ecutiveof/lest", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
        
    }
    
    func sendMessageInfo(json: [String: String]) async throws -> BaseModel {
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.upload("/ecutiveof/affright", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
        
    }
    
    
}
