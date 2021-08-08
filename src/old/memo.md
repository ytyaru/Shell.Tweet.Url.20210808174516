# 改行のURLエンコード

　以下だと改行が消える。

```sh
UrlEncode() { echo "$1" | nkf -WwMQ | sed 's/=$//g' | tr = % | tr -d '\n'; }
```

　以下だと改行が`%`になる。

```sh
UrlEncode() { echo "$1" | nkf -WwMQ | sed 's/=$//g' | tr = % | tr '\n' '%0A'; }
```

　以下で成功。

```sh
UrlEncode() { python -c 'import sys, urllib; print urllib.quote(sys.stdin.read()),'; }
```
