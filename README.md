# Android Image Kitchen for Linux arm64(aarch64)
在arm64平台解包android的boot.img

引用:
https://github.com/osm0sis/mkbootimg
https://github.com/ndrancs/AIK-Linux-x32-x64

构建BIN文件的工具:
- Termux(chroot-Ubuntu)
- Ubuntu clang version 18.1.3

食用boot.img的环境:   
Xiaomi_capricorn    
Android_11(LineageOS_18.1)    
ZeroTermux_0.118.1.41    
tsu_R6687BB53-kitsune:MAGISKSU    

用法
解包boot.img    
```
sudo ./unpackimg.sh boot.img
```

重新打包
```
sudo ./repackimg.sh
```
