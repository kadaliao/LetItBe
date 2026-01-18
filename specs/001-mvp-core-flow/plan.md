# Implementation Plan: MVP 核心流程

**Branch**: `[001-mvp-core-flow]` | **Date**: 2026-01-17 | **Spec**: /Users/liaoxingyi/workspace/letitbe/specs/001-mvp-core-flow/spec.md
**Input**: Feature specification from `/Users/liaoxingyi/workspace/letitbe/specs/001-mvp-core-flow/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

实现 Let It Be 的 MVP 核心流程：主页入口 → 状态选择 → 卡片展示 → 止损计时，并确保
离线可用、无账号、内容低摩擦、TDD 测试先行。

## Technical Context

**Language/Version**: Swift 5.9  
**Primary Dependencies**: SwiftUI（UI），Combine（状态流转，若需）  
**Storage**: Bundle 内置 JSON + 本地持久化 SQLite  
**Testing**: XCTest（单元/基础 UI 测试）  
**Target Platform**: iOS 15+  
**Project Type**: mobile（iOS）  
**Performance Goals**: 关键操作 500ms 内可完成界面切换，核心动线稳定 60 fps  
**Constraints**: 离线可用、无需账号、不采集情绪数据、内容短且低摩擦  
**Scale/Scope**: 4 个核心视图、几十条卡片内容、单机用户规模

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] Principle I: Content/UX avoids guilt, commands, and promises.
- [x] Principle II: Scope stays single-purpose; no social/gamified features.
- [x] Principle III: TDD plan with tests-first coverage for acceptance scenarios.
- [x] Principle IV: Local-first and privacy constraints preserved.
- [x] Principle V: Design favors simple, explicit structures.

结论：通过。Phase 1 设计后复核依然满足上述原则。

## Project Structure

### Documentation (this feature)

```text
specs/001-mvp-core-flow/
├── plan.md              # 本文件
├── research.md          # Phase 0 输出
├── data-model.md        # Phase 1 输出
├── quickstart.md        # Phase 1 输出
├── contracts/           # Phase 1 输出
└── tasks.md             # Phase 2 输出（由 /speckit.tasks 生成）
```

### Source Code (repository root)

```text
ios/
├── LetItBeApp/
│   ├── App/
│   ├── Views/
│   ├── ViewModels/
│   ├── Models/
│   ├── Services/
│   ├── Persistence/
│   └── Resources/
│       └── content.json
├── LetItBeTests/
└── LetItBeUITests/
```

**Structure Decision**: 采用 iOS 单体工程结构，SwiftUI 视图与 MVVM 分层，资源与持久化
独立目录以保持可读性与简洁性。

## Complexity Tracking

无违反宪法原则的复杂性引入项。
