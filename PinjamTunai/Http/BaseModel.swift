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
    var wind: String?
    var bring: String?
    var rushing: String?
    var mournful: [mournfulModel]?
    var readily: String?
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
    var lie: String?
    var upturned: String?
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

class breastModel: Codable {
    var strain: String?
    var lingering: String?
    var token: String?
}

class mournfulModel: Codable {
    var shrank: String?
    var fain: String?
}

class princeModel: Codable {
    var fairy: String?
    var bore: String?
    var beloved: String?
    var shrank: String?
    var account: String?
    var giving: String?
    var music: String?
    var backing: String?
    var breeze: [breezeModel]?
}

class swanModel: Codable {
    var feedbackUrl: String?
}

class affrightModel: Codable {
    var shrank: String?
    var guests: String?
}

class breezeModel: Codable {
    var bore: String?
    var heads: String?
    
    enum CodingKeys: String, CodingKey {
        case bore, heads
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        bore = try container.decodeIfPresent(String.self, forKey: .bore)
        if let stringValue = try? container.decode(String.self, forKey: .heads) {
            heads = stringValue
        } else if let intValue = try? container.decode(Int.self, forKey: .heads) {
            heads = "\(intValue)"
        }
    }
    
}

class pavementModel: Codable {
    var rare: String?
    var beauty: String?
    var silently: String?
    var lea: String?
    var stands: Int?
    var pallid: Int?
    var bring: String?
    
    enum CodingKeys: String, CodingKey {
        case rare, beauty, silently, stands, pallid, lea, bring
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lea = try container.decodeIfPresent(String.self, forKey: .lea)
        rare = try container.decodeIfPresent(String.self, forKey: .rare)
        silently = try container.decodeIfPresent(String.self, forKey: .silently)
        stands = try container.decodeIfPresent(Int.self, forKey: .stands)
        pallid = try container.decodeIfPresent(Int.self, forKey: .pallid)
        bring = try container.decodeIfPresent(String.self, forKey: .bring)
        if let stringValue = try? container.decode(String.self, forKey: .beauty) {
            beauty = stringValue
        } else if let intValue = try? container.decode(Int.self, forKey: .beauty) {
            beauty = "\(intValue)"
        }
    }
}

class groundModel: Codable {
    var shrank: String?
    var nestled: String?
    var token: String?
    var snow: String?
    var breeze: [breezeModel]?
    var heads: String?
    var winds: String?
    var blossoms: Int?
    
    enum CodingKeys: String, CodingKey {
        case shrank, nestled, token, snow, breeze, heads, winds, blossoms
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        shrank = try container.decodeIfPresent(String.self, forKey: .shrank)
        nestled = try container.decodeIfPresent(String.self, forKey: .nestled)
        token = try container.decodeIfPresent(String.self, forKey: .token)
        snow = try container.decodeIfPresent(String.self, forKey: .snow)
        breeze = try container.decodeIfPresent([breezeModel].self, forKey: .breeze)
        winds = try container.decodeIfPresent(String.self, forKey: .winds)
        blossoms = try container.decodeIfPresent(Int.self, forKey: .blossoms)
        if let stringValue = try? container.decode(String.self, forKey: .heads) {
            heads = stringValue
        } else if let intValue = try? container.decode(Int.self, forKey: .heads) {
            heads = String(intValue)
        }
    }
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
    var above: aboveModel?
    var breast: [breastModel]?
    var ground: [groundModel]?
    var prince: [princeModel]?
    var privacyPolicyUrl: String?
    var affright: affrightModel?
    var circle: String?
    var other_url: other_urlModel?
    var fixing: Int?
    var swan: swanModel?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fixing = try container.decodeIfPresent(Int.self, forKey: .fixing)
        circle = try container.decodeIfPresent(String.self, forKey: .circle)
        kissed = try container.decodeIfPresent(Int.self, forKey: .kissed)
        toward = try container.decodeIfPresent(towardModel.self, forKey: .toward)
        flew = try container.decodeIfPresent([flewModel].self, forKey: .flew)
        drop = try container.decodeIfPresent(String.self, forKey: .drop)
        mill = try container.decodeIfPresent(String.self, forKey: .mill)
        whistling = try container.decodeIfPresent(String.self, forKey: .whistling)
        pavement = try container.decodeIfPresent(pavementModel.self, forKey: .pavement)
        swan = try container.decodeIfPresent(swanModel.self, forKey: .swan)
        mid = try container.decodeIfPresent([midModel].self, forKey: .mid)
        userInfo = try container.decodeIfPresent(userInfoModel.self, forKey: .userInfo)
        above = try container.decodeIfPresent(aboveModel.self, forKey: .above)
        affright = try container.decodeIfPresent(affrightModel.self, forKey: .affright)
        other_url = try container.decodeIfPresent(other_urlModel.self, forKey: .other_url)
        breast = try container.decodeIfPresent([breastModel].self, forKey: .breast)
        ground = try container.decodeIfPresent([groundModel].self, forKey: .ground)
        prince = try container.decodeIfPresent([princeModel].self, forKey: .prince)
        privacyPolicyUrl = try container.decodeIfPresent(String.self, forKey: .privacyPolicyUrl)
        
        if let droppedValue = try? container.decode(droppedModel.self, forKey: .dropped) {
            dropped = droppedValue
        } else if let array = try? container.decode([String].self, forKey: .dropped), array.isEmpty {
            dropped = nil
        } else {
            dropped = nil
        }
    }
}

class other_urlModel: Codable {
    var service_url: String?
}
