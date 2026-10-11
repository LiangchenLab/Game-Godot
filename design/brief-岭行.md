# 岭行 · One-page brief（CCGS 迁入用）

## 一句话

2D 横版跳跃：沿山路向右跑，跳过缺口和尖刺，躲开史莱姆，收集星星，走到红旗过关。

## 现状

- Godot 4.x 工程可 F5 通关一关
- 已有：移动/跳跃、检查点、尖刺、史莱姆、星星、红旗、触屏按钮、HUD
- 手感：`scripts/player.gd` 已含 Coyote 0.1s + Jump Buffer 0.1s
- 目标平台：Android / iOS / HarmonyOS

## MVP 范围

必须：一关闭环稳定、手感可接受、美术一致、三端可导出路径、商店材料草稿。  
不做：多关卡联网、内购、账号、复杂剧情。

## 下一刀（建议 `/create-stories`）

1. 关卡节奏：教学 → 加压 → 收尾（对照 `docs/关卡设计-MVP.md`）
2. 导出与包体可复现（对照 `docs/导出说明-三端.md`）
3. QA 按 `docs/测试用例-MVP.md` 留证据截图
4. 商店材料定稿（对照 `docs/商店材料-MVP.md`）
