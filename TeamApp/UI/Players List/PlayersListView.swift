//
//  PlayersListView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/21/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct PlayersListView: View {
	@StateObject var viewModel: PlayersListViewModel

	@Environment(\.horizontalSizeClass) private var horizontalSizeClass
	@EnvironmentObject private var core: TeamAppCore
	@State private var shouldShowCreatePlayerSheet = false
	@State private var selectedPlayers = Set<Player>()
	@State private var playerToEdit: Player?

	var body: some View {
		Group {
			if viewModel.allPlayers.isEmpty {
				Button {
					shouldShowCreatePlayerSheet = true
				} label: {
					BigImageInfoView(
						systemImageName: "plus.circle",
						localizedStringKey: "try_adding_player"
					)
				}
			} else {
				List {
					Section(
						header: horizontalSizeClass == .compact ? Text("tap_to_select_players") : nil,
						footer: Text("player_count \(viewModel.allPlayers.count)").font(Font.footnote)
					) {
						ForEach(viewModel.allPlayers, id: \.id) { player in
							PlayerListItemViewSelectable(player: player, selectedItems: $selectedPlayers)
								.contextMenu {
									Button {
										selectedPlayers.remove(player)
										playerToEdit = player
										shouldShowCreatePlayerSheet = true
									} label: {
										Text("edit")
										Image(systemName: "pencil")
											.imageScale(.large)
									}

									Button {
										if let index = viewModel.allPlayers.firstIndex(of: player) {
											selectedPlayers.remove(player)
											DispatchQueue.main.async {
												viewModel.removePlayer(at: index)
											}
										}
									} label: {
										Text("delete")
										Image(systemName: "trash")
											.imageScale(.large)
									}
								}
								.listRowBackground(
									selectedPlayers.contains(player) ?
										Color(UIColor.secondarySystemFill) :
										Color(UIColor.systemBackground)
								)
						}.onDelete { indices in
							for index in indices {
								let player = viewModel.allPlayers[index]
								selectedPlayers.remove(player)
							}
							DispatchQueue.main.async {
								viewModel.removePlayers(at: indices)
							}
						}
					}
				}
				.listStyle(adaptiveListStyle())
				.overlay(
					NavigationLink(
						destination:
							CalculatedTeamsView(
								players: selectedPlayers
							)
					) {
						HStack {
							Text("lets_teamup")
								.fontWeight(.medium)
							Image(systemName: "\(selectedPlayers.count).circle.fill")
						}
						.font(.system(.headline, design: .rounded))
					}
					.modifier(ActionButtonModifier())
					.animation(.default)
					.opacity(selectedPlayers.isEmpty ? 0 : 1)
					.blur(radius: selectedPlayers.isEmpty ? 10 : 0)
					.padding(.vertical),
					alignment: .bottomTrailing
				)
			}
		}
		.navigationBarTitle(
			Text("app_name")
		)
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				Button {
					withAnimation {
						selectedPlayers.removeAll()
					}
				} label: {
					Image(systemName: "arrow.clockwise")
				}
				.opacity(
					selectedPlayers.isEmpty ? 0 : 1)
			}

			ToolbarItemGroup(placement: .navigationBarTrailing) {
				#if DEBUG
				Button {
					withAnimation {
						selectedPlayers.removeAll()
						DispatchQueue.main.async {
							viewModel.removeAllPlayers()
						}
					}
				} label: {
					Image(systemName: "text.badge.xmark")
				}

				Button {
					withAnimation {
						viewModel.createDummyPlayers(count: 5)
					}
				} label: {
					Image(systemName: "text.badge.plus")
				}
				#endif

				Button {
					playerToEdit = nil
					shouldShowCreatePlayerSheet = true
				} label: {
					Image(systemName: "plus.circle.fill")
				}
			}
		}
		.ignoresSafeArea(.keyboard)
		.sheet(isPresented: $shouldShowCreatePlayerSheet) {
			CreatePlayerView(player: playerToEdit)
				.environment(\.writableDatabase, viewModel.database)
		}
	}

	private func adaptiveListStyle() -> some ListStyle {
		#if targetEnvironment(macCatalyst)
		return DefaultListStyle()
		#else
		return InsetGroupedListStyle()
		#endif
	}
}

struct PlayersListView_Previews: PreviewProvider {
	static var previews: some View {
		// swiftlint:disable force_cast
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		// swiftlint:enable force_cast

		return PlayersListView(viewModel: PlayersListViewModel(database: context))
	}
}
