# Story 001 · 关卡三段节奏

**Status:** done
**Epic:** mvp-playable
**Priority:** P0

## Intent

把现有一关改成清晰的「教学 → 加压 → 收尾」，新玩家 30 秒内懂跳/收星，中段加压，末段上台阶到旗。

## Acceptance

- [x] `_build()` 用注释标出 Act1 / Act2 / Act3
- [x] Act1：平地 + 星星引导；首个缺口前无尖刺/史莱姆
- [x] Act2：高度变化 + 移动平台 + 检查点 + 史莱姆 + 尖刺
- [x] Act3：阶梯平台 + 红旗；至少 2 颗收尾星
- [ ] F5 仍可从生点跑到旗；检查点仍可复活（待本机 Godot 手测）
- [x] `docs/关卡设计-MVP.md` 与实现一致（非占位）

## Files

- `scripts/level.gd`
- `docs/关卡设计-MVP.md`

## QA

手动：通关一遍；故意掉坑 → 检查点复活；截图留 `production/qa/evidence/story-001-*.png`（可后续 story-003 补）。
