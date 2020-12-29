# net-stat-script
Simple script to record internet status and log them to a file.

Log includes timestamp, internet status, and duration.

e.g. 21:51:11 Internet Status: NOK, Duration: 00:00:45

## Log format
Saved in file named **internet_status_[date_today]**.

Logs are appended if file already exist.

Script prints a log every time internet status changes e.g. from OK to NOK (Accompanied by a beep sound)

## Duration accuracy
Script checks for internet connection every 5 seconds so duration is not *totally* accurate.

## Extra note:
Wrote this because we're losing our internet connection intermittently.

Found out after running this script that our internet connection.
- is OK every 15 - 30 minutes
- then NOK for 1 - 5 minutes 
- then repeat

Hope our ISP can fix this soon. :(
