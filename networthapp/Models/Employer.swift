//
//  Employer.swift
//  networthapp
//
//  Created by Gavin You on 2023-12-09.
//

import Foundation

struct Employer: Codable, Hashable, Identifiable {
    let id: Int
    let company_name: String
    let company_recruit_email: String
    let field: String
    let location: String
}
