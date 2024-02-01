//
//  VoteHistoryModel.swift
//  TastyClip
//
//  Created by Nursultan Yelemessov on 29/01/2024.
//

import Foundation


struct VoteHistoryModel: Codable  {
    var id: String
    var voteId: String
    var isLike: Bool
    
}

class VoteHistoryManager {
    
    static func saveVote(vote: VoteHistoryModel) {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        if let encodedUser = try? encoder.encode(vote){
            defaults.set(encodedUser, forKey: "vote")
        }
    }
    
    static func checkIfAlreadyVoted() -> VoteHistoryModel? {
        let defaults = UserDefaults.standard
        if let savedVote = defaults.object(forKey: "vote") as? Data{
            let decoder = JSONDecoder()
            if let savedVote = try? decoder.decode(VoteHistoryModel.self, from: savedVote){
                return savedVote
            }
        }
        return nil
    }
    
}

