#!/bin/bash
FILE="app/src/main/java/com/github/brokenithm/activity/MainActivity.kt"

# Replace 1_000_000L (1ms) with 8_000_000L (8ms) to prevent UDP/TCP packet flooding.
# This yields approximately 125 packets per second, avoiding network congestion while maintaining good responsiveness.
sed -i 's/LockSupport.parkNanos(1_000_000L)/LockSupport.parkNanos(8_000_000L)/g' $FILE
