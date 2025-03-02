//
//  OnboardingView.swift
//  voiceMemo
//

import SwiftUI

struct OnboardingView: View {
  @StateObject private var pathModel = PathModel()
  @StateObject private var onboardingViewModel = OnboardingViewModel()
  @StateObject private var todoListViewModel = TodoListViewModel()


  var body: some View {


    //OnboardingContentView(onboardingViewModel: onboardingViewModel)
    NavigationStack(path: $pathModel.paths) {
//      OnboardingContentView(onboardingViewModel: onboardingViewModel)
      TodoListView()
        .environmentObject(todoListViewModel)
        .navigationDestination(
          for: PathType.self,
          destination: { pathType in
            switch pathType {
              case .homeView:
                HomeView()
                  .navigationBarBackButtonHidden()

              case .todoView:
                TodoView()
                  .navigationBarBackButtonHidden()
                  .environmentObject(todoListViewModel)

              case .memoView:
                MemoView()
                  .navigationBarBackButtonHidden()
            }

          }
        )
    }
    .environmentObject(pathModel)
  }
}

// MARK: - Onboarding Content View
private struct OnboardingContentView: View {
  @ObservedObject private var onboardingViewModel: OnboardingViewModel

  fileprivate init(onboardingViewModel: OnboardingViewModel) {
    self.onboardingViewModel = onboardingViewModel
  }

  fileprivate var body: some View {
    VStack {
      // Onboarding CellList View
      OnboardingCellListView(onboardingViewModel: onboardingViewModel)

      Spacer()
      // Start Button View
      StartBtnView()

    }
    .edgesIgnoringSafeArea(.top)
  }


}

// MARK: - Onboarding CellList View

private struct OnboardingCellListView: View {
  @ObservedObject private var onboardingViewModel: OnboardingViewModel
  @State private var selectedIndex: Int

  fileprivate init(
    onboardingViewModel: OnboardingViewModel,
    selectedIndex: Int = 0
  ) {
    self.onboardingViewModel = onboardingViewModel
    self.selectedIndex = selectedIndex
  }

  fileprivate var body: some View {
    TabView(selection: $selectedIndex) {
      ForEach(Array(onboardingViewModel.onboardingContents.enumerated()), id: \.element) { index, onboardingContent in
        OnboardingCellView(onboardingContent: onboardingContent)
          .tag(index)
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
    .background(
      selectedIndex % 2 == 0
      ? Color.customSky
      : Color.customBackgroundGreen
    )
    .clipped()
  }
}

// MARK: - Onboarding Cell View

private struct OnboardingCellView : View {
  private var onboardingContent: OnboardingContent

  fileprivate init(onboardingContent: OnboardingContent) {
    self.onboardingContent = onboardingContent
  }

  fileprivate var body: some View {
    VStack {
      Image(onboardingContent.imageFileName)
        .resizable()
        .scaledToFit()
      HStack {
        Spacer()

        VStack {
          Spacer()
            .frame(height: 46)

          Text(onboardingContent.title)
            .font(.system(size: 16, weight: .bold))

          Spacer()
            .frame(height: 5)

          Text(onboardingContent.subTitle)
            .font(.system(size: 16))

        }
        Spacer()
      }
      .background(Color.customWhite)
      .cornerRadius(0)

    }
    .shadow(radius: 10)
  }

}

// MARK: - Start Button View

private struct StartBtnView: View {
  @EnvironmentObject private var pathModel: PathModel

  fileprivate var body: some View {
    Button(action: { pathModel.paths.append(.homeView)

    }, label: {
      HStack {
        Text("시작하기")
          .font(.system(size: 16, weight: .medium))
          .foregroundColor(.customGreen)

        Image("startHome")
          .renderingMode(.template)
          .foregroundColor(.customGreen)

      }


    })
    .padding(.bottom, 50)
  }

}

struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView()
  }
}
