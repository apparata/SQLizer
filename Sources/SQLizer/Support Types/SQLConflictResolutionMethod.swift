
import Foundation

public enum SQLConflictResolutionType {
    case rollback
    case abort
    case fail
    case ignore
    case replace
}

extension SQLConflictResolutionType {
    public var forQueryString: String {
        switch self {
        case .rollback: return "ROLLBACK"
        case .abort: return "ABORT"
        case .fail: return "FAIL"
        case .ignore: return "IGNORE"
        case .replace: return "REPLACE"
        }
    }
}
