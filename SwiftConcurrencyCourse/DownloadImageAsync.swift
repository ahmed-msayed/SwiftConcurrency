//
//  DownloadImageAsync.swift
//  SwiftConcurrencyCourse
//
//  Created by Ahmed Sayed on 20/10/2024.
//

import SwiftUI
import Combine

class DownloadImageAsyncImageLoader {
    let url = URL(string: "https://picsum.photos/200")!
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300
        else {
            return nil
        }
        return image
    }
    
    func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            let image = self?.handleResponse(data: data, response: response)
            completionHandler(image, error)
        }
        .resume()
    }
    //[weak self] -> class is stored in the Heap, and the URLSession line executes and waits to get data
    //before executing the completion, weak self sets a low "0" reference count to the class in the Heap
    //so that if the user clicks "back" before the server responds and return the data, the completion
    //won't execute and won't run the next line as the class got removed from the Heap in the memory.
    
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError({ $0 })
            .eraseToAnyPublisher()
    }
    
    func downloadWithAsync () async throws -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            let image = handleResponse(data: data, response: response)
            return image
        } catch  {
            throw error
        }
    }
}

class DownloadImageAsyncViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let loader = DownloadImageAsyncImageLoader()
    var cancelables = Set<AnyCancellable>()
    
    func fetchImage() async {
//                loader.downloadWithEscaping { [weak self] image, error in
        //            DispatchQueue.main.async {
        //                self?.image = image
        //            }
        //        }
        
        //        loader.downloadWithCombine()
        //            .receive(on: DispatchQueue.main)
        //            .sink{ _ in
        //            }
        //        receiveValue: { [weak self] image in
        //                self?.image = image
        //        }
        //        .store(in: &cancelables)
        
        let image = try? await loader.downloadWithAsync()
        await MainActor.run {
            self.image = image
        }
    }
}


struct DownloadImageAsync: View {
    @StateObject private var viewModel = DownloadImageAsyncViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        } .onAppear() {
            //            viewModel.fetchImage()
            Task {
                await viewModel.fetchImage()
            }
        }
        
    }
}

#Preview {
    DownloadImageAsync()
}
