# 数据模型：MVP 核心流程

**日期**：2026-01-17

## 实体与字段

### 状态（State）

- **id**: 唯一标识
- **key**: 规范化键值（tired/numb/hide/annoyed）
- **name**: 展示名称（如“累/麻/躲/烦”）
- **description**: 简短解释（可选）

**校验规则**：
- key 必须为固定集合之一
- name 非空

### 卡片（Card）

- **id**: 唯一标识
- **state_id**: 关联状态
- **title**: 标题
- **body**: 正文（多行短句）
- **footer**: 底部小字
- **tags**: 标签（可选）
- **action_type**: 行为类型（如“stop_loss”或“none”）
- **is_favorited**: 是否收藏（预留）

**校验规则**：
- title/body/footer 非空
- state_id 必须存在

### 止损会话（StopLossSession）

- **id**: 唯一标识
- **card_id**: 触发卡片
- **state_id**: 冗余状态（便于统计）
- **duration_seconds**: 计时长度（默认 120）
- **started_at**: 开始时间
- **ended_at**: 结束时间（可为空）
- **exit_reason**: 退出原因（completed/canceled）

**校验规则**：
- duration_seconds > 0
- started_at 必填
- ended_at 仅在完成/退出时写入

## 关系

- 一个状态对应多张卡片（State 1..N Card）
- 一个卡片可触发多个止损会话（Card 1..N StopLossSession）

## 状态流转

- StopLossSession: idle → running → completed/canceled

## 约束与备注

- 数据全部本地存储，默认内容来自 Bundle JSON。
- 不记录用户情绪、行为画像或可识别信息。
