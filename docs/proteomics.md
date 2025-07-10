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
- ISA tools, <https://isa-tools.org/>
- MassIVE*[^ast], <https://massive.ucsd.edu/ProteoSAFe/static/massive.jsp?redirect=auth>
- MassiveFold, <https://github.com/GBLille/MassiveFold>
- MaxQuant, <https://maxquant.org/> ([Mailing list](https://lists.biochem.mpg.de/listinfo/maxquan))
- Mass++, <https://mspp.ninja/download/>
- MassBank of North America (MoNA)*, <https://mona.fiehnlab.ucdavis.edu/>
- MetaboLights*, <https://www.ebi.ac.uk/metabolights/index>
- MS-GF+, <https://msgfplus.github.io/>
- OpenFold, <https://openfold.io/>
- Perseus, <https://maxquant.net/perseus/>
- Peptigram, <http://bioware.ucd.ie/peptigram/>
- Protein Structure Prediction Center, <https://predictioncenter.org/>
- ProteomeXchange, <https://www.proteomexchange.org/>
- ProteoMapper Online, <https://peptideatlas.org/map/>
- R Programming for Mass Spectrometry*[^web], <https://books.wiley.com/titles/9781119872351/>
- RFdiffusion, <https://github.com/RosettaCommons/RFdiffusion>
- Sage, <https://sage-docs.vercel.app/>
- Sashimi, <https://sourceforge.net/projects/sashimi>
- Skyline, <https://skyline.ms/project/home/begin.view>
- Spectranaut, <https://biognosys.com/software/spectronaut/>

[^ast]: **\***

    These are data sources.

[^web]: **Data download instructions**

    Julian RK (2025). R Programming for Mass Spectrometry: Effective and Reproducible Data Analysis. ISBN: 978-1-119-87235-1.

    **large-data/mona/** for Chapter 7:

    [MoNA-export-LC-MS-MS_Positive_Mode.msp](https://mona.fiehnlab.ucdavis.edu/rest/downloads/retrieve/873fbe29-4808-46d1-a4a3-a4134ac8c755)

    **MTBLS4938** for Chapter 7:

    - [NIAID](https://data.niaid.nih.gov/resources?id=mtbls4938)
    - [MetaboLights](https://www.ebi.ac.uk/metabolights/MTBLS4938)

    **large-data/MSV000081318/MSV000086195**

    File transfer including directory listing is done with

    ```bash
    ftp massive-ftp.ucsd.edu` <<EOF
    anonymous
    ls
    cd z01/ccms_peak/
    prompt
    mget *
    EOF
    ```

    with wget counterparts

    ```bash
    wget -r -nH --cut-dirs=2 -R "index.html*" ftp://massive-ftp.ucsd.edu/v01/MSV000081318/
    wget -r -nH --cut-dirs=1 -R "index.html*" ftp://massive-ftp.ucsd.edu/v03/MSV000086195/
    ```

    while lftp is furnished as follows,

    ```bash
    lftp massive-ftp.ucsd.edu <<EOF
    mirror --parallel=10 --verbose /v03/MSV000086195 ./MSV000086195
    bye
    EOF
    # to resume
    lftp -e "mirror --continue --parallel=4 /z01/MSV000086195/ccms_peak/ ccms_peak/; quit" \
          ftp://massive-ftp.ucsd.edu
    ```

    **schema/** for Chapter 3:

    - [mzIdentML1.1.0.xsd](https://raw.githubusercontent.com/HUPO-PSI/mzIdentML/refs/heads/master/schema/mzIdentML1.1.0.xsd)
    - [Skyline_3.73.xsd](https://raw.githubusercontent.com/ProteoWizard/pwiz/refs/heads/master/pwiz_tools/Skyline/TestUtil/Schemas/Skyline_3.73.xsd)
