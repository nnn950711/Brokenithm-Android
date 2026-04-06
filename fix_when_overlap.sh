#!/bin/bash
FILE="app/src/main/java/com/github/brokenithm/activity/MainActivity.kt"

# Replace when(y) with independent if statements
# This ensures a finger in the overlapping region (e.g. currentButtonAreaHeight - 15%) triggers BOTH Air and Button!

cat << 'KOTLIN' > patch_script.py
import re

with open("app/src/main/java/com/github/brokenithm/activity/MainActivity.kt", "r") as f:
    content = f.read()

# Replace the when(y) structure with independent if blocks
replacement = """
                    if (y >= 0f && y <= currentAirAreaHeight) {
                        thisAirHeight = 0
                    }
                    if (y > currentAirAreaHeight && y <= currentButtonAreaHeight) {
                        val curAir = ((y - airAreaHeight) / airBlockHeight).toInt()
                        thisAirHeight = if(mSimpleAir) 0 else thisAirHeight.coerceAtMost(curAir)
                    }
                    if (y >= (currentButtonAreaHeight - windowHeight * 0.15f) && y <= windowHeight) {
"""

content = re.sub(r'when\(y\) \{(?:\s*)in 0f\.\.currentAirAreaHeight -> \{(?:\s*)thisAirHeight = 0(?:\s*)\}(?:\s*)in currentAirAreaHeight\.\.currentButtonAreaHeight -> \{(?:\s*)val curAir = \(\(y - airAreaHeight\) / airBlockHeight\)\.toInt\(\)(?:\s*)thisAirHeight = if\(mSimpleAir\) 0 else thisAirHeight\.coerceAtMost\(curAir\)(?:\s*)\}(?:\s*)in \(currentButtonAreaHeight - windowHeight \* 0\.15f\)\.\.windowHeight -> \{', replacement, content, flags=re.MULTILINE)

# Because we removed `when(y) {`, we have an extra closing brace at the end of the block.
# Let's just fix it by replacing the whole block logic manually.

KOTLIN
python3 patch_script.py
