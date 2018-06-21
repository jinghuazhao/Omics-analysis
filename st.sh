# 21-6-2018 JHZ

git add README.md
git commit -m "README"
for d in BMI CHD T2D st.sh
do
   git add $d
   git commit -m "$d"
done
git push
