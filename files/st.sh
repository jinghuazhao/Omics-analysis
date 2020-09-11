# 11-9-2020 JHZ

git add README.md
git commit -m "README"
for d in eQTL AF BMI CAD T2D files
do
   git add $d
   git commit -m "$d"
done
git push
