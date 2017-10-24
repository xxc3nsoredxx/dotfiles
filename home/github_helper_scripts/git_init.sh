current_dir=`pwd | sed -e 's/\/.*\///g'`
no_space=`echo $current_dir | sed -e 's/\s/-/g'`
repo=git@github.com:xxc3nsoredxx/`echo $no_space`.git
echo $repo
echo "# $current_dir" > README.md
git init
# git lfs track "*.psd"
git add README.md
git add .
git commit -m "first commit"
git remote add origin $repo
git push -u origin master
