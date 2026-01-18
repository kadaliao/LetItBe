# 研究记录：MVP 核心流程

**日期**：2026-01-17  
**目标**：确认技术与实现方向，确保离线、低摩擦、TDD 原则可落地。

## 决策 1：UI 框架

- **Decision**: SwiftUI
- **Rationale**: 与 iOS 平台匹配、开发效率高、适合轻量流程与动画过渡。
- **Alternatives considered**: UIKit（更细粒度控制但开发成本高）。

## 决策 2：架构模式

- **Decision**: MVVM（简单够用）
- **Rationale**: 视图与状态分离清晰，易于测试与维护。
- **Alternatives considered**: MVC（耦合偏高）、TCA（学习与配置成本偏高）。

## 决策 3：本地数据策略

- **Decision**: Bundle 内置 JSON 作为内容源 + SQLite 做本地持久化
- **Rationale**: 离线可用、无账号依赖、数据结构简单、可迭代更新内容包。
- **Alternatives considered**: CoreData（学习曲线更高）、Realm（引入额外依赖）。

## 决策 4：止损计时体验

- **Decision**: 前台计时器 + 引导提示
- **Rationale**: 轻量、可控、不依赖后台能力，符合“低成本止损”目标。
- **Alternatives considered**: 后台计时或通知提醒（复杂度高、需额外权限）。

## 决策 5：隐私与本地优先

- **Decision**: 不采集情绪/行为数据，功能全本地运行
- **Rationale**: 与产品定位一致，降低隐私风险与合规成本。
- **Alternatives considered**: 账号/云同步（违背最低摩擦与隐私原则）。
