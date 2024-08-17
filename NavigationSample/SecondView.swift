//
//  SecondView.swift
//  NavigationSample
//
//  Created by 小田島 直樹 on 8/16/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct SecondReducer: Reducer {
    @Reducer(state: .equatable)
    enum Destination {
        case third(ThirdReducer)
    }
    
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case thirdButtonPressed
        case dismissButtonPressed
        case destination(PresentationAction<Destination.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { (state: inout State, action: Action) -> EffectOf<Self> in
            switch action {
            case .thirdButtonPressed:
                state.destination = .third(ThirdReducer.State())
                return .none
            case .dismissButtonPressed:
                return .none
            case .destination(.presented(.third(.dismissButtonPressed))):
                state.destination = nil
                return .none
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

struct SecondView: View {
    var store: StoreOf<SecondReducer>
    
    var body: some View {
        VStack {
            Button("Third") {
                store.send(.thirdButtonPressed)
            }
            Button("dismiss") {
                store.send(.dismissButtonPressed)
            }
        }
    }
}

final class SecondViewController: UIHostingController<SecondView> {
    @UIBindable var store: StoreOf<SecondReducer>
    
    init(store: StoreOf<SecondReducer>) {
        self.store = store
        super.init(rootView: SecondView(store: store))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Second"
        
        navigationDestination(
            item: $store.scope(state: \.destination?.third, action: \.destination.third)
        ) { store in
            ThirdViewController(store: store)
        }
    }
}

#Preview {
    SecondView(
        store: StoreOf<SecondReducer>(initialState: SecondReducer.State()) {
            SecondReducer()
        }
    )
}
