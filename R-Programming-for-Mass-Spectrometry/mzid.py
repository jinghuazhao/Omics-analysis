import pandas as pd
from pyteomics import mzid

psms = []  # container for all PSM dicts

with mzid.read('ScltlMsclsMAvsCntr_Batch1_BRPhsFr29.mzid') as reader:
    for psm in reader:
        # each psm is a dict of PSM-level info
        # include nested 'SpectrumIdentificationItem' and optional metadata
        record = {
            'spectrumID': psm.get('spectrumID'),
            'rank': psm.get('rank'),
            'peptide_ref': psm.get('peptide_ref'),
            # include any other top-level attributes
        }
        # flatten nested items if needed
        sii = psm.get('SpectrumIdentificationItem')
        if sii:
            # e.g. take the first item if multiple
            record.update({
                'chargeState': sii[0].get('chargeState'),
                'experimentalMassToCharge': sii[0].get('experimentalMassToCharge'),
                'calculatedMassToCharge': sii[0].get('calculatedMassToCharge'),
                'score': sii[0].get('score'),
            })
        psms.append(record)

df = pd.DataFrame(psms)
df.to_csv('output_psms.csv', index=False)
