//
//  Rule.swift
//  ShadowCoel
//
//  Created by 宋志京 on 2019/10/13.
//  Copyright © 2019 CoelWu. All rights reserved.
//

import Foundation
import RealmSwift

class JRule: NSObject{
    static func setGFW() {
        let completion = {
            (result:String?, error:Error?) -> Void in
            if let result = result {
                if let data = Data(base64Encoded: result,options: .ignoreUnknownCharacters){
                    let str = String(data: data, encoding: String.Encoding.utf8)
                    var lines = str!.components(separatedBy: CharacterSet.newlines)
                    lines = lines.filter({ (s: String) -> Bool in
                        if s.isEmpty {
                            return false
                        }
                        let c = s[s.startIndex]
                        if c == "!" || c == "[" || c == "@" {
                            return false
                        }
                        return true
                    })
                    var ruleSet: ShadowCoelModel.ProxyRuleSet
                    let ruleSets = DBUtils.allNotDeleted(ProxyRuleSet.self, sorted: "createAt")
                    if ruleSets.count == 0 {
                        ruleSet = ProxyRuleSet()
                    }else {
                        ruleSet = ProxyRuleSet(value: ruleSets[0])
                    }
                    ruleSet.name = "J"
                    ruleSet.rules.removeAll()
                    var rules = [Rule]()
                    var count = 0
                    for line in lines {
                        var str = line
                        if str.count > 400 {
                            continue
                        }
                        if str.hasPrefix("||") {
                            let startIndex = str.index(str.startIndex, offsetBy: 2)
                            str = String(str[startIndex..<str.endIndex])
                        }else if str.hasPrefix("|") {
                            let startIndex = str.index(str.startIndex, offsetBy: 1)
                            str = String(str[startIndex..<str.endIndex])
                        }else if str.hasPrefix("https://") {
                            let startIndex = str.index(str.startIndex, offsetBy: 8)
                            str = String(str[startIndex..<str.endIndex])
                        }else if str.hasPrefix("http://") {
                            let startIndex = str.index(str.startIndex, offsetBy: 7)
                            str = String(str[startIndex..<str.endIndex])
                        }
                        print(str,count)
                        count += 1
                        let rule = Rule(type: .DomainSuffix, action: .Proxy, value: str)
                        rules.append(rule)
                    }
                    do {
                        ruleSet.rules = rules
                        let group = CurrentGroupManager.shared.group
                        let defaultRealm = try! Realm()
                        try DBUtils.add(ruleSet)
                        try defaultRealm.write {
                            group.ruleSets.removeAll()
                        }
                        try ConfigurationGroup.appendProxyRuleSet(forGroupId: group.uuid, rulesetId: ruleSet.uuid)
                    }catch {
                        print(error)
                    }
                }
            }
        }
        HTTP.shared.getRequest(urlStr: "https://raw.github.com/gfwlist/gfwlist/master/gfwlist.txt", completion: completion)
    }
    
    static func setAll() {
        var ruleSet: ShadowCoelModel.ProxyRuleSet
        let ruleSets = DBUtils.allNotDeleted(ProxyRuleSet.self, sorted: "createAt")
        if ruleSets.count == 0 {
            ruleSet = ProxyRuleSet()
        }else {
            ruleSet = ProxyRuleSet(value: ruleSets[0])
        }
        ruleSet.name = "J"
        let rule = Rule(type: .DomainSuffix, action: .Proxy, value: "*")
        ruleSet.rules.removeAll()
        ruleSet.addRule(rule)
        do {
            let group = CurrentGroupManager.shared.group
            let defaultRealm = try! Realm()
            try DBUtils.add(ruleSet)
            try defaultRealm.write {
                group.ruleSets.removeAll()
            }
            try ConfigurationGroup.appendProxyRuleSet(forGroupId: group.uuid, rulesetId: ruleSet.uuid)
        }catch {
            print(error)
        }
        
        
        
    }
}
