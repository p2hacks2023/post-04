import FirebaseAuth
import FirebaseStorage
import Foundation
import SwiftUI

enum Implement {
    static func uploadFile(data: Data?, filename: String) async throws -> String {
        if let data = data {
            try await withCheckedThrowingContinuation { continuation in
                guard let user = Auth.auth().currentUser else {
                    continuation.resume(throwing: CloudStorageClientError.unauthenticated)
                    return
                }

                let storage = Storage.storage()
                let storageRef = storage.reference()
                let fileRef = storageRef.child("users/\(user.uid)/\(filename)")

                fileRef.putData(data, metadata: nil) { (metadata, error) in
                    fileRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            continuation.resume(throwing: CloudStorageClientError.failedToUpload)
                            return
                        }

                        continuation.resume(returning: downloadURL.absoluteString)
                    }
                }
            }
        } else {
            throw CloudStorageClientError.dataIsEmpty
        }
    }

    static func downloadFile(url: String) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            let storage = Storage.storage()
            let fileReference = storage.reference(forURL: url)

            fileReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                if let data = data {
                    continuation.resume(returning: data)
                }
            }
        }
    }
}
