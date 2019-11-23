import Foundation

extension Collection where Element: Numeric {
    var sum: Element { return reduce(0, +) }
}

extension Collection where Element: BinaryInteger {
    /// Returns the average of all elements in the array
    var average: Double {
        return isEmpty ? 0 : Double(sum) / Double(count)
    }
}

extension Player: Identifiable {
	public var id: UUID {
		return uuid ?? UUID()
	}
}

struct TeamAppCore {
    private let players: Set<Player>

    init(players: Set<Player>) {
        self.players = players
    }

	func makeTeams(count: Int, bestFirst: Bool = true, averageBased: Bool = false) -> [(index: Int, players: [Player])] {
        var result = Array(repeating: (index: 0, players: [Player]()), count: count)

        let playersCount = players.count

        // base case
        if playersCount < count {
            print("Can't make \(count) teams from \(playersCount) players.")
            return result
        }

        let sortedPlayers = players.sorted {
            if $0.rating == $1.rating {
                return Bool.random()
            } else {
				return bestFirst ? $0.rating > $1.rating : $0.rating < $1.rating
            }
        }

        for player in sortedPlayers {
			if averageBased {
				let averages = result.map { subset in
					subset.players.map { $0.rating }.average
				}

				let (indexOfMinAverage, _) = averages.enumerated().reduce((0, Double(Int.max))) {
					$0.1 < $1.1 ? $0 : $1
				}

				let counts = result.map { $0.players.count }

				let (indexOfLeastPopulatedTeam, _) = counts.enumerated().reduce((0, Int.max)) {
					$0.1 < $1.1 ? $0 : $1
				}

				if indexOfLeastPopulatedTeam != indexOfMinAverage {
					result[indexOfLeastPopulatedTeam].index = indexOfLeastPopulatedTeam
					result[indexOfLeastPopulatedTeam].players.append(player)
				} else {
					result[indexOfMinAverage].index = indexOfMinAverage
					result[indexOfMinAverage].players.append(player)
				}

			} else {
				let sums = result.map { subset in
					subset.players.map { $0.rating }.sum
				}

				let (indexOfMinSum, _) = sums.enumerated().reduce((0, Int16.max)) {
					$0.1 < $1.1 ? $0 : $1
				}

				result[indexOfMinSum].index = indexOfMinSum
				result[indexOfMinSum].players.append(player)
			}
        }

		var sortedResult = result
		for i in 0..<result.count {
			sortedResult[i].players = result[i].players.sorted {
				$0.rating > $1.rating
			}
		}

        return sortedResult
    }
}

