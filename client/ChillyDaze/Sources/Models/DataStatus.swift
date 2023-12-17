import Foundation

public enum DataStatus<T>: Equatable where T: Equatable {
    case initialized
    case loading
    case loaded(T)
}
