#!/bin/sh
#Author:jinshi.song
#Email:jinshi.song@jrdcom.com
#Data:2014/01/14 11:47

if [ $# -lt 1 ]
then
echo "The paramter can't be empty."
exit 1
#elif [ $# -lt 2 ]
#then
#echo "The second paramter can not be empty."
#echo "Please specify a temporary directory on your PC."
#exit 2
fi

rm -irf output
rm -irf temp
rm -irf manifestList

mkdir -p output
mkdir -p temp

cd ../PullAndroidManifestTool
./OneKeyPullManifest.sh /system/app /system/framework /custpack/app /local/temp
cd -
cp -irf /local/temp/manifestList .

cd $1
grep -H "<provider" -r . > emulatorContentProvider.txt
cd -
mv $1/emulatorContentProvider.txt ./temp/

cd manifestList
grep -H "<provider" -r . > ../temp/PhoneContentProvider.txt
cd -

grep -vFf ./temp/emulatorContentProvider.txt ./temp/PhoneContentProvider.txt > ./output/customOEMContentProvider.txt
cp ./output/customOEMContentProvider.txt ./output/sensitiveCustomeOEMContentProvider.txt
grep -v "android:exported=\"false\"" ./output/customOEMContentProvider.txt > ./temp/exportedCustomOCP.txt
grep "android:permission" ./temp/exportedCustomOCP.txt > ./output/ContentProviderwithPermission.txt
grep "android:readPermission" ./temp/exportedCustomOCP.txt | grep "android:writePermission" >> ./output/ContentProviderwithPermission.txt
grep -vFf ./output/ContentProviderwithPermission.txt ./temp/exportedCustomOCP.txt > ./output/ContentProviderwithoutPermission.txt

