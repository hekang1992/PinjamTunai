//
//  OrderListViewModel.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/10.
//

class OrderListViewModel {
    
    func getOrderListInfo(json: [String: String]) async throws -> BaseModel {
        LoadingView.show()
        
        defer {
            LoadingView.hide()
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.upload("/ecutiveof/bore", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
        
    }
    
}
