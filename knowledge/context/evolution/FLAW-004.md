---
kind: context
id: FLAW-004
title: "harvest 无定式收外环目视摩擦:三源皆不覆盖,整场战役 6 项摩擦 0 卡"
repo: BUNotesAI/octoscode
layers: [Evolution]
status: filed
severity: S3
recurrence: 1
fingerprint: evolution/harvest-no-trigger-for-outer-loop-visual-friction
issue: ""
cards: []
filed: 2026-09-16
---

## 症状

domaindb 战役外环目视到 6 项摩擦(并发写互盖、评审员写完 fix 未发 herdr prompt、
goal 40.4M/30M 超预算仍完成、文档原有 7.0 引用行号假绿、哨兵子串误触发、外环
前台等待阻塞会话),harvest 三源皆不收:黑板只认 `改判`/`R2 记档`,事件流无对应
kind,MCP 信箱空——整场战役 6 项摩擦 0 卡。

## 责任步

`scripts/olp-evo-harvest.sh` 板面触发词表只含 `改判`/`R2 记档`;事件流 kind 枚举
无超预算完成类;外环目视无落卡定式,摩擦信息根本没有结构化入口。

## 根因

采集面只覆盖机器可产信号(改判、R2、事件流固定 kind、MCP 信箱),外环人眼
观察没有对应的定式行与 trigger;「外环看见的」这一最丰富摩擦源成了盲区。

## 修复

(未修,立案)方向:新增外环定式 `> 外环(<署名>)·摩擦记档(#N|-): <一句症状>`
作 harvest 第三种板面触发(trigger=`friction`),watch-board `--harvest` 同步
识别;事件流增加 `goal_budget_exceeded_but_completed`。

## 预防

harvest 契约测试加 friction 夹具(板面 `摩擦记档` 行必须产 trigger=friction 卡)。
