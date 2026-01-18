---

description: "MVP 核心流程任务清单"
---

# Tasks: MVP 核心流程

**Input**: /Users/liaoxingyi/workspace/letitbe/specs/001-mvp-core-flow/
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/openapi.yaml, quickstart.md

**Tests**: 由于 TDD 要求，测试为必需项，且必须先写后实现。

**Organization**: 任务按用户故事组织，确保每个故事可独立实现与测试。

## Format: `[ID] [P?] [Story] Description`

- **[P]**: 可并行（不同文件、无依赖）
- **[Story]**: US1/US2/US3
- 每条任务必须包含具体文件路径

## Phase 1: Setup（共享基础）

**Purpose**: 初始化 iOS 工程与基础目录结构

- [x] T001 创建 iOS 工程与项目文件 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/LetItBeApp.xcodeproj
- [x] T002 [P] 建立工程目录结构 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/{App,Views,ViewModels,Models,Services,Persistence,Resources}
- [x] T003 [P] 添加应用入口 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/App/LetItBeApp.swift
- [x] T004 [P] 创建初始内容资源 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Resources/content.json

---

## Phase 2: Foundational（阻塞性基础能力）

**Purpose**: 所有用户故事共用的模型、数据与状态框架

- [x] T005 [P] 定义状态模型 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Models/State.swift
- [x] T006 [P] 定义卡片模型 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Models/Card.swift
- [x] T007 [P] 定义止损会话模型 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Models/StopLossSession.swift
- [x] T008 [P] 定义内容解析结构 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Models/ContentPayload.swift
- [x] T009 [P] 实现内容仓库（读取 Bundle JSON）/Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Services/ContentRepository.swift
- [x] T010 [P] 实现 SQLite 存储封装 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Persistence/SQLiteStore.swift
- [x] T011 [P] 实现止损会话仓库 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Services/StopLossRepository.swift
- [x] T012 定义全局导航与应用状态 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/ViewModels/AppState.swift

**Checkpoint**: 基础层就绪，用户故事可以开始并行实现

---

## Phase 3: User Story 1 - 快速到达卡片（P1）🎯 MVP

**Goal**: 从主页进入状态选择并展示卡片内容

**Independent Test**: 用户从主页进入状态选择，选择后看到卡片标题/正文/底部小字

### Tests for User Story 1（必须先写）

- [x] T013 [P] [US1] 编写内容仓库单元测试 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeTests/ContentRepositoryTests.swift
- [x] T014 [P] [US1] 编写主页到卡片的 UI 测试 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeUITests/HomeToCardFlowTests.swift

### Implementation for User Story 1

- [x] T015 [P] [US1] 实现主页视图 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Views/HomeView.swift
- [x] T016 [P] [US1] 实现状态选择视图 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Views/StatePickerView.swift
- [x] T017 [P] [US1] 实现卡片视图 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Views/CardView.swift
- [x] T018 [P] [US1] 实现状态选择 ViewModel /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/ViewModels/StatePickerViewModel.swift
- [x] T019 [P] [US1] 实现卡片 ViewModel /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/ViewModels/CardViewModel.swift
- [x] T020 [US1] 连接根路由与导航流 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/App/LetItBeApp.swift

**Checkpoint**: 用户可在 10 秒内到达卡片页

---

## Phase 4: User Story 2 - 使用止损动作（P2）

**Goal**: 从卡片启动止损计时并可安全退出

**Independent Test**: 用户可开始/结束止损计时并回到主页

### Tests for User Story 2（必须先写）

- [x] T021 [P] [US2] 编写止损服务单元测试 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeTests/StopLossServiceTests.swift
- [x] T022 [P] [US2] 编写止损流程 UI 测试 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeUITests/StopLossFlowTests.swift

### Implementation for User Story 2

- [x] T023 [P] [US2] 实现止损服务 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Services/StopLossService.swift
- [x] T024 [P] [US2] 实现止损视图 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Views/StopLossView.swift
- [x] T025 [P] [US2] 实现止损 ViewModel /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/ViewModels/StopLossViewModel.swift
- [x] T026 [US2] 接入卡片页止损入口与导航回主页 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Views/CardView.swift

**Checkpoint**: 止损计时可开始、可中途退出并安全返回主页

---

## Phase 5: User Story 3 - 浏览另一条卡片（P3）

**Goal**: 在同一状态内换一条卡片

**Independent Test**: 用户点击“换一条”后看到新卡片内容

### Tests for User Story 3（必须先写）

- [x] T027 [P] [US3] 编写换卡逻辑单元测试 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeTests/CardRotationTests.swift
- [x] T028 [P] [US3] 编写换一条 UI 测试 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeUITests/CardSwapTests.swift

### Implementation for User Story 3

- [x] T029 [US3] 实现卡片轮换逻辑 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Services/ContentRepository.swift
- [x] T030 [US3] 绑定“换一条”交互 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Views/CardView.swift

**Checkpoint**: 不离开当前状态即可切换卡片

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: 跨故事完善与可用性提升

- [x] T031 [P] 添加关键按钮无障碍标签 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Views/HomeView.swift
- [x] T032 [P] 添加关键按钮无障碍标签 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Views/StatePickerView.swift
- [x] T033 [P] 添加关键按钮无障碍标签 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Views/CardView.swift
- [x] T034 [P] 添加关键按钮无障碍标签 /Users/liaoxingyi/workspace/letitbe/ios/LetItBeApp/Views/StopLossView.swift
- [x] T035 [P] 更新冒烟验证说明 /Users/liaoxingyi/workspace/letitbe/specs/001-mvp-core-flow/quickstart.md

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: 无依赖，可立即开始
- **Foundational (Phase 2)**: 依赖 Setup 完成，阻塞所有用户故事
- **User Stories (Phase 3+)**: 依赖 Foundational 完成，可按优先级并行推进
- **Polish (Phase 6)**: 依赖各用户故事完成

### User Story Dependencies

- **US1 (P1)**: 无依赖
- **US2 (P2)**: 依赖 US1 完成（入口在卡片页）
- **US3 (P3)**: 依赖 US1 完成（入口在卡片页）

---

## Parallel Opportunities

### User Story 1

- T013 与 T014 可并行（单元测试与 UI 测试）
- T015、T016、T017、T018、T019 可并行（不同视图与 ViewModel 文件）

### User Story 2

- T021 与 T022 可并行（单元测试与 UI 测试）
- T023、T024、T025 可并行（服务与视图/VM）

### User Story 3

- T027 与 T028 可并行（单元测试与 UI 测试）

---

## Implementation Strategy

### MVP First（仅 User Story 1）

1. 完成 Phase 1 与 Phase 2
2. 完成 Phase 3 并通过测试
3. 暂停并验证：主页 → 状态选择 → 卡片

### Incremental Delivery

1. 完成 US1 并验证
2. 完成 US2 并验证止损流程
3. 完成 US3 并验证换卡体验

### Parallel Team Strategy

- 基础阶段完成后，US1/US2/US3 可由不同成员并行推进（按依赖关系约束）
