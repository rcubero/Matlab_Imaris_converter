# Matlab_Imaris_converter

The ImarisReader scripts were taken from
https://github.com/PeterBeemiller/ImarisReader
We found that the MATLAB scripts run into problems when there are surfaces within the *.ims files, and fixed this in the scripts accordingly.

The extract_filaments_from_imaris script was written by Christoph Sommer (IOF, Institute of Science and Technology Austria).

| :warning: WARNING          |
|:-----------------------------------|
| These scripts need a Windows machine |

To run the scripts,
- install Neuroland Morphology Converter (http://neuronland.net/NLMorphologyConverter/NLMorphologyConverter.html)
- make sure to add `ImarisReader` to MATLAB path
- open `folder_processing.m` in MATLAB
- enter the full folder path where Imaris files are located in `FOLDER` 
- run `folder_processing.m`
