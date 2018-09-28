#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/platform/msm_sdcc.1/by-name/recovery:11300864:db863709ab1f041fa7c17e918dc136ce59668f7b; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/platform/msm_sdcc.1/by-name/boot:9291776:3b86f7d4c9a4a9a362e2e0c3da816837a2f5cb6a EMMC:/dev/block/platform/msm_sdcc.1/by-name/recovery db863709ab1f041fa7c17e918dc136ce59668f7b 11300864 3b86f7d4c9a4a9a362e2e0c3da816837a2f5cb6a:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
