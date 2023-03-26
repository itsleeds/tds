gh repo clone itsleeds/TDS
cd TDS
git checkout gh-pages
ls # check contents
cd ..

cp -Rv slides/* TDS/slides/
cp -Rv practicals/* TDS/practicals/

cd TDS
git status
# git diff
git add -A
git commit -am 'update site'
git push origin gh-pages
git clean -f

cd ..
