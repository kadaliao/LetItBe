# LetItBe

A minimal iOS app that delivers short, low-pressure support cards for low-energy moments, with optional "repair" actions. v2.0: open straight to a card.

一个极简 iOS 应用，在低能量时提供轻量支持卡片，并包含可选的"修复"动作。v2.0 起：打开即卡片。

## Features

- Opens straight to a card (remembers your last mood state); light state switcher on top.
- Swipe left/right for another card, with transitions and haptics.
- Bookmark lines you want to keep ("Saved lines").
- Guided repair actions: breathing (1/2/5 min, haptic rhythm) and a tiny checklist.
- Home & Lock Screen widget: one quiet line per time block, deep links back into the app.
- Appearance follows the system (manual override available); Dynamic Type support.
- Local-first data, offline-friendly, no accounts, no analytics.

## 功能

- 打开即卡片（记住上次状态），顶部轻量切换 累 / 麻 / 躲 / 烦。
- 左右滑动换一条，带动效与触觉反馈。
- 收藏「捡回来」：书签留住不想弄丢的句子。
- 修复动作：呼吸（1/2/5 分钟，触觉节奏）与极简小清单。
- 桌面 / 锁屏小组件「每日一句」，可深链回对应卡片。
- 外观跟随系统（可手动指定），支持动态字体。
- 本地优先、离线可用、无账号、无统计。

## Tech Stack

- Swift 5.9, iOS 17+
- SwiftUI with `@Observable`
- WidgetKit (LetItBeWidget extension), App Group shared defaults
- SQLite (repair session records)

## Project Structure / 项目结构

```
ios/
  LetItBeApp/               # App sources, resources, and Xcode project / 应用源码与工程
    App/                    # Entry, root routing, UI-test hooks
    Views/                  # MainCardView, FirstRunView, RepairView, Favorites, About...
    ViewModels/             # ContentStore (card deck), FavoritesStore, StopLossViewModel
    Models/                 # Card, MoodState, ContentPayload, StopLossSession
    Services/               # ContentRepository, ShareImageService, StopLoss*
    Shared/                 # App Group defaults shared with the widget
    Persistence/            # SQLiteStore
  LetItBeWidget/            # WidgetKit extension（每日一句）
  LetItBeTests/             # Unit tests / 单元测试
  LetItBeUITests/           # UI tests / UI 测试
```

## Getting Started

1. Open `ios/LetItBeApp/LetItBeApp.xcodeproj` in Xcode (15+ / iOS 17 SDK).
2. Select the `LetItBeApp` scheme.
3. Run on a simulator or device.

The Xcode project is generated from `ios/LetItBeApp/project.yml` — after changing file layout or targets, run `xcodegen generate` in `ios/LetItBeApp/`.

工程由 `project.yml` 生成——调整文件结构或 target 后，在 `ios/LetItBeApp/` 下运行 `xcodegen generate`。

## Tests

- Run all tests in Xcode: Product -> Test.
- Unit tests: `LetItBeTests`（内容仓库、卡组轮换、收藏、修复会话）
- UI tests: `LetItBeUITests`（首启动线、直达卡片、换卡/滑动、修复、收藏、菜单）

CLI:

```bash
cd ios/LetItBeApp
xcodebuild test -project LetItBeApp.xcodeproj -scheme LetItBeApp \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## Content and Localization / 内容与本地化

- Content / 内容文件:
  - `ios/LetItBeApp/Resources/zh-Hans.lproj/content.json`（800 张）
  - `ios/LetItBeApp/Resources/en.lproj/content.json`（120 张）
- Strings / 文案:
  - `ios/LetItBeApp/Resources/zh-Hans.lproj/Localizable.strings`
  - `ios/LetItBeApp/Resources/en.lproj/Localizable.strings`

## Widget

Long-press the Home Screen → add widget → Let It Be. Lock Screen rectangular widget is also supported. The widget rotates one line per 4-hour block, preferring your last selected state; tapping deep-links to that card via `letitbe://card/<id>`.
