import WidgetKit
import SwiftUI

// MARK: - Model
struct TaskEntry: TimelineEntry {
    let date: Date
    let tasks: [WidgetTask]
    let totalCount: Int
    let completedCount: Int
}

struct WidgetTask: Identifiable {
    let id: String
    let title: String
    let priority: String
    let isOverdue: Bool
}

// MARK: - Provider
struct TaskProvider: TimelineProvider {
    func placeholder(in context: Context) -> TaskEntry {
        TaskEntry(
            date: Date(),
            tasks: [
                WidgetTask(id: "1", title: "Mobile app UI tasarımı", priority: "high", isOverdue: true),
                WidgetTask(id: "2", title: "Login bug düzelt", priority: "high", isOverdue: false),
                WidgetTask(id: "3", title: "Q4 raporu hazırla", priority: "medium", isOverdue: false),
            ],
            totalCount: 6,
            completedCount: 2
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> ()) {
        completion(loadEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TaskEntry>) -> ()) {
        let entry = loadEntry()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func loadEntry() -> TaskEntry {
        let userDefaults = UserDefaults(suiteName: "group.com.example.smarttasktracker")
        let tasksData = userDefaults?.string(forKey: "widget_tasks") ?? "[]"
        let totalCount = userDefaults?.integer(forKey: "widget_total_count") ?? 0
        let completedCount = userDefaults?.integer(forKey: "widget_completed_count") ?? 0

        var tasks: [WidgetTask] = []
        if let data = tasksData.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
            tasks = json.prefix(3).compactMap { dict in
                guard let id = dict["id"] as? String,
                      let title = dict["title"] as? String else { return nil }
                return WidgetTask(
                    id: id,
                    title: title,
                    priority: dict["priority"] as? String ?? "medium",
                    isOverdue: dict["isOverdue"] as? Bool ?? false
                )
            }
        }

        return TaskEntry(
            date: Date(),
            tasks: tasks,
            totalCount: totalCount,
            completedCount: completedCount
        )
    }
}

// MARK: - Colors
extension Color {
    static let priorityHigh = Color(red: 0.94, green: 0.27, blue: 0.23)
    static let priorityMedium = Color(red: 0.96, green: 0.62, blue: 0.04)
    static let priorityLow = Color(red: 0.06, green: 0.72, blue: 0.51)
    static let appDark = Color(red: 0.11, green: 0.11, blue: 0.13)
    static let appRed = Color(red: 0.91, green: 0.27, blue: 0.23)
}

func priorityColor(_ priority: String) -> Color {
    switch priority {
    case "high": return .priorityHigh
    case "low":  return .priorityLow
    default:     return .priorityMedium
    }
}

// MARK: - Small Widget
struct SmallWidgetView: View {
    let entry: TaskEntry

    var completionPercent: Int {
        guard entry.totalCount > 0 else { return 0 }
        return Int((Double(entry.completedCount) / Double(entry.totalCount)) * 100)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.appRed)
                    .font(.system(size: 12))
                Text("TaskFlow")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }

            Spacer()

            Text("\(completionPercent)%")
                .font(.system(size: 36, weight: .black))
                .foregroundColor(.white)

            Text("tamamlandı")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.5))

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(0.15))
                        .frame(height: 4)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.priorityLow)
                        .frame(width: geo.size.width * CGFloat(completionPercent) / 100, height: 4)
                }
            }
            .frame(height: 4)

            Text("\(entry.completedCount)/\(entry.totalCount) görev")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Medium Widget
struct MediumWidgetView: View {
    let entry: TaskEntry

    var completionPercent: Int {
        guard entry.totalCount > 0 else { return 0 }
        return Int((Double(entry.completedCount) / Double(entry.totalCount)) * 100)
    }

    var body: some View {
        HStack(spacing: 12) {
            // Sol: İstatistik
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.appRed)
                        .font(.system(size: 11))
                    Text("TaskFlow")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                }

                Spacer()

                Text("\(completionPercent)%")
                    .font(.system(size: 30, weight: .black))
                    .foregroundColor(.white)

                Text("tamamlandı")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white.opacity(0.15))
                            .frame(height: 3)
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.priorityLow)
                            .frame(width: geo.size.width * CGFloat(completionPercent) / 100, height: 3)
                    }
                }
                .frame(height: 3)

                Text("\(entry.totalCount - entry.completedCount) bekliyor")
                    .font(.system(size: 9))
                    .foregroundColor(.white.opacity(0.4))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Ayırıcı
            Rectangle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 1)

            // Sağ: Task listesi
            VStack(alignment: .leading, spacing: 6) {
                Text("YAKLAŞAN")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.white.opacity(0.3))
                    .kerning(0.5)

                if entry.tasks.isEmpty {
                    Spacer()
                    Text("Görev yok 🎉")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.4))
                    Spacer()
                } else {
                    ForEach(entry.tasks) { task in
                        HStack(spacing: 6) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(priorityColor(task.priority))
                                .frame(width: 3, height: 28)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(task.title)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                if task.isOverdue {
                                    Text("Gecikmiş")
                                        .font(.system(size: 9))
                                        .foregroundColor(.priorityHigh)
                                }
                            }
                            Spacer()
                        }
                    }
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Entry View
struct TaskWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: TaskEntry

    var body: some View {
        switch family {
        case .systemSmall:  SmallWidgetView(entry: entry)
        case .systemMedium: MediumWidgetView(entry: entry)
        default:            MediumWidgetView(entry: entry)
        }
    }
}

// MARK: - Widget
struct TaskWidget: Widget {
    let kind: String = "TaskWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TaskProvider()) { entry in
            TaskWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    Color(red: 0.11, green: 0.11, blue: 0.13)
                }
        }
        .configurationDisplayName("TaskFlow")
        .description("Görevlerini takip et.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Preview
#Preview(as: .systemMedium) {
    TaskWidget()
} timeline: {
    TaskEntry(
        date: .now,
        tasks: [
            WidgetTask(id: "1", title: "Mobile app UI tasarımı", priority: "high", isOverdue: true),
            WidgetTask(id: "2", title: "Login bug düzelt", priority: "high", isOverdue: false),
            WidgetTask(id: "3", title: "Q4 raporu hazırla", priority: "medium", isOverdue: false),
        ],
        totalCount: 6,
        completedCount: 2
    )
}
