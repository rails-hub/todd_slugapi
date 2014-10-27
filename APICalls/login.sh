#!/bin/bash
rm output.html
curl -d "username=jquave&password=Password00" http://localhost:3000/api/login >> output.html
xdg-open output.html
