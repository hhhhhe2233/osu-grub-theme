# OSU! Grub Theme
OSU!的grub2主题

## 图像来源

[OSU!2023 年冬季同人作品大赛结果](https://osu.ppy.sh/home/news/2023-12-07-winter-fanart-contest-results)

## 安装

以主题osu为例

1. 下载并解压缩

2. 复制osu目录到grub themes
```shell
sudo cp -r osu /usr/share/grub/themes
```

3. 编辑文件grub
```shell
sudo vim /etc/default/grub
```

4. 将主题添加到文本文件的底部
```shell
GRUB_THEME="/usr/share/grub/themes/osu/theme.txt"
```
>通常情况下，建议加上此段规定grub渲染大小
```shell
GRUB_GFXMODE=1920x1080
```

5. 更新 grub
```shell
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

6. 重新启动计算机

## 其他方法
- bash执行 install.sh
- bing一下

##预览

![osu](/preview/osu.png)

## 对于 NixOS 用户
[请看这里](https://github.com/voidlhf/StarRailGrubThemes)

### 已知问题
- 字体渲染，在预览图中可见
