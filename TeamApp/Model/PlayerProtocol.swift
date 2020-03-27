//
//  PlayerProtocol.swift
//  TeamApp
//
//  Created by Saeed Taheri on 3/27/20.
//  Copyright © 2020 Saeed Taheri. All rights reserved.
//

import Foundation

protocol PlayerProtocol: Identifiable {
	var name: String? { get }
	var rating: Double { get }
	var id: UUID { get }
}
