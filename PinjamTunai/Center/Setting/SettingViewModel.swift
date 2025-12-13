//
//  SettingViewModel.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/8.
//

class SettingViewModel {
    
    func logoutInfo() async throws -> BaseModel {
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.get("/ecutiveof/stretched")
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
        
    }
    
    func deleaccInfo() async throws -> BaseModel {
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.upload("/ecutiveof/muttered", parameters: nil)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
        
    }
}
