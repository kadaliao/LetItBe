# LetItBe

A minimal iOS app that delivers short, low-pressure support cards for low-energy moments, with optional "stop loss" actions.

一个极简 iOS 应用，在低能量时提供轻量支持卡片，并包含可选的“修复”动作。

## Features

- Four mood states with curated content cards.
- One-tap card refresh within the same state.
- Guided "stop loss" actions (breathing, tiny checklists).
- Local-first data and offline-friendly behavior.

## 功能

- 四种情绪状态与对应内容卡片。
- 同一状态下一键换一条。
- 引导式“修复”动作（呼吸、极简清单）。
- 本地优先、离线可用。

## Tech Stack

- Swift 5.9
- SwiftUI
- Combine (where state flow needs it)

## 技术栈

- Swift 5.9
- SwiftUI
- Combine（需要状态流转时使用）

## Project Structure

```
ios/
  LetItBeApp/               # App sources, resources, and Xcode project
  LetItBeTests/             # Unit tests
  LetItBeUITests/           # UI tests and snapshots
```

## 项目结构

```
ios/
  LetItBeApp/               # 应用源码、资源与 Xcode 工程
  LetItBeTests/             # 单元测试
  LetItBeUITests/           # UI 测试与快照
```

## Getting Started

1. Open `ios/LetItBeApp/LetItBeApp.xcodeproj` in Xcode.
2. Select the `LetItBeApp` scheme.
3. Run on a simulator or device.

Optional: `ios/LetItBeApp/project.yml` can be used with XcodeGen if you need to regenerate the Xcode project.

## 开始使用

1. 在 Xcode 中打开 `ios/LetItBeApp/LetItBeApp.xcodeproj`。
2. 选择 `LetItBeApp` scheme。
3. 在模拟器或真机上运行。

可选：如需重新生成 Xcode 工程，可使用 `ios/LetItBeApp/project.yml` 配合 XcodeGen。

## Tests

- Run all tests in Xcode: Product -> Test.
- Unit tests: `LetItBeTests`
- UI tests: `LetItBeUITests`

## 测试

- 在 Xcode 中运行：Product -> Test。
- 单元测试：`LetItBeTests`
- UI 测试：`LetItBeUITests`

## Content and Localization

- Content lives in:
  - `ios/LetItBeApp/Resources/en.lproj/content.json`
  - `ios/LetItBeApp/Resources/zh-Hans.lproj/content.json`
- Localized strings are in:
  - `ios/LetItBeApp/Resources/en.lproj/Localizable.strings`
  - `ios/LetItBeApp/Resources/zh-Hans.lproj/Localizable.strings`

## 内容与本地化

- 内容文件：
  - `ios/LetItBeApp/Resources/en.lproj/content.json`
  - `ios/LetItBeApp/Resources/zh-Hans.lproj/content.json`
- 文案本地化：
  - `ios/LetItBeApp/Resources/en.lproj/Localizable.strings`
  - `ios/LetItBeApp/Resources/zh-Hans.lproj/Localizable.strings`
