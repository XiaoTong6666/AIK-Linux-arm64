# Android Image Kitchen for Linux arm64(aarch64)
在arm64平台解包android的boot.img

引用:
https://github.com/osm0sis/mkbootimg
https://github.com/ndrancs/AIK-Linux-x32-x64

构建BIN文件的工具:
- Termux(chroot-Ubuntu)
- Ubuntu clang version 18.1.3

食用环境:   
Device：Xiaomi_fuxi    
OS：Android 14(MIUI14)    
Kernel：Linux 5.15.78-android13    
ZeroTermux_0.118.1.41    
tsu -v:3.1.8:KernelSU    


用法
解包boot.img    
```
sudo ./unpackimg.sh boot.img
```

重新打包
```
sudo ./repackimg.sh
```
