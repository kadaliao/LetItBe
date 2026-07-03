# LetItBe 2.0 Release Notes

## zh-Hans

这次是一次大改版，核心目标：打开就被接住。

- 打开即卡片：不再需要三步操作，App 记住你上次的状态，启动直接给你一句话
- 顶部轻量状态切换：累 / 麻 / 躲 / 烦 随时一键切换
- 左右滑动换卡：带翻卡动效与触觉反馈
- 收藏功能「捡回来」：看到不想弄丢的句子，点卡片右上角书签
- 修复升级：呼吸支持 1 / 2 / 5 分钟，新增「小清单」（喝口水 / 洗把脸 / 开下窗）
- 呼吸引导加入触觉节奏，吸气呼气跟着手机的轻微震动走
- 桌面 / 锁屏小组件「每日一句」：一句低压力的话，安静地待在屏幕上
- Siri / 快捷指令：对 Siri 说「我想摆烂」，直接抽一张新卡
- 呼吸练习支持锁屏 / 灵动岛实时倒计时（Live Activity）
- 分享卡片：支持系统分享面板（微信 / 备忘录 / 隔空投送），也可存入相册
- 英文内容全量补齐：中英文各 800 张卡，1:1 对齐
- 外观跟随系统：深夜自动暗色，也可手动指定
- 新增「关于」页：边界与隐私说明
- 依旧本地优先：没有账号，没有上传，没有统计

## English

A major redesign. The goal: you're caught the moment you open it.

- Open straight to a card: the app remembers your last state — no more three-step flow
- Light state switcher on top: Tired / Numb / Hide / Annoyed, one tap away
- Swipe left or right for another card, with transitions and haptics
- Saved lines: bookmark a line you don't want to lose
- Repair upgraded: breathing in 1 / 2 / 5 minutes, plus a tiny list (sip water / rinse face / open a window)
- Breathing now guides you with a gentle haptic rhythm
- Home & Lock Screen widget: one quiet line, sitting on your screen
- Siri & Shortcuts: say "let me be" and get a fresh card
- Breathing sessions show a live countdown on the Lock Screen / Dynamic Island
- Share a card via the system share sheet, or save it to Photos
- Full English catalog: 800 cards in both languages, fully aligned
- Appearance follows the system, with manual override
- New About page: boundaries and privacy
- Still local-first: no accounts, no uploads, no analytics

## 技术变更 / Technical

- iOS 17+，@Observable + 语义化主题系统，支持动态字体
- 新增 LetItBeWidget extension（WidgetKit），App Group 共享偏好
- URL scheme `letitbe://card/<id>` 支持从小组件深链进入对应卡片
- App Intents（OpenCardIntent + App Shortcuts），中英文唤醒短语
- ActivityKit 呼吸 Live Activity（NSSupportsLiveActivities）
- 英文卡库 120 → 800，与中文逐 id 对齐；组合式内容按短语表统一翻译
- 单元测试 10 项、UI 测试 10 项全部通过
