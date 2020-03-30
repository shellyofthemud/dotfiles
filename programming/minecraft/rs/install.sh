#!/bin/

hostname=$(cat /etc/hostname)
yum install git -y
git config --global --unset core.autocrif
ln -s /mnt/$hostname/world/ world/
ln -s /mnt/$hostname/world_nether world_nether/
ln -s /mnt/$hostname/world_the_end world_the_end/

curl -o BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar && java -jar BuildTools.jar

mkdir plugins
for p in $(cat plugins.txt)
do
    $(echo $p | awk '{ split($0,fn,":"); printf "curl -o plugins/%s.jar %s:%s\n", fn[1], fn[2], fn[3]; }')
done

echo "eula=true" > eula.txt
