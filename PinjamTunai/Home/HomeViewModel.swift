//
//  HomeViewModel.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/7.
//

class HomeViewModel {
    
    func homeMessageInfo() async throws -> BaseModel {
        
        try await Task.sleep(nanoseconds: 200_000_000)
        
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
    
    func applyProductInfo(json: [String: String]) async throws -> BaseModel {
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.upload("/ecutiveof/kindness", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
        
    }
    
    func uplocationMessageInfo(json: [String: String]) async throws -> BaseModel {
//        LoadingView.show()
//        
//        defer {
//            LoadingView.hide()
//        }
//        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.upload("/ecutiveof/swan", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
        
    }
    
    func upMacMessageInfo(json: [String: String]) async throws -> BaseModel {
//        LoadingView.show()
//
//        defer {
//            LoadingView.hide()
//        }
//
        do {
            let model: BaseModel = try await HttpRequestManager.shared.upload("/ecutiveof/straight", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
        
    }
    
}
