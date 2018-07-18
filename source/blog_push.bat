cp -rv public/* cziszero.github.io/
cp -rv _config.yml cziszero.github.io/source/
cp -rv package.json cziszero.github.io/source/
cp -rv scaffolds cziszero.github.io/source/
cp -rv source cziszero.github.io/source/
cp -rv themes cziszero.github.io/source/
git add .
git commit -m "update"
git push
pause