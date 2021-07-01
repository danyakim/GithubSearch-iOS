//
//  GithubResult.swift
//  GithubSearch
//
//  Created by Daniil Kim on 30.06.2021.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - SearchResult
struct SearchResult: Codable {
  let totalCount: Int?
  let incompleteResults: Bool
  let items: [ResultItem]?
  
  enum CodingKeys: String, CodingKey {
    case totalCount = "total_count"
    case incompleteResults = "incomplete_results"
    case items = "items"
  }
}

// MARK: - ResultItem
struct ResultItem: Codable {
  let id: Int
  let nodeID: String
  let name: String
  let fullName: String
  let itemPrivate: Bool
  let owner: Owner
  let htmlURL: String
  let itemDescription: String?
  let fork: Bool
  let url: String
  let forksURL: String
  let keysURL: String
  let collaboratorsURL: String
  let teamsURL: String
  let hooksURL: String
  let issueEventsURL: String
  let eventsURL: String
  let assigneesURL: String
  let branchesURL: String
  let tagsURL: String
  let blobsURL: String
  let gitTagsURL: String
  let gitRefsURL: String
  let treesURL: String
  let statusesURL: String
  let languagesURL: String
  let stargazersURL: String
  let contributorsURL: String
  let subscribersURL: String
  let subscriptionURL: String
  let commitsURL: String
  let gitCommitsURL: String
  let commentsURL: String
  let issueCommentURL: String
  let contentsURL: String
  let compareURL: String
  let mergesURL: String
  let archiveURL: String
  let downloadsURL: String
  let issuesURL: String
  let pullsURL: String
  let milestonesURL: String
  let notificationsURL: String
  let labelsURL: String
  let releasesURL: String
  let deploymentsURL: String
  let createdAt: String
  let updatedAt: String
  let pushedAt: String
  let gitURL: String
  let sshURL: String
  let cloneURL: String
  let svnURL: String
  let homepage: String?
  let size: Int
  let stargazersCount: Int
  let watchersCount: Int
  let language: String?
  let hasIssues: Bool
  let hasProjects: Bool
  let hasDownloads: Bool
  let hasWiki: Bool
  let hasPages: Bool
  let forksCount: Int
  let mirrorURL: JSONNull?
  let archived: Bool
  let disabled: Bool
  let openIssuesCount: Int
  let license: License?
  let forks: Int
  let openIssues: Int
  let watchers: Int
  let score: Int
  
  enum CodingKeys: String, CodingKey {
    case id = "id"
    case nodeID = "node_id"
    case name = "name"
    case fullName = "full_name"
    case itemPrivate = "private"
    case owner = "owner"
    case htmlURL = "html_url"
    case itemDescription = "description"
    case fork = "fork"
    case url = "url"
    case forksURL = "forks_url"
    case keysURL = "keys_url"
    case collaboratorsURL = "collaborators_url"
    case teamsURL = "teams_url"
    case hooksURL = "hooks_url"
    case issueEventsURL = "issue_events_url"
    case eventsURL = "events_url"
    case assigneesURL = "assignees_url"
    case branchesURL = "branches_url"
    case tagsURL = "tags_url"
    case blobsURL = "blobs_url"
    case gitTagsURL = "git_tags_url"
    case gitRefsURL = "git_refs_url"
    case treesURL = "trees_url"
    case statusesURL = "statuses_url"
    case languagesURL = "languages_url"
    case stargazersURL = "stargazers_url"
    case contributorsURL = "contributors_url"
    case subscribersURL = "subscribers_url"
    case subscriptionURL = "subscription_url"
    case commitsURL = "commits_url"
    case gitCommitsURL = "git_commits_url"
    case commentsURL = "comments_url"
    case issueCommentURL = "issue_comment_url"
    case contentsURL = "contents_url"
    case compareURL = "compare_url"
    case mergesURL = "merges_url"
    case archiveURL = "archive_url"
    case downloadsURL = "downloads_url"
    case issuesURL = "issues_url"
    case pullsURL = "pulls_url"
    case milestonesURL = "milestones_url"
    case notificationsURL = "notifications_url"
    case labelsURL = "labels_url"
    case releasesURL = "releases_url"
    case deploymentsURL = "deployments_url"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case pushedAt = "pushed_at"
    case gitURL = "git_url"
    case sshURL = "ssh_url"
    case cloneURL = "clone_url"
    case svnURL = "svn_url"
    case homepage = "homepage"
    case size = "size"
    case stargazersCount = "stargazers_count"
    case watchersCount = "watchers_count"
    case language = "language"
    case hasIssues = "has_issues"
    case hasProjects = "has_projects"
    case hasDownloads = "has_downloads"
    case hasWiki = "has_wiki"
    case hasPages = "has_pages"
    case forksCount = "forks_count"
    case mirrorURL = "mirror_url"
    case archived = "archived"
    case disabled = "disabled"
    case openIssuesCount = "open_issues_count"
    case license = "license"
    case forks = "forks"
    case openIssues = "open_issues"
    case watchers = "watchers"
    case score = "score"
  }
}

// MARK: - License
struct License: Codable {
  let key: String
  let name: String
  let spdxID: String
  let url: String?
  let nodeID: String
  
  enum CodingKeys: String, CodingKey {
    case key = "key"
    case name = "name"
    case spdxID = "spdx_id"
    case url = "url"
    case nodeID = "node_id"
  }
}

// MARK: - Owner
struct Owner: Codable {
  let login: String
  let id: Int
  let nodeID: String
  let avatarURL: String
  let gravatarID: String
  let url: String
  let htmlURL: String
  let followersURL: String
  let followingURL: String
  let gistsURL: String
  let starredURL: String
  let subscriptionsURL: String
  let organizationsURL: String
  let reposURL: String
  let eventsURL: String
  let receivedEventsURL: String
  let type: TypeEnum
  let siteAdmin: Bool
  
  enum CodingKeys: String, CodingKey {
    case login = "login"
    case id = "id"
    case nodeID = "node_id"
    case avatarURL = "avatar_url"
    case gravatarID = "gravatar_id"
    case url = "url"
    case htmlURL = "html_url"
    case followersURL = "followers_url"
    case followingURL = "following_url"
    case gistsURL = "gists_url"
    case starredURL = "starred_url"
    case subscriptionsURL = "subscriptions_url"
    case organizationsURL = "organizations_url"
    case reposURL = "repos_url"
    case eventsURL = "events_url"
    case receivedEventsURL = "received_events_url"
    case type = "type"
    case siteAdmin = "site_admin"
  }
}

enum TypeEnum: String, Codable {
  case organization = "Organization"
  case user = "User"
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
  
  public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
    return true
  }
  
  public var hashValue: Int {
    return 0
  }
  
  public func hash(into hasher: inout Hasher) {
    // No-op
  }
  
  public init() {}
  
  public required init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if !container.decodeNil() {
      throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encodeNil()
  }
}
