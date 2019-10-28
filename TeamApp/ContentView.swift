//
//  ContentView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 10/21/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()

struct ContentView: View {
    @Environment(\.managedObjectContext)
    var viewContext   
 
    var body: some View {
        NavigationView {
            MasterView()
                .navigationBarTitle(Text("TeamApp"))
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(
                        action: {
                            withAnimation {
								Player.create(name: "Player " + dateFormatter.string(from: Date()), rating: round(Double.random(in: 0...5)), in: self.viewContext)
							}
                        }
                    ) { 
                        Image(systemName: "plus")
                    }
                )
            Text("Detail view content goes here")
                .navigationBarTitle(Text("Detail"))
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct MasterView: View {
    @FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Player.name, ascending: true)],
        animation: .default)
    var players: FetchedResults<Player>

    @Environment(\.managedObjectContext)
    var viewContext

    var body: some View {
        List {
            ForEach(players, id: \.self) { player in
                NavigationLink(
                    destination: DetailView(player: player)
                ) {
					Text("\(player.name), \(player.rating)")
                }
            }.onDelete { indices in
                self.players.delete(at: indices, from: self.viewContext)
            }
        }
    }
}

struct DetailView: View {
    @ObservedObject var player: Player

    var body: some View {
		Text("\(player.name), \(player.rating)")
			.navigationBarTitle(Text(player.name))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
