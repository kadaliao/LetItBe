import ActivityKit
import Foundation

/// 呼吸修复的锁屏实时活动：只有一个倒计时截止时间。
struct BreathingActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var endDate: Date
    }

    var startDate: Date
}
