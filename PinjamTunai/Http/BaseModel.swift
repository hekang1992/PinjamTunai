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
    var drop: String?
    var mill: String?
    var whistling: String?
    var pavement: pavementModel?
    var mid: [midModel]?
    var dropped: droppedModel?
    var userInfo: userInfoModel?
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
    var swan: String?
    var shrank: String?
    var whistling: String?
     
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

class pavementModel: Codable {
    var rare: String?
    var beauty: String?
    var silently: String?
    
    enum CodingKeys: String, CodingKey {
        case rare, beauty, silently
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        rare = try container.decodeIfPresent(String.self, forKey: .rare)
        silently = try container.decodeIfPresent(String.self, forKey: .silently)
        
        if let stringValue = try? container.decode(String.self, forKey: .beauty) {
            beauty = stringValue
        } else if let intValue = try? container.decode(Int.self, forKey: .beauty) {
            beauty = "\(intValue)"
        }
    }
}

class midModel: Codable {
    var shrank: String?
    var nestled: String?
    var wing: String?
    var quivering: String?
    var snowy: String?
    var stillness: Int?
    var blossoming: String?
}

class droppedModel: Codable {
    var blossoming: String?
    var shrank: String?
}

class userInfoModel: Codable {
    var singer: String?
    var lose: String?
}
