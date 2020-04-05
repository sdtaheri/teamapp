//
//  PlayersListView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/21/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct PlayersListView: View {

	@Environment(\.horizontalSizeClass) private var horizontalSizeClass
	@EnvironmentObject private var core: TeamAppCore

	@ObservedObject var viewModel: PlayersListViewModel

	@State private var shouldShowCreatePlayerSheet = false
	@State private var selectedPlayers = Set<Player>()
	@State private var desiredTeamCount = 2

	@State private var playerToEdit: Player?

	var body: some View {

		let selectedPlayersBinding = Binding<Set<Player>>(get: {
			self.selectedPlayers
		}) {
			self.selectedPlayers = $0
			self.desiredTeamCount = min(max(2, $0.count), self.desiredTeamCount)
			self.viewModel.makeTeams(count: self.desiredTeamCount, with: $0)
		}

		return Group {
			if viewModel.allPlayers.isEmpty {
				Button(action: {
					self.shouldShowCreatePlayerSheet = true
				}) {
					BigImageInfoView(systemImageName: "plus.circle",
									 localizedStringKey: "try_adding_player")
				}
			} else {
				ZStack(alignment: .bottomTrailing) {
					List {
						Section(header: horizontalSizeClass == .compact ? Text("tap_to_select_players") : nil,
								footer: Text("player_count \(viewModel.allPlayers.count)").font(Font.footnote)) {
									ForEach(viewModel.allPlayers, id: \.id) { player in
										PlayerListItemViewSelectable(player: player, selectedItems: selectedPlayersBinding)
											.contextMenu {
												Button(action: {
													selectedPlayersBinding.wrappedValue.remove(player)
													self.playerToEdit = player
													self.shouldShowCreatePlayerSheet = true
												}) {
													Text("edit")
													Image(systemName: "pencil")
														.imageScale(.large)
												}

												Button(action: {
													if let index = self.viewModel.allPlayers.firstIndex(of: player) {
														selectedPlayersBinding.wrappedValue.remove(player)
														DispatchQueue.main.async {
															self.viewModel.removePlayer(at: index)
														}
													}
												}) {
													Text("delete")
													Image(systemName: "trash")
														.imageScale(.large)
												}
										}
										.listRowBackground(selectedPlayersBinding.wrappedValue.contains(player) ? Color(UIColor.tertiarySystemFill) : nil)
									}.onDelete { indices in
										for index in indices {
											let player = self.viewModel.allPlayers[index]
											selectedPlayersBinding.wrappedValue.remove(player)
										}
										DispatchQueue.main.async {
											self.viewModel.removePlayers(at: indices)
										}
									}
						}
					}
					.listStyle(self.adaptiveListStyle())

					NavigationLink(destination:
						CalculatedTeamsView(core: self.core,
											desiredTeamCount: self.$desiredTeamCount,
											players: selectedPlayersBinding)
					) {
						HStack {
							Text("lets_teamup")
								.fontWeight(.medium)
							Image(systemName: "\(selectedPlayersBinding.wrappedValue.count).circle.fill")
						}
						.font(.system(.headline, design: .rounded))
					}
					.modifier(ActionButtonModifier())
					.opacity(selectedPlayersBinding.wrappedValue.isEmpty ? 0 : 1)
					.blur(radius: selectedPlayersBinding.wrappedValue.isEmpty ? 10 : 0)
					.padding(.vertical)
				}
			}
		}
		.navigationBarTitle(Text("app_name"),
							displayMode: viewModel.allPlayers.isEmpty ? .inline : .large)
			.navigationBarItems(leading:
				Button(action: {
					selectedPlayersBinding.wrappedValue.removeAll()
				}) {
					Image(systemName: "arrow.clockwise")
				}
				.modifier(BetterTappableIcon())
				.opacity(selectedPlayersBinding.wrappedValue.isEmpty ? 0 : 1)

				, trailing:
				HStack(alignment: .center) {
					#if DEBUG
					Button(action: {
						selectedPlayersBinding.wrappedValue.removeAll()
						DispatchQueue.main.async {
							self.viewModel.removeAllPlayers()
						}
					}) {
						Image(systemName: "text.badge.xmark")
					}
					.modifier(BetterTappableIcon())

					Button(action: {
						self.viewModel.createDummyPlayers(count: 5)
					}) {
						Image(systemName: "text.badge.plus")
					}
					.modifier(BetterTappableIcon())

					#endif
					
					Button(
						action: {
							self.playerToEdit = nil
							self.shouldShowCreatePlayerSheet = true
					}) {
						Image(systemName: "plus.circle.fill")
					}
					.modifier(BetterTappableIcon())
				}
		)
			.animation(Animation.default)
			.sheet(isPresented: self.$shouldShowCreatePlayerSheet) {
				CreatePlayerView(player: self.playerToEdit)
					.environment(\.writableDatabase, self.viewModel.database)
		}
	}

	private func adaptiveListStyle() -> some ListStyle {
		#if targetEnvironment(macCatalyst)
		return DefaultListStyle()
		#else
		return GroupedListStyle()
		#endif
	}
}

#if DEBUG
struct PlayersListView_Previews: PreviewProvider {
	static var previews: some View {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

		return PlayersListView(viewModel: PlayersListViewModel(database: context, core: TeamAppCore()))
	}
}
#endif
