python开启简单webserver
linux下面使用

python -m SimpleHTTPServer 8000
windows下面使用上面的命令会报错，Python.Exe: No Module Named SimpleHTTPServer,因为windows下面改名了叫：http.server

python -m http.server 8000