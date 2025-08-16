# Delta Fiber - Basic Setup

For years, we were customers of UPC, which then later became Ziggo and then VodafoneZiggo.  
Outside the huge debacle with the `Intel Puma 6` chipset in their modems (which took _months_ for them to [resolve](https://x.com/finlaydag33k/status/1409134081783353345) - even including a [scam attempt](https://x.com/finlaydag33k/status/1405249947797274625)), they mostly worked fine.  
However, their monopoly on the copper network here (unless you were fine with 20Mbit down via VDSL), meant they charged ridiculous amounts for their services (100 euro a month for 300/30, TV and landline phone).  
So when competitor Delta announced they would be rolling out fiber here, I immediately summoned my parents around the table.  
After running some math, we'd get about the same _but_ instead of 300/30 internet, we'd get 1000/1000 and as such, we signed up.
After a huge initial struggle, things have been running mostly smoothly for about a year now.  
So I'll be sharing my setup for those also wanting to use Delta with their MikroTik.  

My setup uses a [CCR2004-1G-12S+2XS](https://mikrotik.com/product/ccr2004_1g_12s_2xs) as my gateway router *but* any MikroTik with an SFP+ port like an [RB5009UG+S+IN](https://mikrotik.com/product/rb5009ug_s_in) will do.  
Additionally, you'll need an ONT that is supported, the `Zaram ZXOS11NPI` is a very popular one.  
And, of course, the right fiber cable: The FTU (mounted to the wall) accepts `SC/APC` inside the sled while the Zaram ONT accepts `SC/UPC`.

I've also made the routes available as a `.txt` file in case you want to automate it, or if you somehow stumbled upon this guide but aren't an MT user.  
Oddly enough, some of the routes aren't documented on their site.

- [Routes for IPTV](iptv-destinations.txt) (Route over VLAN 101).
  - `62.45.57.36/32` is the exception and _must_ be routed over VLAN 100.
- [Routes for VoIP](voip-destinations.txt) (Route over VLAN 102).

**NOTE**: This setup only shows how to get your MikroTik to function with Delta as the upstream.  
It does not cover anything LAN related like DHCP or WiFi.

## ONT Registration

TODO

## Internet Setup

The internet setup lies at the foundation of this entire guide.  
And let's be real, chances are this is the most important for you anyways.


## IPTV

And now we need to add a bunch of routes.
IPTV will still function just fine without these routes, however, it will nibble away from your internet bandwidth.  
Not the end of the world but if you run a lot of stuff, it's just a waste.

```
/ip route
  add comment="Delta IPTV" disabled=no distance=1 dst-address=62.45.57.36/32 gateway=\
    delta-vlan100 pref-src="" routing-table=main scope=30 suppress-hw-offload=no target-scope=10
  add comment="Delta IPTV" disabled=no dst-address=62.45.57.34/32 gateway=\
    10.188.168.1 routing-table=main suppress-hw-offload=no
  add comment="Delta IPTV" disabled=no distance=1 dst-address=62.45.57.0/24 \
    gateway=10.188.168.1 pref-src=0.0.0.0 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
  add comment="Delta IPTV" disabled=no distance=1 dst-address=62.45.61.64/28 \
    gateway=10.188.168.1 pref-src=0.0.0.0 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
  add comment="Delta IPTV" disabled=no distance=1 dst-address=62.45.76.0/24 \
    gateway=10.188.168.1 pref-src=0.0.0.0 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
  add comment="Delta IPTV" disabled=no distance=1 dst-address=62.45.58.226/32 \
    gateway=10.188.168.1 pref-src=0.0.0.0 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
  add comment="Delta IPTV" disabled=no distance=1 dst-address=62.45.45.150/32 \
    gateway=10.188.168.1 pref-src="" routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
  add comment="Delta IPTV" disabled=no distance=1 dst-address=62.45.49.0/24 \
    gateway=10.188.168.1 pref-src=0.0.0.0 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
  add comment="Delta IPTV" disabled=no distance=1 dst-address=212.115.196.0/25 \
    gateway=10.188.168.1 pref-src=0.0.0.0 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
  add comment="Delta IPTV" disabled=no distance=1 dst-address=217.63.90.128/25 \
    gateway=10.188.168.1 pref-src=0.0.0.0 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
  add comment="Delta IPTV" disabled=no distance=1 dst-address=62.45.61.16/28 \
    gateway=10.188.168.1 pref-src=0.0.0.0 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
  add comment="Delta IPTV" disabled=no distance=1 dst-address=62.45.61.32/27 \
    gateway=10.188.168.1 pref-src=0.0.0.0 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
  add comment="Delta IPTV" disabled=no distance=1 dst-address=217.102.255.57/32 \
    gateway=10.188.168.1 pref-src=0.0.0.0 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
  add comment="Delta IPTV" disabled=no dst-address=217.63.91.0/26 gateway=\
    10.188.168.1 routing-table=main suppress-hw-offload=no
  add comment="Delta IPTV" disabled=no dst-address=62.45.59.0/24 gateway=\
    10.188.168.1 routing-table=main suppress-hw-offload=no
  add comment="Delta IPTV (Undocumented)" disabled=no distance=1 dst-address=\
    62.45.158.17/32 gateway=10.188.168.1 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
  add comment="Delta IPTV (Undocumented)" disabled=no distance=1 dst-address=\
    62.45.158.29/32 gateway=10.188.168.1 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
  add comment="Delta IPTV (Undocumented)" disabled=no distance=1 dst-address=\
    62.45.158.13/32 gateway=10.188.168.1 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
  add comment="Delta IPTV (Undocumented)" disabled=no distance=1 dst-address=\
    62.45.158.15/32 gateway=10.188.168.1 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
  add comment="Delta IPTV (Undocumented)" disabled=no distance=1 dst-address=\
    62.45.158.27/32 gateway=10.188.168.1 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
  add comment="Delta IPTV (Undocumented)" disabled=no distance=1 dst-address=\
    62.45.158.11/32 gateway=10.188.168.1 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
```

## Landline

And the routes to tell our MikroTik to send traffic over the `VLAN102` interface:

``` 
/ip route
  add comment="Delta VoIP" disabled=no distance=1 dst-address=62.45.58.162/32 \
    gateway=10.224.192.1 pref-src=0.0.0.0 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
  add comment="Delta VoIP" disabled=no distance=1 dst-address=62.45.58.180/32 \
    gateway=10.224.192.1 pref-src=0.0.0.0 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
  add comment="Delta VoIP" disabled=no distance=1 dst-address=62.45.59.36/32 \
    gateway=10.224.192.1 pref-src=0.0.0.0 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
  add comment="Delta VoIP" disabled=no distance=1 dst-address=62.45.59.50/32 \
    gateway=10.224.192.1 pref-src=0.0.0.0 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
  add comment="Delta VoIP" disabled=no distance=1 dst-address=62.45.60.3/32 \
    gateway=10.224.192.1 pref-src=0.0.0.0 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
  add comment="Delta VoIP" disabled=no distance=1 dst-address=62.45.60.2/32 \
    gateway=10.224.192.1 pref-src=0.0.0.0 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
```
