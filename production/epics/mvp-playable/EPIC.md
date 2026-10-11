# Epic: MVP 可玩闭环

**Slug:** `mvp-playable`
**Status:** active
**Layer:** foundation
**Brief:** `design/brief-岭行.md`

## Goal

一关闭环稳定、手感可接受、美术一致、三端导出路径可复现、商店材料可投稿。不做多关卡联网/内购/账号。

## Stories

| # | File | Title | Status |
|---|------|-------|--------|
| 001 | `story-001-level-cadence.md` | 关卡三段节奏 | done |
| 002 | `story-002-export-repro.md` | 三端导出可复现 | ready |
| 003 | `story-003-qa-evidence.md` | QA 证据截图 | ready |
| 004 | `story-004-store-materials.md` | 商店材料定稿 | ready |

## Governing notes

- 关卡在 `scripts/level.gd` `_build()` 代码拼装（非 TileMap）
- 手感基准：Coyote 0.1s + Jump Buffer 0.1s（`scripts/player.gd`）
- 证据目录：`production/qa/evidence/`
