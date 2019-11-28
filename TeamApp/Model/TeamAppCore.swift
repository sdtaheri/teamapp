import Foundation
import Combine

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

typealias IndexedTeam = (index: Int, players: [Player])

final class TeamAppCore: ObservableObject {

	@Published var teams = [IndexedTeam]()

	func makeTeams(count: Int, from players: Set<Player>, bestFirst: Bool, averageBased: Bool) {
		DispatchQueue(label: "core_making_team").async {
			var result = Array(repeating: (index: 0, players: [Player]()), count: count)

			let playersCount = players.count

			if playersCount < count {
				print("Can't make \(count) teams from \(playersCount) players.")
				DispatchQueue.main.async {
					self.teams = []
				}
				return
			}

			let sortedPlayers = players.sorted {
				if $0.rating == $1.rating {
					return Bool.random()
				} else {
					return bestFirst ? $0.rating > $1.rating : $0.rating < $1.rating
				}
			}

			for player in sortedPlayers {
				let counts = result.map { $0.players.count }
				let (indexOfLeastPopulatedTeam, _) = counts.enumerated().reduce((0, Int.max)) {
					$0.1 < $1.1 ? $0 : $1
				}

				if averageBased {
					let averages = result.map { subset in
						subset.players.map { $0.rating }.average
					}

					let (indexOfMinAverage, _) = averages.enumerated().reduce((0, Double(Int.max))) {
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

					if indexOfLeastPopulatedTeam != indexOfMinSum {
						result[indexOfLeastPopulatedTeam].index = indexOfLeastPopulatedTeam
						result[indexOfLeastPopulatedTeam].players.append(player)
					} else {
						result[indexOfMinSum].index = indexOfMinSum
						result[indexOfMinSum].players.append(player)
					}
				}
			}

			if self.areTeamsTheSame(lhs: result, rhs: self.teams) {
				var shuffledArray = result.shuffled()
				if self.areTeamsTheSame(lhs: result, rhs: shuffledArray) {
					if let last = shuffledArray.popLast() {
						shuffledArray.insert(last, at: 0)
					}
				}
				for i in 0..<shuffledArray.count {
					shuffledArray[i].index = i
				}
				DispatchQueue.main.async {
					self.teams = shuffledArray
				}
			} else {
				DispatchQueue.main.async {
					self.teams = result
				}
			}
		}
	}

	private func areTeamsTheSame(lhs: [IndexedTeam], rhs: [IndexedTeam]) -> Bool {
		var teamsAreTheSame = false

		if lhs.count == rhs.count {
			let new = lhs.map { $0.players }.flatMap { $0 }.compactMap { $0.uuid }
			let old = rhs.map { $0.players }.flatMap { $0 }.compactMap { $0.uuid }
			teamsAreTheSame = (new == old)
		}

		return teamsAreTheSame
	}

	static func textualRepresentation(of teams: [IndexedTeam]) -> String {
		var result = ""

		for team in teams {
			result += String.localizedStringWithFormat(NSLocalizedString("team_index %lld", comment: ""), (team.index + 1))
			result += "; ("
			result += String.localizedStringWithFormat(NSLocalizedString("team_total %lld", comment: ""), Int(team.players.map { $0.rating }.sum))
			result += ", "
			result += String.localizedStringWithFormat(NSLocalizedString("team_average %@", comment: ""), NumberFormatter.singleDecimal.string(from: NSNumber(value: team.players.map { $0.rating }.average)) ?? "0")
			result += ")\n"

			for player in team.players {
				result += "\(player.name ?? ""): \(player.rating)\n"
			}

			result += "\n"
		}

		while result.last == "\n" {
			result.removeLast()
		}

		return result
	}
}
