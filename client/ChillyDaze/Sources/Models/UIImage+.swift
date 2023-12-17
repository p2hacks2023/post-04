import SwiftUI

public extension UIImage {
    var safeCiImage: CIImage? {
        return self.ciImage ?? CIImage(image: self)
    }

    var safeCgImage: CGImage? {
        if let cgImge = self.cgImage {
            return cgImge
        }
        if let ciImage = safeCiImage {
            let context = CIContext(options: nil)
            return context.createCGImage(ciImage, from: ciImage.extent)
        }
        return nil
    }

    func cropped(to rect: CGRect) -> UIImage? {
        guard let unwrappedCGImage = safeCgImage else {
            return nil
        }
        guard let imgRef = unwrappedCGImage.cropping(to: rect) else {
            return nil
        }
        return UIImage(cgImage: imgRef, scale: scale, orientation: imageOrientation)
    }
}
