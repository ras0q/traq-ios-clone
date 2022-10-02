//
//  SwiftUIView.swift
//
//
//  Created by Kira Kawai on 2022/09/15.
//

import ComposableArchitecture
import Models
import Stores
import SwiftUI
import Traq

struct ChannelTreeList: View {
    private let store: ServiceCore.Store
    private let channels: [ChannelNode]
    @Binding private var channelPath: [TraqAPI.Channel]

    public init(
        store: ServiceCore.Store,
        channels: [ChannelNode],
        channelPath: Binding<[TraqAPI.Channel]>
    ) {
        self.store = store
        self.channels = channels
        _channelPath = channelPath
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            List(channels, id: \.id, children: \.children) { channel in
                let imageView = Image(systemName: "number")
                    .fixedSize()
                    .padding(4)

                if (channel.children ?? []).isEmpty {
                    imageView
                } else {
                    imageView
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.black, lineWidth: 2)
                        )
                }

                // Buttonだと行全体に判定がついてしまうため.onTapGestureを使う
                HStack {
                    Text(channel.name)
                    Spacer()
                }
                .contentShape(Rectangle()) // Spacerにも判定をつける
                .onTapGesture {
                    viewStore.send(.message(.fetchMessages(channelId: channel.id)))
                    channelPath.append(channel.toTraqChannel())
                }
            }
        }
    }
}
