# BlossomAudio

## 设计

### 功能

- 经过开屏进入主页面
- 检验登录，没登陆的话登录-注册页面
- 已登录，主页可以看分类内容
- 搜索：按专辑名|用户名|（可以按词条搜吗，这样数据库查起来有点痛苦）
- 侧边栏：有退出，用户头像显示
- 右上角的设置：夜间模式

### 数据库

#### 需求分析

- 用户表

  - 有：昵称、注册邮箱、密码、

  - 增：注册
  - 删：注销账号
  - 查：登录时查找+按用户名搜索

- 用户的歌单表

- 每个歌单内容表


#### 表的设计

##### 用户-user

| 名       | 类型   | 备注     |
| -------- | ------ | -------- |
| 用户id   | int    | 主键     |
| 昵称     | string | 不能重复 |
| 注册邮箱 | string | 不能重复 |
| 密码     | string | 加密存储 |

##### 歌单-list

| 名     | 类型   | 备注           |
| ------ | ------ | -------------- |
| 歌单id | int    | 主键           |
| 用户id | int    | 和用户表相关联 |
| 名称   | string | 不可空         |
| 描述   | string | 可空           |

##### 单个歌曲-audio

| 名         | 类型                       | 备注         |
| ---------- | -------------------------- | ------------ |
| 歌曲id     | int                        | 主键         |
| 所在歌单id | int                        | 和list表关联 |
| 名称       | string                     | 不可空       |
| 内容       | 我不知道怎么存储短音频文件 | 不可控       |

#### cloudbase配置

**云开发推出了 Flutter SDK，在 iOS、Android 等移动应用平台中集成，可以方便使用云函数、云存储等能力。**，所以装Flutter吧。

我很讨厌这玩意，一直找不到可参考的文件，所以我来通读全文了。

cloudbase自带的云数据库支持：基础读写、聚合搜索、数据库事务、实时推送；

云存储可以支持音频；

云函数： 环境内自带云函数功能，可以函数的形式运行后端代码，支持SDK的调用或HTTP请求。云函数存储在云端，可以根据函数的使用情况，自动扩缩容；

HTTP 访问服务：云开发为开发者提供的 HTTP 访问服务，可通过 HTTP 访问云开发资源 



## 编写

### 创建与配置

#### 新建项目

在Android Studio里配置好flutter

创建Flutter Application Project，命名为`blossom_audio`

#### 配置CloudBase

参考：[腾讯cloudbase文档](https://cloud.tencent.com/document/product/876/51930)



### 开屏

#### 创建

[参考文档](https://flutter.dev/docs/development/ui/advanced/splash-screen)

#### 配置启动时显示

修改`AndroidManifest.xml`，将splashactivity对应的activity移动到mainactivity之前，并修改activity内部代码，最终如下

```xml
<activity android:name=".SplashActivity">
    <intent-filter>
        <action android:name="android.intent.action.MAIN" />

        <category android:name="android.intent.category.LAUNCHER" />
    </intent-filter>
</activity>
<activity android:name=".MainActivity"/>
```

#### 开屏页面

1. 基础

   设计一个简单的布局做开屏页面。

   在`SplashActivity.java`中

   ```java
   //需import android的handler类
   public class SplashActivity extends AppCompatActivity {
       //主进程句柄
       Handler mHandler=new Handler();
   
       @Override
       protected void onCreate(Bundle savedInstanceState) {
           super.onCreate(savedInstanceState);
           setContentView(R.layout.activity_splash);
   
           mHandler.postDelayed(new Runnable() {
               @Override
               public void run() {
                   Intent intent=new Intent(SplashActivity.this,MainActivity.class);
                   startActivity(intent);
               }
               //延迟时间
           },3000);
       }
   }
   ```

   可以实现打开应用后经过3秒由SplashActivity跳转到MainActivity。

   - [ ] 去掉顶部的标题

2. 实现跳转动画的设计

   - [ ] 以后再搞

### 登录/注册



### 主页















