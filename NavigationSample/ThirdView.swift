//
//  ThirdView.swift
//  NavigationSample
//
//  Created by 小田島 直樹 on 8/16/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct ThirdReducer: Reducer {
    @ObservableState
    struct State: Equatable {}
    
    enum Action {
        case dismissButtonPressed
    }
    
    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}

struct ThirdView: View {
    var store: StoreOf<ThirdReducer>
    
    var body: some View {
        Button("dismiss") {
            store.send(.dismissButtonPressed)
        }
    }
}

final class ThirdViewController: UIHostingController<ThirdView> {
    @UIBindable var store: StoreOf<ThirdReducer>
    
    init(store: StoreOf<ThirdReducer>) {
        self.store = store
        super.init(rootView: ThirdView(store: store))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Third"
    }
}

#Preview {
    ThirdView(
        store: StoreOf<ThirdReducer>(initialState: ThirdReducer.State()) {
            ThirdReducer()
        }
    )
}
