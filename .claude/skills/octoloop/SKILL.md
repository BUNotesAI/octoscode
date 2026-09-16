---
name: octoloop
description: OctoLoop 一键入口——一个 skill 上手双环全能力。三模式:init(引导铺设脚手架并核依赖)/outer(外环上岗:派单、观测、复验、代推)/inner(内环形态选型:octoscode 标准、免审批窗格、强档车道)
---

# /octoloop — 双环一键入口

OctoLoop = OLP(Outer-Loop Protocol,协议名)之上的产品化封装:用户装
这一个 skill 即可上手双环全能力。三个模式,先选身份再动手;权威规程
在仓库文档,**先读再动**,不要凭记忆操作。

## 模式 init — 铺脚手架(首次/新机器)

引导运行仓库的一键引导脚本,再核对依赖清单:

```bash
bash scripts/olp-init.sh          # 铺脚手架(黑板/信箱/监视器接线)
```

脚本按需询问(不假设环境);完成后逐项核对
`docs/OLP_QUICKSTART.md` §1 环境依赖清单(octos/octoscode 可执行、
herdr 或 tmux、外环模型 CLI)。herdr 来源与分支钉在 §1 依赖表
(hagency-org/herdr,octoscode 识别当前在 feat/octoscode-agent 分支)。任何缺口按 §6 故障速查处理,再跑
§5 冒烟验证(两分钟)。**全部发现式:本卡零硬编码路径**,一切以
QUICKSTART 的发现命令为准。

## 模式 outer — 外环上岗(强模型审查员)

收编自 /olp-outer(旧 skill 保留为薄转发)。上岗五步:

1. **读规程**:`docs/OLP_OUTER_BOOT.md`(操作面)+
   `docs/OUTER_LOOP_PROTOCOL.md`(ACK 定式/多外环规则/预算档)
2. **发现现场**:`herdr agent list` / `ls -t ~/.octos/instances/`,
   读各项目 `.octos/OUTER_LOOP_REVIEW.md` 尾部在途条目
3. **定主审域(多外环并存必做,机械判定不靠笔迹)**:主审权以
   per-project 值班簿+OS 独占锁双层判定——值班簿是**提示性目录**
   (记录署名/域/在途责任,供发现与会话猝死后按 duties 摘要重挂哨;
   `HELD` 只可署名批注,`STALE`/TTL 仅为健康告警,**不授予自动
   接管权——跨域接管须 operator 明示**);终局裁定 = outer-duty 锁
   (试锁见下步)。默认主审域 = 启动 cwd 项目;发现现场照旧全机
   扫描,但**发现 ≠ 接管**。
4. **接管职责(主审权锁,R7/olp-v2)**:上岗必须经
   `octoscode outer-duty hold --project <项目> --signature <署名>
   --duties <职责> -- <你的 agent 启动命令>` 包裹启动——锁即
   authority,**守护式死亡耦合**(wrapper 唯一持 fd;agent 经
   PR_SET_PDEATHSIG 与 wrapper 同死,wrapper 亡⇒agent 必亡⇒VACANT;
   Linux-only,非 Linux unsupported,Windows LockFileEx 另立);
   `outer-duty check` 仅观察、绝不夺取;非 holder 只读批注,活锁接管
   只归 operator(终止旧 holder 后再 acquire)。持锁后:署名落板(经
   `scripts/olp-board-append.sh`,flock 原子)→ 立编号条目唤醒内环 →
   内环 ACK 后**隔离 worktree 独立复验** → 采认代推。安全红线见
   BOOT §5。
5. **retro(进化环)**:①触发——战役收官,或进化黑板新卡 ≥ 10 张;
   ②命令——`scripts/olp-evo-harvest.sh <repo> &&
   scripts/olp-evo-retro.sh <repo>`(采集→简报,记录目录在
   `knowledge/context/evolution/`);③处置——每次最多推进 3 条记录;
   立案条件 hint ≥ 2 或主审目视跨 goal/跨条目复发,或 S1;issue 由
   operator 发布或明示委托;④authority——未持 outer-duty 锁只读简报
   不写记录;⑤采集哨只认带署名的行首定式
   `> 外环(<署名>)·改判(作废 #N):` /
   `> 外环(<署名>)·R2 记档(#N):`,纪律里的散文"R2 记档"不落卡。
   ⑥阶段 2/3 工具面(全部只读或只写自家状态目录):监视器
   `scripts/olp-watch-board.sh <板> <token> --harvest <repo>` 命中即采集并常驻
   (不带 `--harvest` 仍一击退出);`scripts/olp-evo-metrics.sh <repo>
   [--since EVO-NNNN] [--json] [--baseline <json>] [--stall <板>
   --stall-threshold <分钟> [--now <ISO>]]` 窗口化诊断(非 KPI:含
   `increase:/decrease:`、`stall:`、`fake_verified:`,不作红线);
   `scripts/olp-evo-spec-skeleton.sh <FLAW-NNN.md>` 从记录直出契约骨架到
   stdout(仓内只许写 `specs/drafts/`,主审补选择器后才入 `specs/`);
   `scripts/olp-evo-index.sh <repo>` 生成 `knowledge/context/evolution/INDEX.md`;
   回放基线 `fixtures/evolution/replay/`(合成夹具,实现 commit 不得改)。

## 模式 inner — 内环形态选型(执行侧)

内环契约 agent 无关(BOOT §6);按任务形态选:

| 形态 | 适用 | 关键点 |
|---|---|---|
| **octoscode 标准** | 仓库内编码主路径 | octos serve stdio 挂载,全工具面 + MCP 第五信道(ask_outer/report_blocked) |
| **claude / codex 免审批窗格** | 快轨修订、外环同级复审 | herdr 窗格隔离,绕内环审批链;分支纪律照旧 |
| **强档车道** | 大型战役/多 peer 并行 | profile `config.llm.primary`/`fallbacks` 多模型 lane(QUICKSTART §3),sub_providers 供 pipeline 按节点选档 |

任何形态都要:黑板 ACK 定式、R4/R4b 工作区共存与树主权、
R2 诚实验证声明(verified/partially/unverified)。

## 自主性纪律(实战沉淀:一次全链演练暴露的六类断点)

外环的价值在**全程自主闭环**;下面每条都对应一次真实掉链、由
operator 点破的教训。上岗即遵守,不要重蹈:

1. **派出五步闭环:派出→侦听→收割→处置→回执,缺一不闭环。**
   任何 agent 派出(内环唤醒 / codex 窗格 / 后台任务)的**同一批次**
   内挂完成哨;复验/判词落板后必须**回执内环**(herdr prompt)——
   黑板是拉模型,master 只在开轮时读板,不回执 = 内环视角外环失联。
   **侦听必须双哨**:正信号哨(ACK 落板)+ 负信号哨(events.jsonl 的
   goal_transition blocked / escalation)——只盯正信号时,goal 熔断的
   沉默与"还在干活"不可区分(实案:夜间断供熔断 8 小时无人知)。
   哨死(超时被回收)会收到失败通知,收到即重挂。
2. **侦听哨唯一合法配方:基线+子串,禁止手搓格式匹配**。板面哨一律
   发行版 `scripts/olp-watch-board.sh`(`olp-init.sh` 安装为
   `~/.octos/outer/watch-board.sh`)`<板> <token> [--skip-signature <署名>]`(基线行数裁剪
   判定域,只看挂哨后新增行;域内 `grep -F` 宽松匹配,任何前缀格式一视同仁;
   外环自己的批注若引用 token 会误报——先落板后挂哨,或用 `--skip-signature` 排除本署名)。
   实案四起同一病灶——谓词作用于全文件+猜格式:三次误报(任务书自述/
   引用文字/历史同号 ACK),一次漏报(`### ` 前缀没猜到,哨空转数小时
   致复验迟到);非板面哨锚定唯一新信号:行号基线+署名、产物文件
   存在、agent 状态转 idle,**严禁数子串**。
3. **上岗先做权限预检**:把本轮可预期的高频操作(herdr CLI、octos
   CLI、git push 到 fork)预先配入 harness 允许清单,别撞墙后摆命令
   等人。两类永远留给 operator 亲手:免沙箱启动、agent 修改自己的
   权限配置(自我提权,harness 会拦且应该拦)。
4. **窗格纪律**:开窗格用 `split --cwd` 指定工作目录,**勿靠命令串里
   的 cd**(实案:三连启动错实例);窗格复用优先、少开关(churn 会
   让 operator 的附着画面乱跳);一次性任务用 `codex exec` 收工即关,
   常驻实例才留窗格。
5. **goal 卫生**:冷派单前查目标会话残留 goal(`octos goal list` /
   pane read);收口正解是**会话内 /goal stop**;serve 存活时离线
   `octos goal archive` 会被 live cache 后写反盖(上游修复前勿依赖);
   goal 用完必须收口到终态,不留 active 残留。
6. **双签终审**:切片级以上交付,推荐第二外环(异厂牌)对抗终审
   ——"验收的验收"。实案:单外环两轮复验漏掉"唯一事实源"级机制
   错误,对抗复审一轮抓出五 BLOCKER。验收条款尽量写成**可 grep 的
   断言**,复验逐字重跑;ACK 里的概括性声明("占位全回填")必须
   逐项自查后才落笔——被证伪即 R2 记档。**安全/基建类任务蓝本先行**:
   先让第二外环出对抗过的设计蓝本再开工,实测轮次差 2 vs 8(有蓝本的
   goal 竞争修复两轮收官;实现先行的 duty 锁八轮会签、两次核心设计
   易稿——fd 继承与公开 seam 都是"实现了才被审出"的方向错误)。
7. **重启硬清单——兜底瘫痪是隐形的,必须显式巡检**。内环(重)启动
   后外环逐项核对,禁止"记一笔稍后补":①serve 起(operator 亲手,
   免沙箱);②**`/loop resume` 外环必代**——先 `/loop list` 取 id 再
   `/loop resume <id>`(裸 resume 要 id 会拒);③双哨挂载(正 ACK +
   负 goal_transition);④fallbacks 已配且**新会话已快照**(改配置
   不重启=纸面保险)。原则:主机制健康时,兜底层瘫痪完全不可见
   (实案:paused 一整天无人察觉,直至三层同失才暴露,8 小时停摆)。
   **兜底的健康只能靠巡检,不能靠事故。**清单详见 BOOT §0b。
   附则(自查面选错实案):清单每步必须**绑定权威探查面**,内环自检
   不得自选替代面——实案:自检报"无 paused 循环"(翻的是数据目录),
   而 TUI 状态栏明示 1 paused;loop 状态的权威面是会话内 `/loop list`,
   不是磁盘文件。外环收自检报告时**以独立面对账**(读屏核状态栏),
   声明与状态栏矛盾即打回重查——这是"声明-对象一致性"纪律的运行时
   版本:测试对 git 对象,自检对权威状态面。

## Claude Code 外环适配(上岗前置四步,做完才准派单)

本卡的规程假设外环能把哨兵放到后台、能拿到 serve;Claude Code 作外环时这些
前提要**自己补齐**,补不齐就一句话交给 operator 停下,**禁止换一种"等价"做法**
(实案 2026-09-16:serve 未起就自换 codex 窗格、前台 `herdr agent wait` 阻塞
会话 10 分钟一轮、手搓 `^ACK\(` 匹配替代发行版哨兵——三个替代没有一个等价:
丢了原子 ACK 写入、丢了对话、丢了误报免疫)。

1. **能力预检**:`ToolSearch("select:Monitor,TaskStop")` 加载后台监视与停止
   工具;没有它们就没有后台哨兵,不得开工。herdr 从会话外驱动时只用显式
   pane id / agent 名,先 `herdr agent rename <pane> <名>`,永不打 focused pane。
2. **内环只认 octoscode 标准形态**:`herdr agent list` 里没有 `octoscode` 窗格
   就把启动命令渲染给 operator——
   `cd <repo> && octoscode --stdio-command 'octos serve --stdio --solo --danger-full-access'`
   ——然后**停在这一步等**;不得用 codex / claude 窗格顶替(那是 BOOT §6 里
   operator 明示选择的快轨形态,不是缺 serve 时的兜底)。
3. **派出同批次挂双哨,全部走 `Monitor`,全部后台**:
   ```
   # 正哨:发行版脚本,基线裁剪 + 子串,命中一击退出后重挂
   Monitor(command: "~/.octos/outer/watch-board.sh <板> 'ACK(' --skip-signature '外环(<署名>)' --interval 10",
           timeout_ms: 1800000)
   # 负哨:实例事件流(实例 = ls -t ~/.octos/instances | head -1 对号)
   Monitor(command: "tail -n 0 -F <实例>/profiles/<档>/data/events.jsonl | grep -E --line-buffered 'goal_transition|escalation|blocked|budget_limited|awaiting_input|peer/(staged|closed)|ERROR'",
           timeout_ms: 1800000)
   ```
   禁止 `herdr agent wait` / `agent prompt --wait` 带长超时、禁止 `sleep` 轮询:
   前台等待 = 外环失去对话,operator 的消息全部排队。30 分钟到期通知即重挂。
4. **macOS 无 `flock`**:`olp-board-append.sh` 会在 `flock` 处失败,外环写板改用
   `cat >> <板> <<'EOF'` 追加;给内环的上岗词里明写"ACK 用追加写,不整文件读改写"
   (两写者读改写曾互相盖掉 ACK)。

## 内环终审回路:内环自审自修,外环只收终审

内环自带一个只读终审员,评审→打回→修订→复审在内环闭环,外环不介入中间轮次。
双方互相唤醒直接走**上岗时选定的通道**,不写任何外环侧 supervisor 脚本
(实案:脚本版上线十分钟即被 operator 指出多余)。

**上岗三问(外环在派单前用 AskUserQuestion 或等价方式问 operator,
答案写进黑板 Active 区主审说明与 `.octos/loop.md`)**
1. 审查 agent 用哪个?候选:codex / claude / gemini / 另一 octoscode 实例 /
   不设内环终审。**默认推荐与执行者异厂牌**(operator 可改)。
2. 唤醒通道用哪条?候选:`herdr agent prompt`(双方都在 herdr 窗格时默认)/
   tmux `send-keys`(走 harness-agent-tmux-transport)/ `octos steer`
   (目标是 octoscode 会话时)/ 仅黑板拉模型不推送。
3. 审查粒度?候选:每条目 ACK 即审 / 每 goal 收官审 / 仅终审。

**角色与窗格**
- master:octoscode 标准形态窗格(`<master 窗格>`),按 `.octos/loop.md` 吃单。
- 终审员:同工作区一个 `<review 窗格>`,由 `<审查 agent>` 扮演(问 ① 定),
  **只读**——不改工作区、不 commit、不 checkout、不写数字编号条目;
  只在黑板末尾追加署名行,署名定式 `内环审(<审查 agent>)`。
- 外环:启用内环终审时,只把**正信号 ACK 哨替换为终审哨**(`watch-board.sh <板> '终审'`);
  events 负哨及 30 分钟到期重挂**继续保留**——终审哨收不到 goal blocked/escalation,
  撤掉负哨 = 外环失察(见「Claude Code 外环适配」§3 与负信号保障)。① 选
  「不设内环终审」时不替换,维持原 ACK 正哨 + events 负哨双哨不变。
- ① 选「不设内环终审」时:本节整体跳过——没有 `<review 窗格>`、没有唤醒链、
  没有内环终审信号;每条目 ACK 后直接交外环复验(纪律 3 的外环独立复验
  是唯一验收层)。

**黑板定式(行首逐字,全部追加写,不整文件读改写)**
- 终审员:`> 内环审(<agent>)·REVIEW(pass #n, 绑定 <full sha>): 核 N 处锚点、M 条断言,零 finding。`
- 终审员:`> 内环审(<agent>)·REVIEW(fix #n, 绑定 <full sha>): F1 <文件:行> <证据> → <改法>;F2 …`
  (BLOCKER / MAJOR 才 fix;MINOR 写在 pass 行末尾作备注)
- master 修订后:`ACK(done): #n 修订 r<k>;commit <hash>;F1 → …`
- 终审员收官:`> 内环审(<agent>)·终审 READY(绑定 <full sha>): …` / `终审 FIX-FIRST(绑定 <sha>): F1 …`

**唤醒链(写进两侧的常驻指令,按 ② 选定的通道、按 ③ 选定的粒度触发)**
- `.octos/loop.md` 追加一条:**当 ③ 选「每条目 ACK 即审」时**,每条目 ACK 追加后
  立刻用 `<唤醒命令>` 唤 `<review 窗格>`:`请审 #<n>:ACK 已追加,commit <hash>`;
  ③ 选「每 goal 收官审」时,不逐条唤——等 goal 收官再唤一次整批审;
  ③ 选「仅终审」时,条目 ACK 后不唤审;但**终审范围就绪**(goal 收官、
  该终审覆盖的全部条目均已 ACK)时,master 必须经 ② 选定的推送通道主动
  唤醒终审员**一次**,告知终审范围与最新 commit SHA——审查员 idle 时不会
  自行行动,不唤醒 = 永远等不到终审。
  ② 选「仅黑板拉模型不推送」时,不存在 `<唤醒命令>`:终审员自己按哨/间隔
  读板发现新 ACK 与收官信号(fix→复审、终审同理,读板驱动),任何一侧都
  不执行推送命令——含「仅终审」粒度下的收官唤醒,也由读板代替。
  板末出现 `REVIEW(fix #n)` 或 `终审 FIX-FIRST(绑定 <sha>)` 且其后无对应的
  新 `ACK(` 行 → 视该条目/该终审范围未完成,
  按 findings 修复、追加新 ACK、按选定通道/读板机制再触发复审;`REVIEW(pass)` 不回应;
  评审意见只接受或在 ACK 写异议,不打回。
  通道示例(按 ② 选择其一):
  - herdr:`herdr agent prompt <review 窗格> "请审 #<n>:ACK 已追加,commit <hash>"`
  - tmux:`tmux send-keys -t <review 窗格> "请审 #<n>…" Enter`
  - steer:`octos steer <octoscode 会话> "请审 #<n>…"`
- 终审员协议文件(项目 `review/` 下一份,首条 prompt 让它通读):写完 `REVIEW(fix)`
  立刻用选定通道唤醒 `<master 窗格>`:
  `已追加 REVIEW(fix #n),按 loop.md 修复后追加新 ACK 并唤醒我复审`
  (② 为仅黑板模式时不唤醒,等读板);写完 `终审 FIX-FIRST(绑定 <sha>)` 同样
  **必须**经 ② 选定的推送通道实际唤醒 master,消息绑定终审范围与 SHA
  (仅黑板模式由读板触发),让 FIX-FIRST 进入与 REVIEW(fix) 同一条修订链:
  master 按终审 findings 修复 → 板末追加 `ACK(done): 修订 r<k>;commit <hash>` →
  审查员复审并**重发绑定新 SHA 的终审结论**(READY 或新一轮 FIX-FIRST),
  直到终审 READY;终审前置**按 ③**:逐条粒度要求
  全部条目最新 ACK 均已 pass;收官/仅终审粒度只要求 goal 已收官、条目均有 ACK,
  pass 不是前置——满足即不等任何人直接做整分支终审;
  每轮写完黑板就结束本 turn,不在 turn 里长轮询。
- 修订轮只核 findings 闭合与新坐标,不重复全审。

**四条纪律**
1. 终审员绑定 commit SHA(从 ACK 取),第一动作 `git show <sha> --stat` 核只含任务书文件。
2. 终审员与执行者**默认异厂牌**(operator 可改),`<审查 agent>` 的选择要体现这一点
   ——同厂牌自审自己时,operator 必须显式改默认。"验收的验收"才有对抗性。
3. 外环收到 `终审 READY` 后仍要做一次独立复验再代推——内环闭环不豁免 §4。
4. 两窗格同写黑板只许追加(macOS 无 flock);读改写曾互相盖掉 ACK。

## 能力清单(全景一页)

见 `docs/OCTOLOOP_FEATURES.md` —— 断供降级、孤儿回收、malformed
自纠、预算 checkpoint、断拍自续、写策略三档、纯 Rust MCP 第五信道、
startup --prompt 等逐条:是什么 + 缺省状态 + 用户怎么看到效果。
