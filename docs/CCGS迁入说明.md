# CCGS 迁入说明（2026-10-11）

## 做了什么

1. 从 [Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios) 拷入：
   - `.claude/`（agents / skills / hooks / rules / scripts）
   - `design/`、`production/`
   - `docs/engine-reference` 与框架文档
2. 写入 `project.yaml`（Godot + `modes.rigor=minimal` + `modes.automation=autonomous`）
3. 写入根目录 `CLAUDE.md`（岭行栈与协议）
4. **未覆盖** `scenes/` `scripts/` `assets/` `store/` 与原有中文 `docs/*-MVP.md`

模板副本仍保留在 `E:/cw/Claude-Code-Game-Studios`（可删可留作升级对照）。

## 你怎么开干（主路径）

```bash
cd E:/cw/Game-Godot
claude
```

会话里：

1. `/start` — 选已有原型 / adopt  
2. `/create-epics` → `/create-stories`  
3. `/dev-story` 逐条做；视觉改动要跑游戏留截图  
4. `/story-done` / `/gate-check`

## OpenClaw

飞书多智能体降为观察层。写码以本目录 Claude Code 为准。
