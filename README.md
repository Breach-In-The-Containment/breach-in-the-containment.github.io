# breachinthecontainment.github.io
Our website

Made with love and sweat.

## Made changes? Test locally before PR!

Use the docker image to serve locally to test it before anything else.

`docker build -t breach-in-the-containment . && docker run -p 8080:80 breach-in-the-containment`

Then go to this URL:

| Production  | Dev |
| --- | --- |
| http://localhost:8080/  | http://localhost:8080/dev/ |
| **OR** | **OR** |
| http://localhost:8080/index.html  | http://localhost:8080/dev/index.html  |
