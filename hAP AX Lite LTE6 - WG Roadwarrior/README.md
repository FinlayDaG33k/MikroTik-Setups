# hAP AX Lite LTE6 - Wireguard Roadwarrior

Since I work as a truck driver, I'm on the road quite a lot.  
However, breaks are a *huge* pain for me.
As a result, I bought a little [hAP AX Lite LTE6](https://mikrotik.com/product/hap_ax_lite_lte6) (herafter "router") so I can have portable wifi with me, without relying on my phone's wifi hotspot.  
Together with a little `Unlimited Data` (FUP applies) Dutch telecom provider `Odido`, I basically don't have to worry about data either.

I use Wireguard quite a bit when on the road to connect to my servers but what if I get a new device and forget to setup a client?  
Well, I'm kinda screwed then...  
But what if I am one step ahead of myself and just have the router handle it for me?  
That's probably save me a lot of headaches in the future

**NOTE**: This setup only handles the side of the router as a "client".  
I assume you've already set that up on your own.

**NOTE**: This setup uses Wireguard *but* should in theory also work just fine for IPsec or OpenVPN.  
You'll just need to substitute the Wireguard interface for your IPsec/OpenVPN interface.

## Basic router setup

First, we need to set up the router so our devices can connect to it and I can browse the internet as-is.  
No wireguard here just yet.
If you've just taken your router out of the box and used the default configs, then most of this should be in place already.  
In that case, you can skip this entire section really.

[TO BE CONTINUED...]

## Setup Wireguard

[TODO: Setup Wireguard itself]

Now we need to create a routing table for the VPN.  
This is just a "collection of routes" but on its own it doesn't quite do anything yet.
```
/ip vrf
  add interfaces=none name=VPN
```

And let's create a routing rule that will send all the traffic marked with the `VPN` mark, into the routing table we've just created.  
By specifying the `action=lookup-only-in-table` we tell the router to... well... Only look for routes in the *specific* table we've specified.  
In other words, if our VPN table doesn't have a suitable route, it will simply not be routed and no fallback to the `main` table will be made either.
```
/routing rule
  add action=lookup-only-in-table disabled=no routing-mark=VPN table=VPN
```

Next, we need to create a route to send anything coming into our routing table out via the Wireguard interface.
Without this, the router doesn't quite know where to send the traffic.  
Don't worry, we'll specify which data can and cannot be routed over the VPN in a bit.
```
/ip route
  add disabled=no distance=1 dst-address=0.0.0.0/0 gateway=wireguard1 pref-src="" routing-table=VPN scope=30 suppress-hw-offload=no target-scope=10
```

To make it easier on ourselves, we need to tell our firewall to masquerade any traffic going out via the wireguard interface.  
This will mean that all traffic seems to come from _one_ source as far as the server is concerned, significantly simplifying the server config as well.
```
/ip firewall nat
  add action=masquerade chain=srcnat out-interface=wireguard
```

Now let's define the IP ranges we want to have go via Wireguard.  
In my case, I only care about some ranges for my home network.
```
/ip firewall address-list
  add address=192.168.1.0/24 list="Home"
  add address=192.168.3.0/24 list="Home"
  add address=192.168.0.0/24 list="Home"
```

And finally, to make it all work, we need to mark routes to go over wireguard.
This will just look whether the destination address is in the list we just made and if so, mark the route.  
It will, however, exclude traffic going _directly_ to the router so I can still access it and its services.
```
/ip firewall mangle
  add action=mark-routing chain=prerouting comment="Home via VPN" dst-address=!192.168.88.1 dst-address-list="Home" new-routing-mark=VPN
```

And that's it!  
When you connect

## Sharing is caring!

Sometimes, you hang out with a friend... Hmm... Friends...  
Yes, let's just assume we have friends, okay?  
Anyways, they can also make use of this router _but_ you don't quite want them to access your home network.  
Well, then we can just setup a guest network for them but not mark the routes to go through the VPN.

```
/interface wifi
  add configuration.mode=ap .ssid="MyGuestSSID" disabled=no master-interface=wifi1 name=wifi2 security.authentication-types=wpa2-psk,wpa3-psk
```

``` 
/ip bridge port
  add bridge=bridge frame-types=admit-only-untagged-and-priority-tagged interface=wifi2 pvid=2
```

``` 
/interface bridge vlan
  add bridge=bridge tagged=bridge untagged=wifi2 vlan-ids=2
```

```
/ip pool
  add name=guests ranges=172.16.1.2-172.16.1.254
```

Setup a VLAN interface on our `bridge` so we can act as the gateway for this network.
```
/interface vlan
  add interface=bridge name=vlan2 vlan-id=2
```

Next up, give out router an IP on this new interface
``` 
/ip address
  add address=172.16.1.1/24 interface=vlan2 network=172.16.1.0
```

And setup the DHCP server on this interface:
```
/ip dhcp-server
  add address-pool=guests interface=vlan2 lease-time=10m name=guests
/ip dhcp-server network
  add address=172.16.1.0/24 comment=guests dns-server=172.16.1.1 gateway=172.16.1.1
```

### Allow some stuff over the Wireguard

TODO
