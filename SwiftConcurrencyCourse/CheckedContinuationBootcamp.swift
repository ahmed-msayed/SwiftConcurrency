//
//  CheckedContinuationBootcamp.swift
//  SwiftConcurrencyCourse
//
//  Created by Ahmed Sayed on 31/10/2024.
//

import SwiftUI

class CheckedContinuationBootcampNetworkManager {
    func getData(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw error
        }
    }
}

class CheckedContinuationBootcampViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let networkManager = CheckedContinuationBootcampNetworkManager()
    
    func getImage() async {
        guard let url = URL(string: "https://picsum.photos/400") else { return }
        
        do {
            let data = try await networkManager.getData(url: url)
            if let image = UIImage(data: data) {
                await MainActor.run (body: {
                    self.image = image
                })
            }
        } catch {
            print(error)
        }
    }
}

struct CheckedContinuationBootcamp: View {
    @StateObject var viewModel = CheckedContinuationBootcampViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await viewModel.getImage()
        }
    }
}

#Preview {
    CheckedContinuationBootcamp()
}
