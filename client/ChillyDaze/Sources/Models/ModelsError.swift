import Foundation

public enum ModelsError: LocalizedError {
    case invalidDateStringFormat
    case invalidURLString

    var errorDescription: String {
        switch self {
        case .invalidDateStringFormat:
            return "Date String format is invalid."

        case .invalidURLString:
            return "URL String is invalid."
        }
    }
}
