# Implementation Plan: UI 高保真对齐

**Branch**: `[002-ui-hifi-align]` | **Date**: 2026-01-18 | **Spec**: /Users/liaoxingyi/workspace/letitbe/specs/002-ui-hifi-align/spec.md
**Input**: Feature specification from `/Users/liaoxingyi/workspace/letitbe/specs/002-ui-hifi-align/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

将主页、状态选择、卡片页、止损页高保真对齐 `docs/prototype.html`，并补齐深色模式与动效，
保证视觉一致性且不影响现有功能流程。

## Technical Context

**Language/Version**: Swift 5.9  
**Primary Dependencies**: SwiftUI（UI），Combine（状态流转，若需）  
**Storage**: Bundle 内置 JSON + 本地持久化 SQLite  
**Testing**: XCTest（单元/基础 UI 测试）  
**Target Platform**: iOS 15+  
**Project Type**: mobile（iOS）  
**Performance Goals**: 关键过渡动效稳定 60 fps，页面切换 500ms 内完成  
**Constraints**: 视觉高保真对齐原型；不改变功能流程与文案  
**Scale/Scope**: 4 个核心视图，主题与动效覆盖全局

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] Principle I: Content/UX avoids guilt, commands, and promises.
- [x] Principle II: Scope stays single-purpose; no social/gamified features.
- [x] Principle III: TDD plan with tests-first coverage for acceptance scenarios.
- [x] Principle IV: Local-first and privacy constraints preserved.
- [x] Principle V: Design favors simple, explicit structures.

结论：通过。

## Project Structure

### Documentation (this feature)

```text
specs/002-ui-hifi-align/
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
│   ├── Resources/
│   └── Assets.xcassets/
├── LetItBeTests/
└── LetItBeUITests/
```

**Structure Decision**: UI 样式与主题统一放在 `Views/` 及独立样式文件中，
资源统一进入 `Resources/` 与 `Assets.xcassets/`。

## Complexity Tracking

无违反宪法原则的复杂性引入项。
