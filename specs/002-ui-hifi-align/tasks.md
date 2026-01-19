---

description: "UI 高保真对齐任务清单"
---

# Tasks: UI 高保真对齐

**Input**: /Users/liaoxingyi/workspace/letitbe/specs/002-ui-hifi-align/
**Prerequisites**: plan.md, spec.md, docs/prototype.html

**Tests**: 由于 TDD 要求，测试为必需项，且必须先写后实现。

**Organization**: 任务按用户故事组织，确保每个故事可独立实现与测试。

## Format: `[ID] [P?] [Story] Description`

- **[P]**: 可并行（不同文件、无依赖）
- **[Story]**: US1/US2/US3
- 每条任务必须包含具体文件路径

## Phase 1: Setup（共享基础）

**Purpose**: 建立 UI 主题体系与视觉验收基础

- [x] T001 创建主题与样式定义 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Views/Theme.swift
- [x] T002 [P] 创建颜色资源与命名规范 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Assets.xcassets/Theme.colorset/Contents.json
- [x] T003 [P] 创建视觉走查清单 /Users/liaoxingyi/workspace/letitbe/specs/002-ui-hifi-align/visual-review.md
- [x] T004 [P] 创建 UI 快照测试辅助工具 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeUITests/SnapshotHelper.swift

---

## Phase 2: Foundational（阻塞性基础能力）

**Purpose**: 全局主题、动效与深色模式能力

- [x] T005 [P] 定义字体与间距系统 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Views/Theme.swift
- [x] T006 [P] 定义颜色 token（亮色/暗色）/Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Views/Theme.swift
- [x] T007 [P] 添加视图主题扩展 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Views/View+Theme.swift
- [x] T008 定义深色模式状态与切换 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/ViewModels/ThemeViewModel.swift

**Checkpoint**: 主题系统就绪，后续页面可统一应用

---

## Phase 3: User Story 1 - 主页与状态选择高保真对齐（P1）🎯 MVP

**Goal**: 主页与状态选择页视觉与原型一致

**Independent Test**: 主页与状态选择页快照对比通过且视觉走查无关键偏差

### Tests for User Story 1（必须先写）

- [x] T009 [P] [US1] 主页快照测试 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeUITests/HomeSnapshotTests.swift
- [x] T010 [P] [US1] 状态选择快照测试 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeUITests/StatePickerSnapshotTests.swift

### Implementation for User Story 1

- [x] T011 [P] [US1] 重构主页布局与样式 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Views/HomeView.swift
- [x] T012 [P] [US1] 重构状态选择布局与卡片样式 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Views/StatePickerView.swift
- [x] T013 [P] [US1] 实现状态图标视图 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Views/StateIconView.swift

**Checkpoint**: Home + Picker 与原型一致

---

## Phase 4: User Story 2 - 卡片页高保真对齐（P2）

**Goal**: 卡片页排版、卡片质感与按钮样式匹配原型

**Independent Test**: 卡片页快照对比通过且视觉走查无关键偏差

### Tests for User Story 2（必须先写）

- [x] T014 [P] [US2] 卡片页快照测试 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeUITests/CardSnapshotTests.swift

### Implementation for User Story 2

- [x] T015 [P] [US2] 更新卡片容器与排版 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Views/CardView.swift
- [x] T016 [P] [US2] 实现卡片样式组件 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Views/CardStyle.swift

**Checkpoint**: 卡片页与原型一致

---

## Phase 5: User Story 3 - 止损页与动效高保真对齐（P3）

**Goal**: 止损页呼吸动效与深色模式对齐原型

**Independent Test**: 止损页快照（亮/暗）通过且动效演示符合原型

### Tests for User Story 3（必须先写）

- [x] T017 [P] [US3] 止损页快照测试（亮色）/Users/liaoxingyi/workspace/letitbe/ios/LetItBeUITests/StopLossSnapshotTests.swift
- [x] T018 [P] [US3] 深色模式切换 UI 测试 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeUITests/ThemeToggleTests.swift

### Implementation for User Story 3

- [x] T019 [P] [US3] 更新止损页布局与文案排版 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Views/StopLossView.swift
- [x] T020 [P] [US3] 实现呼吸动效视图 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Views/BreathingGuideView.swift
- [x] T021 [US3] 添加深色模式切换控件 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Views/TopControlsView.swift

**Checkpoint**: 止损页与动效高保真对齐

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: 视觉一致性与验收完善

- [x] T022 [P] 完成视觉走查记录 /Users/liaoxingyi/workspace/letitbe/specs/002-ui-hifi-align/visual-review.md
- [x] T023 [P] 更新冒烟验证说明 /Users/liaoxingyi/workspace/letitbe/specs/002-ui-hifi-align/quickstart.md

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: 无依赖，可立即开始
- **Foundational (Phase 2)**: 依赖 Setup 完成，阻塞所有用户故事
- **User Stories (Phase 3+)**: 依赖 Foundational 完成，可按优先级并行推进
- **Polish (Phase 6)**: 依赖各用户故事完成

### User Story Dependencies

- **US1 (P1)**: 无依赖
- **US2 (P2)**: 依赖 US1 完成（共享主题系统与基础布局）
- **US3 (P3)**: 依赖 US1 完成（共享主题系统与基础布局）

---

## Parallel Opportunities

### User Story 1

- [ ] T009 与 T010 可并行（快照测试）
- [ ] T011、T012、T013 可并行（不同视图文件）

### User Story 2

- [ ] T014 与 T015 可并行（测试与实现）

### User Story 3

- [ ] T017 与 T018 可并行（快照与切换测试）
- [ ] T019 与 T020 可并行（布局与动效）

---

## Implementation Strategy

### MVP First（仅 User Story 1）

1. 完成 Phase 1 与 Phase 2
2. 完成 Phase 3 并通过快照测试
3. 暂停并验证：主页 → 状态选择

### Incremental Delivery

1. 完成 US1 并验证
2. 完成 US2 并验证卡片页
3. 完成 US3 并验证止损页与深色模式

### Parallel Team Strategy

- 主题系统完成后，US2 与 US3 可由不同成员并行推进
