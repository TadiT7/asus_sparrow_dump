#!/system/bin/sh

PATH=/system/bin

cd /sys
echo 4 > module/lpm_levels/enable_low_power/l2
echo 1 > module/msm_pm/modes/cpu0/power_collapse/suspend_enabled
echo 1 > module/msm_pm/modes/cpu1/power_collapse/suspend_enabled
echo 1 > module/msm_pm/modes/cpu2/power_collapse/suspend_enabled
echo 1 > module/msm_pm/modes/cpu3/power_collapse/suspend_enabled
echo 1 > module/msm_pm/modes/cpu0/standalone_power_collapse/suspend_enabled
echo 1 > module/msm_pm/modes/cpu1/standalone_power_collapse/suspend_enabled
echo 1 > module/msm_pm/modes/cpu2/standalone_power_collapse/suspend_enabled
echo 1 > module/msm_pm/modes/cpu3/standalone_power_collapse/suspend_enabled
echo 1 > module/msm_pm/modes/cpu0/standalone_power_collapse/idle_enabled
echo 1 > module/msm_pm/modes/cpu1/standalone_power_collapse/idle_enabled
echo 1 > module/msm_pm/modes/cpu2/standalone_power_collapse/idle_enabled
echo 1 > module/msm_pm/modes/cpu3/standalone_power_collapse/idle_enabled
echo 1 > module/msm_pm/modes/cpu0/power_collapse/idle_enabled
echo 1 > module/msm_pm/modes/cpu1/power_collapse/idle_enabled
#Put all other cores offline
echo 0 > devices/system/cpu/cpu2/online
echo 0 > devices/system/cpu/cpu3/online
governor="performance"
scaling_min_freq="787200"
if [[ `grep "oem_perf_change" /proc/cmdline` ]];then
    if [[ `grep "oem_perf_on" /proc/cmdline` ]];then
        oem_perf_stats="1"
    else
        oem_perf_stats="0"
    fi
    echo -n $oem_perf_stats > /factory/oem_perf_stats
fi
echo $governor > devices/system/cpu/cpu0/cpufreq/scaling_governor
echo $governor > devices/system/cpu/cpu1/cpufreq/scaling_governor
#below ondemand parameters can be tuned
echo 50000 > devices/system/cpu/cpufreq/ondemand/sampling_rate
echo 90 > devices/system/cpu/cpufreq/ondemand/up_threshold
echo 1 > devices/system/cpu/cpufreq/ondemand/io_is_busy
echo 2 > devices/system/cpu/cpufreq/ondemand/sampling_down_factor
echo 10 > devices/system/cpu/cpufreq/ondemand/down_differential
echo 70 > devices/system/cpu/cpufreq/ondemand/up_threshold_multi_core
echo 10 > devices/system/cpu/cpufreq/ondemand/down_differential_multi_core
echo 787200 > devices/system/cpu/cpufreq/ondemand/optimal_freq
echo 300000 > devices/system/cpu/cpufreq/ondemand/sync_freq
echo 80 > devices/system/cpu/cpufreq/ondemand/up_threshold_any_cpu_load
echo $scaling_min_freq > devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo $scaling_min_freq > devices/system/cpu/cpu1/cpufreq/scaling_min_freq
echo 787200 > devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo 787200 > devices/system/cpu/cpu1/cpufreq/scaling_max_freq
#Below entries are to set the GPU frequency and DCVS governor
echo 200000000 > class/kgsl/kgsl-3d0/devfreq/max_freq
echo 200000000 > class/kgsl/kgsl-3d0/devfreq/min_freq
echo performance > class/kgsl/kgsl-3d0/devfreq/governor
chown -h system devices/system/cpu/cpu[0-1]/cpufreq/scaling_max_freq
chown -h system devices/system/cpu/cpu[0-1]/cpufreq/scaling_min_freq
chown -h root.system devices/system/cpu/cpu[1-3]/online
chmod 664 devices/system/cpu/cpu[1-3]/online
