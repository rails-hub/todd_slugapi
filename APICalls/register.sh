#!/bin/bash
rm output.html
curl -d "email=jquave@gmail.com&username=jquave&password=password00&phone=9855072053" http://localhost:3000/api/register >> output.html
xdg-open output.html
