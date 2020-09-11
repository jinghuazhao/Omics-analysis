# 17-12-2019 JHZ

git add README.md
git commit -m "README"
for d in eQTL AF BMI CAD T2D st.sh
do
   git add $d
   git commit -m "$d"
done
git push
