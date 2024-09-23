//
//  DexCellModel.swift
//  Pokedex-MVI
//
//  Created by Jeong Deokho on 9/12/24.
//

import SwiftUI

struct DexCellModel: Hashable {
    let id: Int
    let name: String
    let imageURL: String
    let typeName: String
    let backgroundColor: Color
    
    init(data: Pokemon) {
        self.id = data.id
        self.name = data.name
        self.imageURL = data.imageURL
        self.typeName = data.type
        let backgroundColor: Color = switch data.type {
        case "fire": .red
        case "bug": .green
        case "poison": .init(uiColor: .darkGray)
        case "water": .blue
        case "electric": .yellow
        case "psychic": .purple
        case "normal": .orange
        case "ground": .gray
        case "flying": .teal
        case "fairy": .pink
        case "grass": .mint
        case "fighting": .brown
        case "steel": .init(uiColor: .lightGray)
        case "ice": .cyan
        case "rock": .brown
        case "dragon": .indigo
        default: .black
        }
        self.backgroundColor = backgroundColor
    }
}
