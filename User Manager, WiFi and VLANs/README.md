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


## (Optionally) Move the database to a USB disk

If your RouterOS device has a USB port, you can opt to move the User Manager database there.  
Doing so saves NAND cycles and while some will argue that it isn't that bad or that they will still last for ages, I personally prefer just using a USB drive (which is why I run my User Manager on an RB5009 instead of my CRS317).  
This of course also helps if you either re-purpose an older device with limited storage (like a hAP AC) as the database can get to 4MB reasonably fast, which on 16MB of NAND, is a lot!  
I assume you have already mounted your storage, if not, you'll need to figure that out first.

After that, you can tell User Manager to use a different path for its database.  
I'll be putting it on `usb1` in a directory `user-manager`.  
You an put it in the root if you want, I prefer this style of organization.
```
/user-manager database
  db-path=usb1/user-manager5
```

## Adding a User

For this user, we'll assume you're gonna use `VLAN 1000`.  
If you want to use a different VLAN, change the `Mikrotik-Wireless-VLANID` attribute accordingly.  

```
/user-manager user
  add attributes=Mikrotik-Wireless-VLANID:1000 name=someuser shared-users=unlimited
```

## Updating your WiFi's security settings

First, we need to allow your router to access User Manager.
```
/user-manager router
  add address=127.0.0.1 name="localhost" shared-secret=lamesecret
```

And then we need to tell it to use it for RADIUS.
``` 
/radius
add address=127.0.0.1 require-message-auth=no service=wireless secret=lamesecret
```

**NOTE**: If you run User Manager on a different device than what handles WiFi authentication, change the addresses accordingly.  

**NOTE**: The secrets must be the same on the User Manager as well as the RADIUS config.  
You can leave this empty but it's not recommended.
