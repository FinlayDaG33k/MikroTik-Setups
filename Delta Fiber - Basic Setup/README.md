# Delta Fiber - Basic Setup

I've also made the routes available as a `.txt` file in case you want to automate it, or if you somehow stumbled upon this guide but aren't an MT user.

- [Routes for IPTV](iptv-destinations.txt) (Route over VLAN 101).
  - `62.45.57.36/32` is the exception and _must_ be routed over VLAN 100.
- [Routes for VoIP](voip-destinations.txt) (Route over VLAN 102).

## Internet Setup

## IPTV

And now we need to add a bunch of routes.  
Some of these are documented on their website but some of these were not.  
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
