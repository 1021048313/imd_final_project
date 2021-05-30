# FlowerAudio开发过程

- 开屏
- 主页的侧边栏
  - 侧边：注册/登录 打钱 隐私 评价 主页 （退出登录 设置？）
- 注册登录
- 

## 开始

因为想做有侧边栏的主页新建一个项目名为FlowerAudio的Navigation Drawer Activity，使用域名为zhon.fun，使用版本16（因为用的手机是19，没办法）

目前项目文件夹中有一个MainActivity

运行一下示例项目，侧边栏做了三个frame：home、gallery、slideshow。接下来就慢慢改。

## 开屏

### 创建

Andorid官方文档中的`SplashActivity`即为开屏。

在项目中新建一个`Empty Activity`命名为`SplashActivity`

### 配置启动时显示

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

### 开屏页面

新建一个名为`SplashActivity`的Empyt Activity

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

## 主页

对一开始的Navigation Drawer Activity文件构成的分析：

- layout/nav_header_main.xml侧边栏上方的用户简介
- menu/activity_main_drawer.xml是侧边栏的下半截（几种选项）
- menu/main.xml是页面右上角的设置（不过这里设置啥呢，小编也不清楚）
- navigation/mobile_navigation.xml是侧边栏选项对应的页面链接
- layout/以fragment命名开头的三个文件则分别对应点击各自的名称所出现的页面。

在values里增加值，需要的就是下面这几项

```xml
<string name="menu_home">主页</string>
<string name="menu_login">登录</string>
<string name="menu_assess">评价</string>
<string name="menu_privacy">隐私政策</string>
<string name="menu_donate">支持作者</string>
<string name="menu_setting">设置</string>
```

menu文件夹里的内容也进行相应修改，使内容匹配

```xml
<item
      android:id="@+id/nav_home"
      android:icon="@drawable/ic_menu_camera"
      android:title="@string/menu_home" />
```

如果要看空白模板以检查进度的话需要修改很多，本人写的时候为检查进度先进行了大改，但下面的设计部分是基于【没有修改】的理念而写的，可能有一些bug遗漏，请自行补全。

>  修改layout/中以fragment开头的文件和navigation/mobile_navigation.xml，最后应和侧边选项一致。
>
>  java代码中ui部分也需要修改，但我不知道怎么个性化所以 
>
> - [ ] 先用home的代替一下
>
> 因为我写的时候是保证能跑的，一边改一边理解结构，所以做了很多重复工作。
>
> 如果不改模板，按部就班地写各个内容也可以，就是没法即时看效果。<-我个人推荐这种

>  只要能跑就行，反正后面也要改。
>
> 跑起来的话，现在空白架子差不多搭起来了。

### 侧边栏

主页内容填充由home实现，这里是侧边栏的改进。

#### 左上角图标动画

使用[`ActionBarDrawerToggle`](https://developer.android.com/reference/android/support/v7/app/ActionBarDrawerToggle.html)

## 登录/注册功能

menu/activity_main_drawer.xml中加入对应的item

```xml
<item
      android:id="@+id/nav_login"
      android:icon="@drawable/ic_menu_login"
      android:title="@string/menu_login" />
```

navigation/mobile_navigation.xml中加入对应的fragment项：

```xml
<fragment
          android:id="@+id/nav_login"
          android:name="fun.zhon.floweraudio.ui.login.LoginFragment"
          android:label="@string/menu_login"
          tools:layout="@layout/fragment_login" />
```















