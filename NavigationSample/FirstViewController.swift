//
//  FirstViewController.swift
//  NavigationSample
//
//  Created by 小田島 直樹 on 8/16/24.
//

import ComposableArchitecture
import UIKit

@Reducer
struct FirstReducer: Reducer {
    @Reducer(state: .equatable)
    enum Destination {
        case navigationDestinationSecond(SecondReducer)
        case presentSecond(SecondReducer)
    }
    
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case navigationDestinationSecondButtonPressed
        case presentSecondButtonPressed
        case destination(PresentationAction<Destination.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { (state: inout State, action: Action) -> EffectOf<Self> in
            switch action {
            case .navigationDestinationSecondButtonPressed:
                state.destination = .navigationDestinationSecond(SecondReducer.State())
                return .none
            case .presentSecondButtonPressed:
                state.destination = .presentSecond(SecondReducer.State())
                return .none
            case .destination(.presented(.navigationDestinationSecond(.dismissButtonPressed))):
                state.destination = nil
                return .none
            case .destination(.presented(.presentSecond(.dismissButtonPressed))):
                state.destination = nil
                return .none
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        ._printChanges()
    }
}

final class FirstViewController: UIViewController {
    @UIBindable var store: StoreOf<FirstReducer> = .init(initialState: FirstReducer.State()) {
        FirstReducer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "First"
        
        navigationDestination(
            item: $store.scope(
                state: \.destination?.navigationDestinationSecond,
                action: \.destination.navigationDestinationSecond
            )
        ) { store in
            SecondViewController(store: store)
        }
        
        present(
            item: $store.scope(
                state: \.destination?.presentSecond,
                action: \.destination.presentSecond
            )
        ) { store in
            let rootVC = SecondViewController(store: store)
            return UINavigationController(rootViewController: rootVC)
        }
    }
    
    @IBAction private func navigationDestinationSecondButtonPressed(_ sender: Any) {
        store.send(.navigationDestinationSecondButtonPressed)
    }
    
    @IBAction private func presentSecondButtonPressed(_ sender: Any) {
        store.send(.presentSecondButtonPressed)
    }
}

