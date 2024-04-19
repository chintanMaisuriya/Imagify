//
//  Photo.swift
//  Imagify
//
//  Created by Chintan Maisuriya on 17/04/24.
//

import Foundation

// MARK: - Photo
struct Photo: Codable, Identifiable {
    let id, slug: String?
    let createdAt, updatedAt, promotedAt: String?
    let width, height: Int?
    let color, blurHash, description, altDescription: String?
    let urls: Urls?
    let likes: Int?
    let likedByUser: Bool?
    let assetType: String?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case id, slug
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case promotedAt = "promoted_at"
        case width, height, color
        case blurHash = "blur_hash"
        case description
        case altDescription = "alt_description"
        case urls, likes
        case likedByUser = "liked_by_user"
        case assetType = "asset_type"
        case user
    }
}

typealias Photos = [Photo]

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small, thumb, smallS3: String?

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}

// MARK: - User
struct User: Codable {
    let id, username, name, bio: String?
    let location: String?
    let profileImage: ProfileImage?

    enum CodingKeys: String, CodingKey {
        case id, username, name, bio, location
        case profileImage = "profile_image"
    }
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let small, medium, large: String?
}
