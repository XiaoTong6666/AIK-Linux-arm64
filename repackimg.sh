#!/bin/sh
# AIK-Linux/repackimg: repack ramdisk and build image
# osm0sis @ xda-developers

abort() { cd "$PWD"; echo "Error!"; }

args="$*";
bin="$PWD/bin";
chmod -R 755 "$bin" "$PWD"/*.sh;
chmod 644 "$bin/magic";
cd "$PWD";

if [ -z "$(ls split_img/* 2> /dev/null)" ]; then
  echo "No files found to be packed/built.";
  abort;
  return 1;
fi;

clear;
echo "\nAndroid Image Kitchen - RepackImg Script";
echo "by osm0sis @ xda-developers\n";

if [ ! -z "$(ls *-new.* 2> /dev/null)" ]; then
  echo "Warning: Overwriting existing files!\n";
fi;

rm -f ramdisk-new.cpio*;
case $args in
  --original)
    echo "Repacking with original ramdisk...";;
  *)
    if [ ! -d ramdisk ] || [ -z "$(ls ramdisk/* 2> /dev/null)" ]; then
      echo "No ramdisk found. Building kernel-only image...\n";
    else
      echo "Packing ramdisk...\n";
      ramdiskcomp=`cat split_img/*-ramdiskcomp`;
      echo "Using compression: $ramdiskcomp";
      repackcmd="$ramdiskcomp";
      compext=$ramdiskcomp;
      case $ramdiskcomp in
        gzip) compext=gz;;
        lzop) compext=lzo;;
        xz) repackcmd="xz -1 -Ccrc32";;
        lzma) repackcmd="xz -Flzma";;
        bzip2) compext=bz2;;
        lz4) repackcmd="$bin/lz4 -l stdin stdout";;
      esac;
      cd ramdisk;
      find . | cpio -o -H newc | $repackcmd > ../ramdisk-new.cpio.$compext;
      if [ $? -eq "1" ]; then
        abort;
        return 1;
      fi;
      cd ..;
    fi;;
  esac;

echo "\nGetting build information...\n";
cd split_img;
kernel=`ls *-kernel`;               echo "kernel = $kernel";
if [ "$args" = "--original" ]; then
  ramdisk=`ls *-ramdisk.cpio* 2>/dev/null`;
  if [ -n "$ramdisk" ]; then
    echo "ramdisk = $ramdisk";
    ramdisk="split_img/$ramdisk";
  else
    echo "ramdisk = (none - kernel only)";
    ramdisk="";
  fi;
elif [ -f "../ramdisk-new.cpio.$compext" ]; then
  ramdisk="ramdisk-new.cpio.$compext";
else
  echo "ramdisk = (none - kernel only)";
  ramdisk="";
fi;
cmdline=`cat *-cmdline 2>/dev/null || echo ""`;            echo "cmdline = $cmdline";
board=`cat *-board 2>/dev/null || echo ""`;                echo "board = $board";
base=`cat *-base 2>/dev/null || echo "0x00000000"`;        echo "base = $base";
pagesize=`cat *-pagesize 2>/dev/null || echo "4096"`;      echo "pagesize = $pagesize";
kerneloff=`cat *-kernel_offset 2>/dev/null || echo "0x00008000"`;    echo "kernel_offset = $kerneloff";
ramdiskoff=`cat *-ramdisk_offset 2>/dev/null || echo "0x01000000"`;      echo "ramdisk_offset = $ramdiskoff";
tagsoff=`cat *-tags_offset 2>/dev/null || echo "0x00000100"`;            echo "tags_offset = $tagsoff";
if [ -f *-second ]; then
  second=`ls *-second`;             echo "second = $second";  
  second="--second split_img/$second";
  secondoff=`cat *-second_offset`;      echo "second_offset = $secondoff";
  secondoff="--second_offset $secondoff";
fi;
if [ -f *-dtb ]; then
  dtb=`ls *-dtb`;                   echo "dtb = $dtb";
  dtb="--dt split_img/$dtb";
fi;
cd ..;
echo "\nBuilding image...\n"
if [ -n "$ramdisk" ]; then
  $bin/mkbootimg --kernel "split_img/$kernel" --ramdisk "$ramdisk" $second --cmdline "$cmdline" --board "$board" --base $base --pagesize $pagesize --kernel_offset $kerneloff --ramdisk_offset $ramdiskoff $secondoff --tags_offset $tagsoff $dtb -o image-new.img;
else
  $bin/mkbootimg --kernel "split_img/$kernel" $second --cmdline "$cmdline" --board "$board" --base $base --pagesize $pagesize --kernel_offset $kerneloff --tags_offset $tagsoff $dtb -o image-new.img;
fi;
if [ $? -eq "1" ]; then
  abort;
  return 1;
fi;

echo "Done!";
return 0;

