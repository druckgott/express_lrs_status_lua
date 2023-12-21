# express_lrs_status_lua
A simple Skript with Lua to display ExpressLRS LinkStats telemetry as well as common Betaflight and iNav flight controller telemetry.

![20231221_133428](https://github.com/druckgott/express_lrs_status_lua/assets/18383738/69446c88-03d2-4263-9d1a-e63e77cffb87)

# Installing

Copy the src/SCRIPTS/TELEMETRY folder to your handset's SD card in the SCRIPTS/TELEMETRY/ folder such that your SD card will end up with a file called SCRIPTS/TELEMETRY/epst.lua.
Discover sensors
    Power up your receiver and flight controller and wait for a connection to be established.
    Press the MDL (model) key, then PAGE to get to the TELEMETRY page.
    Use the "Discover new" button to start discovering sensors. Betaflight should have 17, iNav should have 23 with GPS.
Add the Skript to the main screen
    Press the Curser button on the right and navigate to the 12. page.
    On Screen X where None is select Skript and on the --- select then epst
    Save and go Back
    Use the Courser Button long press down and maybe switch Page with Curser to the right and button right to the curser.
    If you forgot to Discover sensors before adding the Script, discover them and restart the handset entirely.

# Requirements

Tested on FR-Sky X-Lite Pro with EdgeTX "Providence" v2.9.2 only

# What is "Range"?

Range is an estimation of the model's distance. Technically, it is just the percentage of the RSSI from -50dBm (0% range) to the sensitivity limit for your selected packet rate (e.g. -105dBm for 500Hz) where it would indicate 100% range. Range does not account for dynamic power, so the indicated range may decrease as power goes up and increase as power goes down.

## Values displayed (on some values also min and max in the brackets)
| Key | Description | Notes |
|---|---|---|
|RFMD| Packet rate | |
| TPWR | RF transmit power | Right side bar |
| 1RSS and 2RSS | RSSI / Range | Will display 2RSS if any value ever received |
| ANT | Active diversity antenna | Shown as symbol between 1RSS/2RSS and color |
| RQLY | Link quality | |
