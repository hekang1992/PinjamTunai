//
//  FaceViewModel.swift
//  PinjamTunai
//
//  Created by Jonathan Miles on 2025/12/8.
//

import Foundation

class FaceViewModel {
    
    func faceMessageInfo(json: [String: String]) async throws -> BaseModel {
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.upload("/ecutiveof/toward", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
        
    }
    
    func uploadCardInfo(json: [String: String], data: Data) async throws -> BaseModel {
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.upload("/ecutiveof/feel", parameters: json, files: ["hisBringing": data])
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
        
    }
    
    func saveCardInfo(json: [String: String]) async throws -> BaseModel {
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.upload("/ecutiveof/company", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
        
    }
    
    
}
