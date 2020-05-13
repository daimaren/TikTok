跨平台c++代码，包括：
1. 引擎调度
2. 软件编解码
3. 视频特效，基于OpenGL ES实现
4. 音频特效
5. 基于晓凯的代码二次开发，调通预览录制功能。一个思路，直接复制晓凯的安卓代码，cpp代码移到外部来, cocos.a对应songstudio.a
6. 直接复制晓凯的ios代码，依赖外部的cpp代码
7. 把平台相关的cpp代码拆分为一个库
8. 再尝试一次在cpp-empty-test下面运行cmake命令，尝试修掉报错问题。ios-cmake命令本质上输入.cpp/.h/cmakelist.txt生成xcode项目，再用xcode工程运行编译出静态库。