# DDE Gesture Manager

![logo](https://github.com/debuggerx01/dde_gesture_manager/blob/master/app/web/icons/Icon-192.png?raw=true)

专为 [DDE](https://www.deepin.org/zh/dde/) 桌面环境打造的触摸板手势管理工具（缩写：dgm），客户端使用 [Flutter](https://flutter.dev/) 构建，后端技术栈为 [dart](https://dart.dev/) 的 [Angel3 框架](https://github.com/dukefirehawk/angel) + [PostgreSQL](https://www.postgresql.org/) + [Redis](https://redis.io/) + docker。

# DEMO

[DDE手势管理器-web版](http://www.debuggerx.com/dgm_web/#/)

# 功能
- 创建、编辑、删除本地手势配置方案
- 将选定手势方案应用到系统中
- 注册登陆后可以上传、分享自己创建的配置方案
- 可以下载、点赞他人分享的配置方案
- 贴合 DDE 的 UI 设计风格，支持系统主题切换和活动色
- 支持多语言

# 运行

## api

- 使用docker(推荐)

  首先安装 docker 及 docker-compose，然后在`/api`目录下执行：

    ```shell
    bash start.sh
    ```

- 手动运行
    1. 首先配置 dart 环境（如果已经配置 flutter 开发环境则无需再配置）：
       [Dart SDK overview](https://dart.dev/tools/sdk)
       
    2. 安装项目依赖，运行代码生成命令：
       在`/api`目录下执行：
       ```shell
        bash source_gen.sh
       ```
       
    3. 安装 PostgreSQL 及 Redis
        - [PostgreSQL Downloads](https://www.postgresql.org/download/)
        - [Redis Downloads](https://redis.io/download)
    
        然后在 `/config/development.yaml` 设置如下配置：
        ```yaml
        # Development-only server configuration.
        debug: true
        postgres:
          host: [db host]
          port: 5432
          database_name: gesture_manager
          username: postgres
          password: [db password]
          use_ssl: false
          time_zone: Asia/Shanghai
        redis:
          host: [redis host]
          port: 6379
          password: [redis password]
        smtp:
          username: [smtp account name]
          password: [smtp account password]
          host: [smtp server host]
        ```
        
    4. 设置数据库
        - 登录数据库，创建名为 `gesture_manager` 的数据库
          
            ```sql
            create database gesture_manager;
            ```
            
        - 运行 Migration：
        
            ```bash
            dart bin/migrate.dart
            ```
    5. 运行 api
        ```bash
        dart bin/dev.dart
        ```

## app

1. 配置 flutter 开发环境，并启用 Linux 支持：
    - [Linux install](https://docs.flutter.dev/get-started/install/linux)
    - [Additional Linux requirements](https://docs.flutter.dev/get-started/install/linux#additional-linux-requirements)

2. 修改服务器连接地址
    在 `/api` 目录下修改 `lib/apis.dart`:
   ```dart
   class Apis {
     static const apiScheme = 'http';
     static const apiHost = 'localhost';  // 设置为api的地址
     static const apiPort = 3000;         // 设置为api监听的端口
    
     static const appNewVersionUrl = 'https://www.debuggerx.com';
    
     ……
   }
   ```
   
3. 安装项目依赖，运行代码生成命令：
   在`/app`目录下执行：
   ```shell
   bash source_gen.sh
   ```
   
4. 运行app项目：
    - Linux：
    ```shell
   flutter run -d linux
   ```
   
    - web:
    ```shell
   flutter run -d chrome
    ```



# RoadMap


- [ ] 方案下载功能实现
- [ ] 方案应用功能实现
- [ ] BugFix
- [ ] MD 编辑器中的UI文本国际化
- [ ] 编写帮助说明文档
- [ ] 浅色模式界面优化
- [ ] 打包上架 Deepin/UOS 应用商店


# FAQ

- Q：为什么要开发这个工具
    
    A：本人是 [Deepin Linux](https://www.deepin.org/zh/) 的老粉了，日常学习工作和生活娱乐几乎完全在 Deepin/UOS 系统下进行。同时我还是个手势重度依赖者，除了鼠标手势，对笔记本的触摸板手势一样有很强的自定义需求。但是从 Deepin 系统增加手势功能到如今也有5年多了，官方一直没有在系统层面给出自定义触摸板手势的功能入口，我不得不经常通过手工修改系统手势配置文件的方式来实现自定义。但是长久以来，一方面是自己每次新装系统都需要重新设置，一方面是不断看到论坛和用户群有朋友反馈询问修改方法，遂决定动手写一个方便使用，并支持配置分享下载的GUI工具
    
- Q：为什么使用 flutter 开发而不是 Qt/DTK/GTK ……

    A：因为本人对 flutter 比较熟悉，有4年多的研究积累，而且对于 flutter 的跨平台效果非常看好，而C/C++的经验相对缺乏，又恰逢2021下半年这个时间点，google官方的一大重点就是对桌面应用开发的支持，于是决定尝试通过使用 flutter 实现本工具。

- Q：为何还要兼容开发Web版本

    A：得益于 flutter 的跨平台能力，在开发 Linux 桌面版应用的基础上，可以以很低的成本同步开发出 Web 版，于是一方面出于技术探索的目的，从一开始的功能规划我就将 Web 支持放在了基础需求中。另外，Web 版还有三个明显的好处：

    1.  用户可以不必安装桌面应用，仅仅通过浏览器打开网页就能体验本工具的功能，方便了用户预览体验，也方便本项目的转发推广；
    2. 由于 UOS 系统默认是锁 root 权限的，某些情况下的用户（比如机关单位的普通员工）可能不方便安装运行第三方软件，虽然我有将本工具上架 UOS 软件商店的打算，但是并不一定能够保证及时更新，所以此时可以通过使用 Web 版来实现和桌面版相同的功能和接近的体验；
    3. 还有一部分用户可能使用的是国产CPU，可能并不是 flutter 的编译工具所支持的，或者虽然 flutter 支持，但是由于我没有对应的机器进项编译打包，所以可能暂时无法为这些用户提供二进制的程序使用，此时这些用户一样可以通过使用 Web 版来解决。

- Q：为何使用 dart 编写服务端，而不用其他更流行常见的语言和技术

  A：作为全栈开发，虽然有多种其他语言和流行框架的后端开发经验，但是那些方案，有些是框架本身太重太吃资源，不适合这个小项目使用，有些是语言本身实在是写烦了，开发起来没有动力……在看到一些朋友和大佬分享使用 dart 开发后端的经验之后，我想，是不是可以让前后端项目使用相同的语言，以"同构"的方式开发，并将前后端的一些"弱关联"转变成由语法来保证正确性的"强依赖"呢？
  
  所以在这个项目中，我让`api`直接作为`app`的依赖，`app`的网络请求处理中直接使用`api`侧导出的请求参数定义和结果模型，探索一种可以不用再通过文档进行前后端配合的开发模式——因为我相信，文档总是不可靠的，只有代码本身不会骗人 :joy:
