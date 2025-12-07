//
//  BaseModel.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/6.
//

struct BaseModel: Codable {
    var token: Int?
    var stretched: String?
    var kindness: kindnessModel?
}

struct kindnessModel: Codable {
    var kissed: Int?
    var toward: towardModel?
}

struct towardModel: Codable {
    var feel: String?
    var company: String?
    var drawing: String?
    var troth: String?
}
