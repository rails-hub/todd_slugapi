#!/bin/bash
rm output.html
curl -d "auth_token=aa8xsYyUX1KTXRDQbdUeuk&caption='This caption rocks'&user_id=1&s3url=http://upload.wikimedia.org/wikipedia/commons/8/88/VolkswagenBeetle-001.jpg" http://localhost:3000/api/upload_shot >> output.html
xdg-open output.html
