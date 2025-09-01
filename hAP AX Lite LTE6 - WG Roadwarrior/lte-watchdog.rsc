:if (([/system resource get uptime] > 300) && ([/ping 8.8.8.8 count=4 size=64 interval=1s interface=lte1]=0)) do={
    :log error "LTE connection error, restarting..."
    /interface disable lte1
    /delay 1s
    /interface enable lte1
    :log info "LTE interface has been restarted!"
} else={
  :log debug "LTE interface good!"
}
