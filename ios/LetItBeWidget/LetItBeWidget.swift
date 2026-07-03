import WidgetKit
import SwiftUI
import ActivityKit
import AppIntents

@main
struct LetItBeWidgetBundle: WidgetBundle {
    var body: some Widget {
        DailyCardWidget()
        BreathingLiveActivity()
    }
}

// MARK: - 交互：小组件上直接换一条

struct NextWidgetCardIntent: AppIntent {
    static var title: LocalizedStringResource = "widget_swap_title"
    /// 只服务 widget 按钮，不进快捷指令库（App 内已有 OpenCardIntent）
    static var isDiscoverable: Bool = false

    func perform() async throws -> some IntentResult {
        SharedDefaults.widgetCardOffset += 1
        WidgetCenter.shared.reloadTimelines(ofKind: "DailyCardWidget")
        return .result()
    }
}

// MARK: - 呼吸实时活动（锁屏 / 灵动岛）

struct BreathingLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BreathingActivityAttributes.self) { context in
            HStack(spacing: 14) {
                Image(systemName: "wind")
                    .font(.system(size: 22, weight: .light))

                VStack(alignment: .leading, spacing: 2) {
                    Text("live_breathing_title")
                        .font(.custom("Songti SC", size: 16))

                    Text("live_breathing_subtitle")
                        .font(.system(size: 12))
                        .opacity(0.7)
                }

                Spacer()

                Text(timerInterval: Date.now...context.state.endDate, countsDown: true)
                    .font(.system(size: 28, weight: .light, design: .rounded))
                    .monospacedDigit()
                    .frame(maxWidth: 76)
                    .multilineTextAlignment(.trailing)
            }
            .padding(16)
            .activityBackgroundTint(Color.black.opacity(0.6))
            .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "wind")
                        .font(.system(size: 20, weight: .light))
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("live_breathing_title")
                        .font(.custom("Songti SC", size: 15))
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(timerInterval: Date.now...context.state.endDate, countsDown: true)
                        .font(.system(size: 22, weight: .light, design: .rounded))
                        .monospacedDigit()
                        .frame(maxWidth: 64)
                }
            } compactLeading: {
                Image(systemName: "wind")
            } compactTrailing: {
                Text(timerInterval: Date.now...context.state.endDate, countsDown: true)
                    .monospacedDigit()
                    .frame(maxWidth: 44)
            } minimal: {
                Image(systemName: "wind")
            }
        }
    }
}

// MARK: - Timeline

struct CardEntry: TimelineEntry {
    let date: Date
    let title: String
    let body: String
    let footer: String
    let stateName: String
    let cardID: String?
}

struct DailyCardProvider: TimelineProvider {
    private let repository = ContentRepository()

    /// 每 4 小时换一句，一次给未来 6 个时间块。
    private let blockSeconds: TimeInterval = 4 * 3600

    func placeholder(in context: Context) -> CardEntry {
        sampleEntry()
    }

    func getSnapshot(in context: Context, completion: @escaping (CardEntry) -> Void) {
        completion(entry(for: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CardEntry>) -> Void) {
        let now = Date()
        let blockStart = Date(timeIntervalSince1970: floor(now.timeIntervalSince1970 / blockSeconds) * blockSeconds)
        var entries: [CardEntry] = []
        for index in 0..<6 {
            let blockDate = blockStart.addingTimeInterval(TimeInterval(index) * blockSeconds)
            let entryDate = max(blockDate, now)
            var entry = self.entry(for: blockDate)
            entry = CardEntry(
                date: entryDate,
                title: entry.title,
                body: entry.body,
                footer: entry.footer,
                stateName: entry.stateName,
                cardID: entry.cardID
            )
            entries.append(entry)
        }
        completion(Timeline(entries: entries, policy: .atEnd))
    }

    private func entry(for date: Date) -> CardEntry {
        guard let payload = try? repository.load(), !payload.cards.isEmpty else {
            return sampleEntry()
        }

        var cards = payload.cards
        var stateName = ""
        if let key = SharedDefaults.lastState,
           let state = payload.states.first(where: { $0.key == key }) {
            let filtered = payload.cards.filter { $0.stateId == state.id }
            if !filtered.isEmpty {
                cards = filtered
                stateName = state.name
            }
        }

        // 用时间块做确定性选卡，同一时间块内保持稳定；「换一条」通过偏移量跳卡
        let block = UInt64(floor(date.timeIntervalSince1970 / blockSeconds))
        let offset = UInt64(max(0, SharedDefaults.widgetCardOffset))
        let index = Int((block &* 2654435761 &+ offset &* 97) % UInt64(cards.count))
        let card = cards[index]
        if stateName.isEmpty {
            stateName = payload.states.first(where: { $0.id == card.stateId })?.name ?? ""
        }
        return CardEntry(
            date: date,
            title: card.title,
            body: card.body,
            footer: card.footer,
            stateName: stateName,
            cardID: card.id
        )
    }

    private func sampleEntry() -> CardEntry {
        CardEntry(
            date: Date(),
            title: String(localized: "widget_sample_title"),
            body: String(localized: "widget_sample_body"),
            footer: String(localized: "widget_sample_footer"),
            stateName: "",
            cardID: nil
        )
    }
}

// MARK: - Views

struct DailyCardWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    @Environment(\.colorScheme) private var scheme

    let entry: CardEntry

    private var textColor: Color {
        scheme == .dark ? Color(red: 0.95, green: 0.95, blue: 0.95) : Color(red: 0.24, green: 0.24, blue: 0.24)
    }

    private var secondaryColor: Color {
        scheme == .dark ? Color(red: 0.7, green: 0.7, blue: 0.7) : Color(red: 0.59, green: 0.59, blue: 0.59)
    }

    private var paperColor: Color {
        scheme == .dark ? Color(red: 0.1, green: 0.1, blue: 0.1) : Color(red: 0.99, green: 0.98, blue: 0.976)
    }

    var body: some View {
        Group {
            switch family {
            case .accessoryRectangular:
                accessoryView
            case .systemMedium:
                mediumView
            default:
                smallView
            }
        }
        .widgetURL(deepLinkURL)
    }

    private var deepLinkURL: URL? {
        guard let cardID = entry.cardID else { return nil }
        return URL(string: "letitbe://card/\(cardID)")
    }

    private var smallView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(entry.title)
                .font(.custom("Songti SC", size: 18))
                .foregroundColor(textColor)

            Spacer(minLength: 0)

            HStack(alignment: .bottom, spacing: 4) {
                Text(entry.footer)
                    .font(.system(size: 11))
                    .foregroundColor(secondaryColor)
                    .lineLimit(3)

                Spacer(minLength: 4)

                swapButton
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(for: .widget) { paperColor }
    }

    private var mediumView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.title)
                .font(.custom("Songti SC", size: 18))
                .foregroundColor(textColor)

            Text(entry.body.replacingOccurrences(of: "\n", with: " "))
                .font(.custom("Songti SC", size: 14))
                .foregroundColor(textColor.opacity(0.85))
                .lineLimit(2)

            Spacer(minLength: 0)

            HStack(alignment: .center, spacing: 4) {
                Text(entry.footer)
                    .font(.system(size: 11))
                    .foregroundColor(secondaryColor)
                    .lineLimit(1)

                Spacer(minLength: 4)

                swapButton
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(for: .widget) { paperColor }
    }

    /// 小组件上的「换一条」：不打开 App，原地换一句。
    private var swapButton: some View {
        Button(intent: NextWidgetCardIntent()) {
            Image(systemName: "arrow.2.squarepath")
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(secondaryColor.opacity(0.85))
                .frame(width: 24, height: 24)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text("widget_swap_accessibility"))
    }

    private var accessoryView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(entry.title)
                .font(.system(size: 14, weight: .semibold))

            Text(entry.footer)
                .font(.system(size: 12))
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .containerBackground(for: .widget) { Color.clear }
    }
}

// MARK: - Widget

struct DailyCardWidget: Widget {
    let kind = "DailyCardWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DailyCardProvider()) { entry in
            DailyCardWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(Text("widget_display_name"))
        .description(Text("widget_description"))
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular])
    }
}
