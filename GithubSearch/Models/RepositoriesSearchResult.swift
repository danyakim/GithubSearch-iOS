//
//  GithubResult.swift
//  GithubSearch
//
//  Created by Daniil Kim on 30.06.2021.
//

import Foundation

// MARK: - SearchResult
struct SearchResult<T: Codable>: Codable {
  let totalCount: Int?
  let items: [T]?
  
  enum CodingKeys: String, CodingKey {
    case totalCount = "total_count"
    case items = "items"
  }
}

// MARK: - ResultItem
class Repository: Codable {
  let name: String
  let fullName: String
  let owner: User
  let itemDescription: String?
  let url: String
  let updatedAt: String
  let homepage: String?
  let stargazersCount: Int
  let watchersCount: Int
  let language: String?
  let forksCount: Int
  let openIssuesCount: Int
  let license: License?
  let forks: Int
  let openIssues: Int
  let watchers: Int
  
  enum CodingKeys: String, CodingKey {
    case name = "name"
    case fullName = "full_name"
    case owner = "owner"
    case itemDescription = "description"
    case url = "url"
    case updatedAt = "updated_at"
    case homepage = "homepage"
    case stargazersCount = "stargazers_count"
    case watchersCount = "watchers_count"
    case language = "language"
    case forksCount = "forks_count"
    case openIssuesCount = "open_issues_count"
    case license = "license"
    case forks = "forks"
    case openIssues = "open_issues"
    case watchers = "watchers"
  }
}

// MARK: - License
struct License: Codable {
  let name: String
}

// MARK: - Owner
class User: Codable {
  let login: String
  let avatarURL: String
  
  enum CodingKeys: String, CodingKey {
    case login = "login"
    case avatarURL = "avatar_url"
  }
}
