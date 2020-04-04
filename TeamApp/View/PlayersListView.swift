//
//  PlayersListView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/21/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct PlayersListView: View {

	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(key: "name", ascending: true, selector:#selector(NSString.localizedStandardCompare))],
		animation: .default)
	private var players: FetchedResults<PlayerManagedObject>

	@Environment(\.managedObjectContext) private var viewContext
	@Environment(\.horizontalSizeClass) private var horizontalSizeClass
	@EnvironmentObject var core: TeamAppCore

	@State private var shouldShowCreatePlayerSheet = false
	@State private var selectedPlayers = Set<PlayerManagedObject>()
	@State private var desiredTeamCount = 2

	@State private var playerToEdit: PlayerManagedObject?

	var body: some View {

		let selectedPlayersBinding = Binding<Set<PlayerManagedObject>>(get: {
			self.selectedPlayers
		}) {
			self.selectedPlayers = $0
			self.desiredTeamCount = min(max(2, $0.count), self.desiredTeamCount)
			self.core.makeTeams(count: self.desiredTeamCount,
								from: $0,
								bestFirst: Bool.random(),
								averageBased: Bool.random())
		}

		return Group {
			if players.isEmpty {
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
								footer: Text("player_count \(players.count)").font(Font.footnote)) {
									ForEach(players, id: \.id) { player in
										PlayerListItemViewSelectable(player: player, selectedItems: selectedPlayersBinding)
											.contextMenu {
												Button(action: {
													self.playerToEdit = player
													self.shouldShowCreatePlayerSheet = true
												}) {
													Text("edit")
													Image(systemName: "pencil")
														.imageScale(.large)
												}

												Button(action: {
													if let index = self.players.firstIndex(of: player) {
														selectedPlayersBinding.wrappedValue.remove(player)
														DispatchQueue.main.async {
															self.players[index].delete(from: self.viewContext)
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
											let player = self.players[index]
											selectedPlayersBinding.wrappedValue.remove(player)
										}
										DispatchQueue.main.async {
											self.players.delete(at: indices, from: self.viewContext)
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
							displayMode: players.isEmpty ? .inline : .large)
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
							PlayerManagedObject.deleteAll(from: self.viewContext)
						}
					}) {
						Image(systemName: "text.badge.xmark")
					}
					.modifier(BetterTappableIcon())

					Button(action: {
						for i in 0..<5 {
							PlayerManagedObject.create(name: "Player \(i + 1)",
								rating: Double((0...20).randomElement() ?? 0),
								in: self.viewContext)
						}
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
					.environment(\.managedObjectContext, self.viewContext)
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
		let core = TeamAppCore()
		return PlayersListView()
			.environment(\.managedObjectContext, context)
			.environmentObject(core)
	}
}
#endif
