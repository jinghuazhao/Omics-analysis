# Proteomics

- AlphaFold3, <https://github.com/google-deepmind/alphafold3>
- casanovo, <https://github.com/Noble-Lab/casanovo>
- CoffeeProt, <https://coffeeprot.com/>
- Consortium for Top-Down proteomics, <https://www.topdownproteomics.org/>
- DiaNN, <https://github.com/vdemichev/DiaNN>
- FINCHES-online, <https://finches-online.com/> (<https://github.com/idptools/finches>)
- FreqPipe, <https://fragpipe.nesvilab.org/>
- Human Proteome Project (HPP), <https://hupo.org/human-proteome-project> (Resources, <https://hupo.org/HPP-Resources>)
- InstaNovo
    * GitHub, <https://github.com/instadeepai/InstaNovo>
    * HuggingFace, <https://huggingface.co/spaces/InstaDeepAI/InstaNovo>
        + High-confidence ProteomeTools dataset <https://doi.org/10.57967/hf/3822>
        + Nine species Benchmark, <https://doi.org/10.57967/hf/3821>
- MassIVE[^wget], <https://massive.ucsd.edu/ProteoSAFe/static/massive.jsp?redirect=auth>
- MassiveFold, <https://github.com/GBLille/MassiveFold>
- MaxQuant, <https://maxquant.org/> ([Mailing list](https://lists.biochem.mpg.de/listinfo/maxquan))
- Mass++, <https://mspp.ninja/download/>
- MS-GF+, <https://msgfplus.github.io/>
- OpenFold, <https://openfold.io/>
- Perseus, <https://maxquant.net/perseus/>
- Peptigram, <http://bioware.ucd.ie/peptigram/>
- Protein Structure Prediction Center, <https://predictioncenter.org/>
- ProteomeXchange, <https://www.proteomexchange.org/>
- ProteoMapper Online, <https://peptideatlas.org/map/>
- RFdiffusion, <https://github.com/RosettaCommons/RFdiffusion>
- Sage, <https://sage-docs.vercel.app/>
- Sashimi, <https://sourceforge.net/projects/sashimi>
- Skyline, <https://skyline.ms/project/home/begin.view>
- Spectranaut, <https://biognosys.com/software/spectronaut/>

[^wget]: **MassIVE** download instructions:

    This is a companion to

    Julian RK (2025). R Programming for Mass Spectrometry: Effective and Reproducible Data Analysis. ISBN: 978-1-119-87235-1, <https://books.wiley.com/titles/9781119872351/>.

    > wget -r -nH --cut-dirs=2 -R "index.html*" ftp://massive-ftp.ucsd.edu/v01/MSV000081318/
    > wget -r -nH --cut-dirs=1 -R "index.html*" ftp://massive-ftp.ucsd.edu/v03/MSV000086195/
    > # Somewhat more efficient
    > lftp massive-ftp.ucsd.edu <<EOF
    > mirror --parallel=10 --verbose /v03/MSV000086195 ./MSV000086195
    > bye
    > EOF
