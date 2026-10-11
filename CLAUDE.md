# 岭行 · Claude Code Game Studios

本仓库已迁入 [Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios) 骨架。  
**写码与制作主路径 = Claude Code（本目录开 `claude`）**。飞书/OpenClaw 只做观察与触发，不当主脑。

## Technology Stack

- **Engine**: Godot 4.x（建议 4.7）
- **Language**: GDScript
- **Version Control**: Git
- **Build / Export**: Godot Export（Android / iOS / HarmonyOS，见 `docs/导出说明-三端.md`）
- **Asset Pipeline**: `assets/` 像素图；`tools/make_art.py` 可再生

## Project Structure

游戏内容（保留）：

```
assets/     像素资源
scenes/     主场景与角色
scripts/    玩法脚本
store/      商店图标与截图占位
tools/      美术生成等工具
docs/       中文 MVP brief + CCGS engine-reference
design/     CCGS 设计注册表
production/ CCGS 制片/会话状态
.claude/    agents / skills / hooks / rules
```

目录约定详见：@.claude/docs/directory-structure.md

## Engine Version Reference

@docs/engine-reference/godot/VERSION.md

## Config

- `project.yaml` — 引擎/平台/modes（`rigor: minimal` + `automation: autonomous`）
- `project.local.yaml` — 本机覆盖（已 gitignore）

## Coordination Rules

@.claude/docs/coordination-rules.md

## Collaboration Protocol（本项目覆盖）

默认 **autonomous**：技能按 CCGS `modes.automation=autonomous` 少问多做。  
仍遵守：不擅自 `git commit`/`push`；删除文件与破坏性变更需确认（见 `automation_always_ask`）。

首次在本目录开会话后跑：`/start`（选「已有可玩原型 / adopt」类路径），再用：

- `/create-epics` → `/create-stories` → `/dev-story` → `/story-done`
- 视觉改动关闭前须跑游戏并留截图证据（`production/qa/evidence/`）

Godot 专员：`godot-specialist`（及 GDScript 子专员）。

## Coding Standards

@.claude/docs/coding-standards.md

## Session checkpoint

`production/session-state/active.md` — 崩溃或 `/clear` 后先读此文件。

## Legacy brief（迁入前飞书流水线产出）

以下仅作背景，**不要**再当作主流程：

- `docs/里程碑-MVP.md`
- `docs/任务分派-第一批.md`
- `docs/关卡设计-MVP.md`
- `docs/美术清单-MVP.md`
- `docs/导出说明-三端.md`
- `docs/测试用例-MVP.md`
- `docs/商店材料-MVP.md`

## OpenClaw / 飞书

只播报进度与阻断。写码请在本仓根目录：

```bash
cd E:/cw/Game-Godot
claude
# 然后 /start
```
