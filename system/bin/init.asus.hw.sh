#!/system/bin/sh

#
# init.asus.hw.sh
#
# Initialize the hardware components and settings
#

PATH=/system/bin

LOG_TAG=`basename $0 .sh`

logi()
{
    log -t$LOG_TAG -pi "$@"
}

init_touch()
{
    reason=`getprop ro.boot.bootreason`

    if [ "$reason" != "kernel_panic" -a "$reason" != "watchdog" ]; then
        echo 1 > /sys/devices/f9927000.i2c/i2c-5/5-0046/updateflag
        echo 1 > /sys/devices/f9927000.i2c/i2c-5/5-0046/upgrade
        version=`cat /sys/devices/f9927000.i2c/i2c-5/5-0046/version`
        setprop asus.touch_version "$version"
        checksum=`cat /sys/devices/f9927000.i2c/i2c-5/5-0046/checksum`
        setprop asus.touch_checksum "$checksum"
        echo 0 > /sys/devices/f9927000.i2c/i2c-5/5-0046/updateflag
    fi
}

init_pni()
{
    # wait until the module is ready
    while [ ! -d /sys/module/sentral_iio ]; do sleep 1; done

    SENTRAL_A_A_CALI=/sys/class/sensorhub/sentral/smmi_acc_cali
    SENTRAL_A_A_CINI=/factory/sensors/accel_cal_hex.ini
    chown system.system /sys/class/sensorhub/sentral/iio/buffer/*
    [ -e $SENTRAL_A_A_CINI ] && cat $SENTRAL_A_A_CINI > $SENTRAL_A_A_CALI
}

init_sensors()
{
    case "`getprop ro.hardware`" in
        sparrow|wren)
            init_pni
            ;;
    esac
}

do_init()
{
    init_touch
    init_sensors
}

do_post_boot()
{
    init.asus.post_boot.sh
}

case "$1" in
    post_boot)
        do_post_boot
        ;;
    *)
        do_init
        ;;
esac
