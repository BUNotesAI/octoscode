# 记忆表(每条 FLAW 一行)

| FLAW | 结果 | 原因类 | 适用条件 | issue / PR |
|---|---|---|---|---|
| FLAW-001 | accepted | — | 围栏 peer 且 workspace 为 Cargo;仓库自带 .cargo/config.toml 时不覆盖 | octos #2236 / PR #2240 (e08c2715) |
| FLAW-002 | accepted | — | goal 终态集合 complete|archived;active/blocked/paused/budget_limited 仍拒绝 | octos #2237 / PR #2241 (17487501) |
| FLAW-003 | filed | 追加原语缺失+无兜底锁+无写入门禁 | macOS 无 flock 的多写者黑板 | — |
| FLAW-004 | filed | 采集面只覆盖机器信号,外环目视无定式入口 | 任何外环目视摩擦 | — |
