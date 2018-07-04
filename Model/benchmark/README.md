## Stochastic model benchmark (DSPNs in Oris and fdCTMCs in fdPRISM) created as the output of my bachelor's thesis.

## http://www.fi.muni.cz/~xuhrik/

## Gitlab repository file organisation explanation:

"devel" is where the raw model related files are stored and where you implement changes to the models themselves.
        Intended files are .xml Oris 2 implementation, .pm fdPRISM implementation, and .txt README file of the model.
    
"release" contains all files necessary for publishing.
          Intended files are .html subwebpage, .zip package of the whole devel subfolder of a model,
          .png screenshot and one extra copy of the .txt README used as a preview.

## Webpage implementation explanation:

The main webpage gateway is index.html (http://www.fi.muni.cz/~xuhrik/).
This is simply a convenient publicly accessible GUI front for the /release directory.
index.html contains iframe of the google spreadsheet and a link to this repository.
Each model has a subwebpage. In the google spreadsheet, there are links to the subwebpages.
Subwebpages consist of a download link for the .zip package of the model related files, and iframe previews.

Therefore 3 services are used - aisa.fi.muni.cz, gitlab.com, and google drive.
However, only aisa.fi.muni.cz (where http://www.fi.muni.cz/~xuhrik/ is based) is needed to function.
Failures of Gitlab.com or google drive services would be inconvenient, but not fatal.
This is because a copy of \release is uploaded to aisa.fi.muni.cz anyway.
Using this, for emergencies, index.html still offers an alternative way to navigate the "database".


## How to create/edit/remove models (in the entire DB):

You can find a more detailed guide in my thesis (reachable via http://www.fi.muni.cz/~xuhrik/).
There are scripts in directory utilityScripts to help you with some of the following steps!

1) In gitlab repository under \devel, create/edit/remove a subdirectory with all related files.
   (There is a script for creating new models)
    
2) In gitlab repository under \release, create/edit/remove a .zip package of the entire model specific \devel subdirectory.
   Also create/edit/remove a .png screenshot of the Oris DSPN implementation and one extra copy of the .txt README for previews.
   Lastly, create/edit/remove the .html subwebpage, which should contain a download link for the .zip file, and iframe previews of the .txt and .png files.
   (There is a script for releasing models)
       
(the final steps are to actually make publicly visible changes on the website)

3)  Upload the entire updated \release directory (and index.html if needed) to the server (aisa.fi.muni.cz) (replace the old files).
    (There is a script for doing this whole step)
       
4)  create/edit/remove the model in the google spreadsheet (including the hyperlink to the subwebpage!).