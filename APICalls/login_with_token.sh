#!/bin/bash
rm output.html
curl -d "auth_token=aa8xsYyUX1KTXRDQbdUeuk" http://localhost:3000/api/login >> output.html
xdg-open output.html
