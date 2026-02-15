//
//  Movie.swift
//  Netflix Clone Ukit
//
//  Created by Giorgi Mekvabishvili on 14.02.26.
//

import Foundation

struct TrendingTitleResponse: Codable {
    let results: [Title]
}

struct Title: Codable {
    let id: Int
    let mediaType: String?
    let originalTitle: String?
    let originalName: String?
    let title: String?
    let name: String?
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let voteCount: Int
    let releaseDate: String?
    let firstAirDate: String?
    let voteAverage: Double
    let genreIDS: [Int]
    let popularity: Double
    let originalLanguage: String
    let adult: Bool
    let video: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case originalTitle = "original_title"
        case originalName = "original_name"
        case title
        case name
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteCount = "vote_count"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case genreIDS = "genre_ids"
        case popularity
        case originalLanguage = "original_language"
        case adult
        case video
    }
}
