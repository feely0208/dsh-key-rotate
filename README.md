# @deepwhale-cn/dsh-key-rotate

[![Listed on dsh-plugin.org](https://dsh-plugin.org/badges/listed.svg)](https://dsh-plugin.org/plugins/feely0208/dsh-key-rotate)


**关键词**：密钥轮换 · 密钥管理 · 证书轮换 · 证书过期 · 密钥过期 · 密码周期 · 密钥复用
**Keywords**: key rotation · secret rotation · certificate rotation · key management · cryptoperiod
**密钥轮换** —— 查密钥与证书多久没换了、有没有轮换制度、有没有跨环境复用。

## 不装它会怎样

你的 `id_rsa` 是两年前配的，一直没动。制度文档也许写了「密钥每年轮换」。

**但事实上它就是没换过。**

等保测评会问「鉴别信息多久更换一次」，客户尽调会问「密钥管理流程」——
你拿不出证据，因为**文件时间戳就摆在那里**。

## 它查什么

| 级别 | 内容 |
|---|---|
| 🔴 高 | 密钥/证书文件超过一年未更新（按 mtime）|
| 🟡 中 | 文档里找不到轮换策略 |
| 🟡 中 | 同一密钥在多个环境配置里被引用 |

## 为什么这是可判定的

```
密钥文件 mtime → 距今多少天 → 对比阈值（默认 365 天）
```

制度写在纸上，**时间戳不会说谎**。

## 安装

```bash
dsh plugin --profile web add @deepwhale-cn/dsh-key-rotate
# 或纯 CLI
npx @deepwhale-cn/dsh-key-rotate
```

## 用法

```bash
dsh-key-rotate --demo          # 看检出效果
dsh-key-rotate --list-rules    # 列出规则和依据
dsh-key-rotate --html r.html
```

![dsh-key-rotate 检查报告示例](https://www.deepwhale.org.cn/plugin-assets/dsh-key-rotate/report.png)

![dsh-key-rotate 演示模式输出](https://www.deepwhale.org.cn/plugin-assets/dsh-key-rotate/demo.png)

![dsh-key-rotate 规则与依据](https://www.deepwhale.org.cn/plugin-assets/dsh-key-rotate/rules.png)

## 边界

- **年龄 ≠ 未轮换** —— 密钥可能在 KMS 里，本地只是副本。报出来需你确认。
- **不解析证书内容** —— 不校验有效期、签发者、密钥长度。
- **跨环境复用只看 .env 类文件** —— KMS / CI secrets 看不到。
- 与 [dsh-bundle-cn-skills](https://github.com/feely0208/dsh-bundle-cn-skills) 分工：那个查「密钥有没有被提交」，这个查「多久没换」。

本插件是一个工具。使用者必须遵守所在地区法律法规，**对使用本项目造成的任何后果自行承担责任。**

---

## 深鲸网安守护系列（共 31 个）

> 一个插件做一件事。**安全问题是链式的** —— 配套用才完整。

**国内合规** ｜ [等保对照](https://github.com/feely0208/dsh-cn-mlps) · [日志留存](https://github.com/feely0208/dsh-cn-log-retention) · [备案公示](https://github.com/feely0208/dsh-cn-filing) · [用户同意](https://github.com/feely0208/dsh-consent-guard) · [个人信息权利](https://github.com/feely0208/dsh-data-rights) · [未成年人保护](https://github.com/feely0208/dsh-minor-guard) · [影响评估](https://github.com/feely0208/dsh-pipia) · [数据分类分级](https://github.com/feely0208/dsh-data-classify) · [算法备案](https://github.com/feely0208/dsh-algorithm-filing) · [数据出境](https://github.com/feely0208/dsh-cn-data-export) · [国密合规](https://github.com/feely0208/dsh-cn-crypto) · [AI 内容标识](https://github.com/feely0208/dsh-cn-ai-labeling)

**AI 与 Agent 治理** ｜ [AI 输出信任](https://github.com/feely0208/dsh-ai-output-trust) · [外部内容信任](https://github.com/feely0208/dsh-content-trust) · [MCP 安全](https://github.com/feely0208/dsh-mcp-audit) · [Agent 权限](https://github.com/feely0208/dsh-agent-scope) · [策略核对](https://github.com/feely0208/dsh-agent-policy) · [可疑指令](https://github.com/feely0208/dsh-phishing-guard)

**数据与凭据** ｜ [敏感数据](https://github.com/feely0208/dsh-data-scan) · [**密钥轮换**](https://github.com/feely0208/dsh-key-rotate) · [数据留存](https://github.com/feely0208/dsh-data-lifecycle) · [配置审计](https://github.com/feely0208/dsh-env-audit) · [密钥扫描](https://github.com/feely0208/dsh-secret-scan)

**供应链与构建** ｜ [开源许可](https://github.com/feely0208/dsh-license-guard) · [依赖投毒](https://github.com/feely0208/dsh-dep-audit) · [CI 安全](https://github.com/feely0208/dsh-ci-guard) · [工具审查](https://github.com/feely0208/dsh-tool-vet) · [物料清单](https://github.com/feely0208/dsh-sbom)

**权限与应急** ｜ [最小权限](https://github.com/feely0208/dsh-least-privilege) · [告警外发](https://github.com/feely0208/dsh-alert-relay) · [应急证据包](https://github.com/feely0208/dsh-incident-package)

都在 DSH 插件市场（dsh-plugin.org）、npm 和 deepwhale.org.cn/guard.html 上。
