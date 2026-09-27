---
kind: context
id: FLAW-003
title: "黑板多写者读改写互盖:macOS 无 flock 下 ACK 追加退化为整文件读改写"
repo: BUNotesAI/octoscode
layers: [Board]
status: filed
severity: S2
recurrence: 3
fingerprint: board/multi-writer-read-modify-write-race
issue: ""
cards: []
filed: 2026-09-16
---

## 症状

2026-09-16 同一 `.octos/OUTER_LOOP_REVIEW.md` 两个 codex 窗格并发写,三次观测到
ACK 写入损坏:#8 的 ACK 被整文件读改写覆盖丢失一次;#3 的 ACK 被写到 #1 条目下
一次;#8 的 ACK 行前多出「v1 定式 」前缀一次(`^ACK\(` 语法失配,哨兵漏报)。

## 责任步

内环/评审员写 ACK:macOS 无 `flock`,`scripts/olp-board-append.sh` 在 `flock`
处失败后,写者退化为编辑器整文件读改写,丢原子性与落点;ACK 写入无语法校验,
失配行不拒写。

## 根因

追加原语缺失 + 无兜底锁 + 无写入门禁三者叠加:`flock` 不可用即失败,没有
`mkdir` 锁 / `shlock` 回落;写者随手改用整文件读改写,两写者并发即互盖;
`^ACK\((done|wontdo|blocked)\):` 语法不校验,坏行照落板。

## 修复

(未修,立案)方向:① `olp-board-append.sh` 在无 `flock` 时回落 `mkdir` 锁或
`shlock`;② 内环 ACK 写入走 `olp-ack-write`(原子追加 + v1 语法校验,失配拒写);
③ 上岗词明写「只追加,不整文件读改写」。

## 预防

契约测试 `olp_ack_lines_match_v1_grammar` 扩到 macOS 路径(无 flock 宿主)。
