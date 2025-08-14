# Get amount of connected devices
:local deviceCount [/interface/wifi/registration-table print count-only where interface="wifi2"];

# Create the new password
:local datetime [/system clock get date];
:local day [ :pick $datetime 8 11 ];
:local month [ :pick $datetime 5 7 ];
:local year [ :pick $datetime 0 4 ];
:local newPassword "$day$month$year";

# Get the current password
:local currentPassword [/interface/wifi get [find name="wifi2"] security.passphrase];

# Update password if need be and nobody is connected
:if (( $newPassword != $currentPassword ) && ( $deviceCount = 0 )) do={
  :log info "changing guest password to: \"$newPassword\"";
  /interface wifi set wifi2 security.passphrase="$newPassword";
}
