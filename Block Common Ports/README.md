# Block Common Ports

Port scanners and bots trying to force their way into an exposed system are quite common on the internet.  
As such, it is a good idea to not expose ports to the internet unless you have a good reason to.

Take for example the following ports:

- tcp/21 (ftp)
- tcp/22 (SSH)
- tcp/3306 (MySQL)
- tcp/8728 (MikroTik api)
- tcp/8729 (MikroTik api-ssl)
- tcp/8291 (MikroTik WinBox)

As these are ports I will _never_ expose to the WAN-side of my firewall (using a WireGuard VPN to get in via the "LAN-side" instead), it means that anyone trying to as much as poke at these ports is likely up to no good.  
Because of this, I have decided to just block anyone that does so right on the spot.

Please do note that this is only an *enhancement* to your firewall.   
If you haven't done so, please properly secure your device(s) first.

## Creating the blockage logic

First, we need to setup the blockage logic itself.  
This doesn't do much after we're done in this section but it will after the next section.

To do so, let's create a RAW firewall rule.  
This rule will drop every packet coming from any address on the (currently non-existing) blacklist.

```
/ip firewall raw
  add action=drop chain=prerouting comment="Drop incoming from naughty addresses" src-address-list=santas-naughty-list
```

Next, we need to create a chain to which we can add our blacklisted ports in the future.  
This isn't strictly needed, however, I find it to be easier to follow the flow and expand it this way.

```
/ip firewall filter
  add action=jump chain=input comment="Detect naughty addresses" in-interface-list=WAN jump-target=detect-naughty-addresses
```

And a chain that will actually add addresses to the blacklist.  
Again, not strictly needed but it's easier to follow the flow this way.  
Additionally, it saves me from having to repeat 1337666 rules to add things to the blacklist.  
You can increase or decrease the timeout to your desirable time.  
I just stick to `90d` because my CCR2004 has 4GB of RAM that rarely get filled and has a CPU that's more than beefy enough to not really have performance problems.  
If you have less RAM and/or a weaker CPU (eg. RB5009 or hAP AX3), you might want to look into a lower timeframe.
While at it, we'll also add a rule that will drop the packet itself.

```
/ip firewall filter
  add action=add-address-to-naughty-list address-list=santas-naughty-list address-list-timeout=90d chain=add-naughty-list comment="Add address to naughty list"
  add action=drop chain=add-address-to-naughty-list comment="Drop naughty packet immediately"
```

With this set up, we have all the basic logic for the blockage!  
You can add addresses manually to the list `santas-naughty-list` or use something like the API to add addresses via other means (eg. addresses that try to bruteforce a login on your website).  
As long as the address is in the list, it'll be blocked completely!

## Adding blacklisted ports

Finally, let's set up the bits that will automatically blacklist naughty addresses.  
The logic here is simple:
- If packet matches the rule -> jump to a different chain (to blacklist and drop the packet immediately).
- If packet does not match the rule -> Continue to the next rule.
- If packet does not match any rule -> Return to where we entered the `detect-naughty-addresses` and continue from there.

Adding our rules is as simple as this (this will block the ports mentioned in the introduction):
```
add action=jump chain=detect-naughty-addresses comment="Common Service: FTP" dst-port=21 jump-target=add-address-to-naughty-list protocol=tcp
add action=jump chain=detect-naughty-addresses comment="Common Service: MySQL" dst-port=3306 jump-target=add-address-to-naughty-list protocol=tcp
add action=jump chain=detect-naughty-addresses comment="Common Service: SSH" dst-port=22 jump-target=add-address-to-naughty-list protocol=tcp
add action=jump chain=detect-naughty-addresses comment="MikroTik Service: api-ssl" dst-port=8729 jump-target=add-address-to-naughty-list protocol=tcp
add action=jump chain=detect-naughty-addresses comment="MikroTik Service: api" dst-port=8728 jump-target=add-address-to-naughty-list protocol=tcp
add action=jump chain=detect-naughty-addresses comment="MikroTik Service: winbox" dst-port=8291 jump-target=add-address-to-naughty-list protocol=tcp
```

Feel free to add extra rules that suit your needs!
