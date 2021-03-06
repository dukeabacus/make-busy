#!/bin/sh
NETWORK=${NETWORK:-"kazoo"}
# sanity check
for cmd in docker sup git
do
	command -v $cmd >/dev/null 2>&1 || { echo "$cmd is required, but missing"; exit 1; }
done

echo Waiting for kazoo.$NETWORK to start '(you may check docker logs if impatient)'
watch -g "docker logs kazoo.$NETWORK | grep 'auto-started kapps'" > /dev/null

echo -n "create master account: "
sup crossbar_maintenance create_account admin admin admin admin

echo "import kazoo sounds"
git clone --depth 1 --no-single-branch https://github.com/2600hz/kazoo-sounds
docker cp kazoo-sounds/kazoo-core/en/us kazoo.$NETWORK:/home/user
sup kazoo_media_maintenance import_prompts /home/user/us en-us
docker exec --user root kazoo.$NETWORK rm -rf us

echo "import makebusy sounds"
mkdir en-mb
docker cp makebusy.$NETWORK:/home/user/make-busy/prompts/make-busy-media.tar.gz en-mb/
cd en-mb
tar zxvf make-busy-media.tar.gz
rm -f make-busy-media.tar.gz
docker cp ../en-mb kazoo.$NETWORK:/home/user
sup kazoo_media_maintenance import_prompts /home/user/en-mb/ en-mb
cd ../
rm -rf en-mb

# wait kazoo to digest files
sleep 10
# save it for future use (e.g. clear things)
docker commit couchdb.$NETWORK kazoo/couchdb-mkbs
cd ../
