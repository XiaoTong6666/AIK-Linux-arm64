# Android Image Kitchen for Linux arm64(aarch64)
在arm64平台解包android的boot.img

引用:
https://github.com/osm0sis/mkbootimg
https://github.com/ndrancs/AIK-Linux-x32-x64

构建BIN文件的工具:
- Termux(chroot-Ubuntu)
- Ubuntu clang version 18.1.3

测试由此AIK生成的new-boot.img的设备:    Xiaomi_capricorn

结果：能用

用法
解包boot.img
./unpackimg.sh boot.img

重新打包
./repackimg.sh
