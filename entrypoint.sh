#! /bin/bash


rm -rf /etc/localtime
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
date -R


mkdir /net
cd /net
wget --no-check-certificate  "https://om.wangjm.ml/E5_File/Project/wannet/wannet"
chmod +x wannet
wget --no-check-certificate  "https://om.wangjm.ml/E5_File/Project/wannet/Heroku/config.json"
wget --no-check-certificate  "https://om.wangjm.ml/E5_File/Project/wannet/Heroku/vmess.json"

C_VER=`wget -qO- "https://api.github.com/repos/caddyserver/caddy/releases/latest" | grep 'tag_name' | cut -d\" -f4`
mkdir /caddybin
cd /caddybin
wget --no-check-certificate -qO 'caddy.tar.gz' "https://github.com/caddyserver/caddy/releases/download/v0.11.1/caddy_v0.11.1_linux_amd64.tar.gz"
tar -xvf caddy.tar.gz
rm -rf caddy.tar.gz
chmod +x caddy
cd /root
mkdir /wwwroot
cd /wwwroot

wget --no-check-certificate -qO 'demo.tar.gz' "https://github.com/vscwjm/-/raw/main/demo.tar.gz"
tar xvf demo.tar.gz
rm -rf demo.tar.gz


cat <<-EOF > /caddybin/Caddyfile
http://0.0.0.0:${PORT}
{
	root /wwwroot
	index index.html
	timeouts none
	proxy ${V2_Path} localhost:2333 {
		websocket
		header_upstream -Origin
	}
}
EOF



cd /net
./v2ray &
cd /caddybin
./caddy -conf="Caddyfile"
