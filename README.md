<img src="https://cdn.jsdelivr.net/npm/skx@0.1.3/img/uim-logo-round.png" alt="logo" width="130" height="130" align="left" />

<h1>SSPanel UIM</h1>

> Across the Great Wall we can reach every corner in the world

<br/>

[![License](https://img.shields.io/github/license/Anankke/SSPanel-Uim?style=flat-square)](https://github.com/Anankke/SSPanel-Uim/blob/dev/LICENSE)
![GitHub repo size](https://img.shields.io/github/repo-size/anankke/sspanel-uim?style=flat-square&color=328657)
[![Telegram Channel](https://img.shields.io/badge/news-t.me%2Fsspanel_uim-0d86d7?style=flat-square)](https://t.me/sspanel_uim)
[![Telegram Chat](https://img.shields.io/badge/chat-t.me%2Fssunion-0d86d7?style=flat-square)](https://t.me/ssunion)

[使用文档](https://wiki.sspanel.org) | [更新日志](https://github.com/Anankke/SSPanel-Uim/releases) | [配套SS/SSR后端](https://github.com/Anankke/shadowsocks-mod) | [Telegram 频道](https://t.me/sspanel_uim) | [Telegram 水群](https://t.me/ssunion) | [API 文档](https://marcosteam.gitbook.io/sspanel-api/)

## 简介

SSPanel UIM 是一款专为 Shadowsocks / ShadowsocksR / V2Ray / Trojan 设计的多用户管理面板，基于 ss-panel-v3-mod 开发。

###### 该项目为一键部署脚本，方便快捷部署。脚本开源无后门，欢迎star。
###### 脚本适配环境Ubuntu 18.04+/Debian 10+、内存1G+ 

###### 一键脚本：

```
git clone https://github.com/slobys/sspanels.git && cd sspanels && chmod +x sspanel.sh && ./sspanel.sh
```

###### 更多信息请访问：https://github.com/Anankke/SSPanel-Uim.git

## 特性

- 集成支付宝当面付，PAYJS，码支付，Paymentwall等超过 8 种支付系统
- 重构面板首页、节点列表、商品列表；新增 SPA（Single Page Apps）版 UI
- 商品增加同时连接设备数，用户限速属性
- 新用户注册现金奖励、用户常规端口切换与指定
- 公共库文件加载使用 jsDelivr
- 支持 V2Ray & Trojan
- 性能优化，程序逻辑改善，代码质量修正
- 更多新功能写不下了

## 安装

SSPanel UIM 的需要以下程序才能正常的安装和运行：

- Git
- MySQL
- PHP 7.2+
- Composer

SSPanel UIM 支持安装在 LNMP、宝塔面板、Plesk、Oneinstack 等集成环境中。安装教程请参阅 [文档](https://wiki.sspanel.org)。

## 演示

[演示站](https://demo.sspanel.org/) 每天更新 `dev` 分支最新源码。

```
账号：admin
密码：admin
mukey ShirakamiFubuki
```

## 文档

> 我们安装，我们更新，我们开发

[SSPanel UIM 的文档](https://wiki.sspanel.org)，在这里你可以找到大部分问题的解答。

## 贡献

[提出新想法 & 提交 Bug](https://github.com/Anankke/SSPanel-Uim/issues/new) | [改善文档 & 投稿](https://github.com/sspanel-uim/Wiki) | [Fork & Pull Request](https://github.com/Anankke/SSPanel-Uim/fork)

SSPanel UIM 欢迎各种贡献，包括但不限于改进，新功能，文档和代码改进，问题和错误报告。

## 协议

SSPanel UIM 使用 MIT License 开源、不提供任何担保。使用 SSPanel UIM 即表明，您知情并同意：

- 您在使用 SSPanel UIM 时，必须保留 Staff 页面（该页面包含了 MIT License）和页脚的 Staff 入口
- SSPanel UIM 不会对您的任何损失负责，包括但不限于服务中断、Kernel Panic、机器无法开机或正常使用、数据丢失或硬件损坏、原子弹爆炸、第三次世界大战、SCP 基金会无法阻止 SCP-3125 引发的全球 MK 级现实重构等
- UIM 原创软件图标、图像、SVG 矢量图形均不遵循以上协议，UIM 保留所有权利，您不可以将这些内容用于其他用途。


## 鸣谢

### [贡献者](https://github.com/Anankke/SSPanel-Uim/graphs/contributors)

SSPanel UIM 离不开所有 [贡献代码](https://github.com/Anankke/SSPanel-Uim/graphs/contributors) 和提交 Issue 的人。

<details>
<summary>查看贡献者</summary>

[**Anankke**](https://github.com/Anankke)

- 面板现 **维护者**

[**galaxychuck**](https://github.com/galaxychuck)

- 面板 **原作者**

[**dumplin**](https://github.com/dumplin233)

- 码支付对接 + 码支付当面付二合一
- 邀请链接
- 商品增加限速和限制 ip 属性
- 多端口订阅

[**RinSAMA**](https://github.com/mxihan)

- 整理分类 config.php
- 美观性调整

[**miku**](https://github.com/xcxnig)

- 美观和性能优化

[**Tony Zou**](https://github.com/ZJY2003)

- 为公告增加群发邮件功能
- 节点负载情况显示&用户账户过期在首页弹窗提醒
- 增加返利列表

[**Indexyz**](https://github.com/Indexyz)

- 为面板增加 V2Ray 功能

[**NeverBehave**](https://github.com/NeverBehave)

- 添加 Telegram OAuth

[**CGDF**](https://github.com/TheCGDF)

- 用户列表分页加载

[**laurieryayoi**](https://github.com/laurieryayoi)

- 重做美化UI（~~援交~~圆角化）
- 重写节点列表，支持分级显示所有级别节点

[**Sukka**](https://github.com/SukkaW)

- 单元测试
- 全站 JavaScript 重写
- 新版 Wiki 的搭建和维护

[**GeekQu**](https://github.com/GeekQu)

- 面板 Bug 修复与维护

[**M1Screw**](https://github.com/M1Screw)

- Wiki 维护与重写部分安装教程
- 面板 Bug 修复与维护
- 前端公共库版本更新

</details>

## 捐赠

您对我们的帮助将是支持我们做下去的动力。您可以直接进行捐赠，也可以在购买部分产品或向他人推荐产品时从我们的返利链接购买。

#### Anankke

- [Anankke 很可爱请给 Anankke 钱](https://t.me/anankke/7)

#### galaxychuck

- [Moecloud-美國VPS](https://lite.moe/aff.php?aff=56)

#### laurieryayoi

- [Dmit-美国香港服务器](https://www.dmit.io/aff.php?aff=912)

#### M1Screw

- [Vultr-不用我多解釋了吧](https://www.vultr.com/?ref=8941355-8H)

