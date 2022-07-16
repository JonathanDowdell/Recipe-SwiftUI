//
//  DelayedTextObject.swift
//  Recipe
//
//  Created by Mettaworldj on 7/16/22.
//

import Foundation
import Combine

public final class DelayedTextObject: ObservableObject {
    @Published var text: String = ""
    @Published var debouncedText: String = ""
    private var bag = Set<AnyCancellable>()
    
    deinit {
        for object in bag {
            object.cancel()
        }
    }

    public init(dueTime: TimeInterval = 0.5) {
        $text
            .removeDuplicates()
            .debounce(for: .seconds(dueTime), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.debouncedText = value
            })
            .store(in: &bag)
    }
}
