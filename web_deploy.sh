#!/bin/bash
#replace userid from demo to liveDemo
sed -i '' 's/demo/liveDemo/g' lib/view/main_screen.dart

flutter build web
# add script to index.html
sed -r -i -e 's|<script>|<script>document.addEventListener("touchstart", {});</script><script>|g' build/web/index.html
firebase deploy
# replace userid from livedemo to demo
sed -i '' 's/liveDemo/demo/g' lib/view/main_screen.dart

 #optional: ensure flutter test pass first
 # run web locally:
