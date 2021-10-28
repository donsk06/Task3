import cgitb
import datetime
import os
cgitb.enable()
print("Content-Type: text/html")
print(
<!DOCTYPE html>
<html>
  <head>
    <title>Site2</title>
  </head>
  <body>
    <p>Python back-end</p>
    <p>Date: {datetime.datetime.now().isoformat()}<p/>
    <p>Fingerprint: {os.environ.get('HTTP_USER_AGENT', '')}<p/>
  </body>
</html>
)

