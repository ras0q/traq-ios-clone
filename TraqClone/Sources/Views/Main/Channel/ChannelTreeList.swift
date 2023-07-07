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
    private let store: StoreOf<ServiceCore>
    private let channels: [ChannelNode]
    @Binding private var channelPath: [TraqAPI.Channel]

    public init(
        store: StoreOf<ServiceCore>,
        channels: [ChannelNode],
        channelPath: Binding<[TraqAPI.Channel]>
    ) {
        self.store = store
        self.channels = channels
        _channelPath = channelPath
    }

    var body: some View {
        WithViewStore(store) { _ in
            List(channels, id: \.id, children: \.children) { channel in
                hashImageView(haveChildren: !(channel.children ?? []).isEmpty)

                // Buttonだと行全体に判定がついてしまうため.onTapGestureを使う
                HStack {
                    Text(channel.name)
                    Spacer()
                }
                .contentShape(Rectangle()) // Spacerにも判定をつける
                .onTapGesture {
                    channelPath.append(channel.toTraqChannel())
                }
            }
        }
    }

    private func hashImageView(haveChildren: Bool) -> some View {
        HStack {
            let imageView = Image(systemName: "number")
                .fixedSize()
                .padding(4)

            if haveChildren {
                imageView
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.black, lineWidth: 2)
                    )
            } else {
                imageView
            }
        }
    }
}
