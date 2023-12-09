//
//  Account.swift
//  networthapp
//
//  Created by Gavin You on 2023-12-07.
//

import Foundation

struct Account: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
    let email: String
    let major: String
    let university: String
    let softskills: String
    let experience: String
}
