# User Manager, WiFi and VLANs

Setup WiFi access using User Manager and implement VLAN separation.  
Useful if you want to have specific users' their WiFi going to specific VLANs.

Reasons to use this setup:

- You want to isolate certain users without making 1337666 separate SSIDs.
- You want to easily see which devices belongs to which person.
- You want to set time limits for specific users (eg. people you only ever see in the weekends).

Reasons to not use this setup:

- You are the only one using your network.
- You only want to isolate IoT or guest devices.
- You run silly consumer electronics that do not support WPA(2)-EAP (eg. a Nintendo Switch or a printer).

**NOTE**: This setup only handles setting up User Manager, your WiFi and assigning VLANs to users.  
It does not handle setting up WiFi, CAPsMAN or VLANs on routers and switches.

## Installing User Manager

## Adding a User

For this user, we'll assume you're gonna use `VLAN 1000`.  
If you want to use a different VLAN, change the `Mikrotik-Wireless-VLANID` attribute accordingly.  

```
/user-manager user
  add attributes=Mikrotik-Wireless-VLANID:1000 name=someuser shared-users=unlimited
```

## Updating your WiFi's security settings

First, we need to allow your router to access User Manager.  
If you run your User Manager on a _different_ device than your WiFi, change the address accordingly (it must point to the device running your wifi).  
```
/user-manager router
  add address=127.0.0.1 name="local host"
```

And then we need to tell it to use it for RADIUS.  
Again, if you run your User Manager on a _different_ device than your WiFi, change the address accordingly (it must point to device running User Manager).
``` 
/radius
add address=127.0.0.1 require-message-auth=no service=wireless
```
