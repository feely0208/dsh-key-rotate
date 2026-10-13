import { createPlugin, pkgRootFrom } from '@deepwhale-cn/dsh-guard-core/plugin';

export const { name, inject, apply } = createPlugin({
  name: 'key-rotate',
  pkgRoot: pkgRootFrom(import.meta.url),
  skillFile: 'skill/key-rotate.md',
  binFile: 'bin/cli.mjs',
  description: '查密钥与证书多久没换了、有没有轮换制度 —— 长期不换的密钥是最容易被忽略的风险',
  whenToUse: 'TODO：写清什么时候该用（用户会说的话也列上）',
});
