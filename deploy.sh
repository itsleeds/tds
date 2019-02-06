cp -Rv slides /tmp
git checkout gh-pages
cp -Rv /tmp/slides/* slides/
git status
git add slides/* slides/libs
git commit -am 'Add slides'
git push origin gh-pages
git clean -f
git checkout master
