//
//  BaseModel.swift
//  PinjamTunai
//
//  Created by hekang on 2025/12/6.
//

class BaseModel: Codable {
    var token: Int?
    var stretched: String?
    var kindness: kindnessModel?
}

class kindnessModel: Codable {
    var kissed: Int?
    var toward: towardModel?
    var flew: [flewModel]?
}

class towardModel: Codable {
    var feel: String?
    var company: String?
    var drawing: String?
    var troth: String?
}

class flewModel: Codable {
    var heads: String?
    var above: [aboveModel]?
}

class aboveModel: Codable {
    var windows: Int?
    var bring: String?
    var wind: String?
    var rushing: String?
    var throng: String?
    var wondrous: String?
    var fixed: String?
    var among: String?
    var samite: String?
    var wreath: String?
}
