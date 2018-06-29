There are 2 windows batch scripts, their 2 unix bash equivalents, and one extra unix bash script.
THESE SCRIPTS ARE EXPECTED TO STAY IN DIRECTORY utilityScripts TO WORK PROPERLY.

createNewModel.bat
-After launching, opens a cmd window asking the user to input a name "modelName" of the model to create.
-Checks whether devel/"modelName" already exists. If it does, the script ends.
-Then creates a new directory "modelName" in the devel directory.
-New directory "modelName" contains:
	-"modelName".pm - fdPRISM fdCTMC skeleton structure with most necessary keywords and syntax examples
	-"modelName".xpn - empty Oris model file for DSPN implementation
	-"modelName".txt - model documentation skeleton structure
-The user is then expected to implement the model.

createNewModel.sh
-First command line argument is the new model name "modelName" of the model to create.
-Checks whether devel/"modelName" already exists. If it does, the script ends.
-Then creates a new directory "modelName" in the devel directory.
-New directory "modelName" contains:
	-"modelName".pm - fdPRISM fdCTMC skeleton structure with most necessary keywords and syntax examples
	-"modelName".xpn - empty Oris model file for DSPN implementation
	-"modelName".txt - model documentation skeleton structure
-The user is then expected to implement the model.

releaseExistingModel.bat
-After launching, opens a cmd window asking the user to input a name "modelName" of an existing model in devel directory.
-Checks if directory devel/"modelName" exists, and exits with an error message if it does not.
-Checks whether directory release/"modelName" exists. If it does, then:
	-Updates the release/"modelName" using devel/"modelName".
	-Directory release/"modelName" now contains updated versions of:
		-"modelName".txt - raw copy of the model documentation
		-"modelName".zip - the archive intended for users to download. Contains:
			-"modelName".pm - fdPRISM fdCTMC implementation
			-"modelName".xpn - Oris DSPN implementation
			-"modelName".txt - model documentation
	-This does not affect the following files in release/"modelName":
		-"modelName".html - subwebpage of the model ready to be deployed to the server.
		-"modelName"PIC.png - preview figure of the model.
	-The user is then expected to manually update the .png DSPN preview if necessary.
-Checks whether directory release/"modelName" exists. If it does not, then:
	-Creates a new directory release/"modelName".
	-New directory release/"modelName" contains these new files:
		-"modelName".html - subwebpage of the model ready to be deployed to the server.
	                            The URLs are hardcoded in the script and need to be changed if the server changes.
		-"modelName".txt - raw copy of the model documentation
		-"modelName".zip - the archive intended for users to download. Contains:
			-"modelName".pm - fdPRISM fdCTMC implementation
			-"modelName".xpn - Oris DSPN implementation
			-"modelName".txt - model documentation
	-The user is then expected to manually add the .png DSPN preview.

releaseExistingModel.sh
-First command line argument is the new model name "modelName" of an existing model in the devel directory.
-Checks if directory devel/"modelName" exists, and exits with an error message if it does not.
-Checks whether directory release/"modelName" exists. If it does, then:
	-Updates the release/"modelName" using devel/"modelName".
	-Directory release/"modelName" now contains updated versions of:
		-"modelName".txt - raw copy of the model documentation
		-"modelName".zip - the archive intended for users to download. Contains:
			-"modelName".pm - fdPRISM fdCTMC implementation
			-"modelName".xpn - Oris DSPN implementation
			-"modelName".txt - model documentation
	-This does not affect the following files in release/"modelName":
		-"modelName".html - subwebpage of the model ready to be deployed to the server.
		-"modelName"PIC.png - preview figure of the model.
	-The user is then expected to manually update the .png DSPN preview if necessary.
-Checks whether directory release/"modelName" exists. If it does not, then:
	-Creates a new directory release/"modelName".
	-New directory release/"modelName" contains these new files:
		-"modelName".html - subwebpage of the model ready to be deployed to the server.
	                            The URLs are hardcoded in the script and need to be changed if the server changes.
		-"modelName".txt - raw copy of the model documentation
		-"modelName".zip - the archive intended for users to download. Contains:
			-"modelName".pm - fdPRISM fdCTMC implementation
			-"modelName".xpn - Oris DSPN implementation
			-"modelName".txt - model documentation
	-The user is then expected to manually add the .png DSPN preview.

serverFilesUpdate.sh
-Inside the script, there is a hardcoded variable "serverPath" containing the server and path to where to exactly upload the files.
 Syntax is: USERNAME@SERVER_ADDRESS:PATH, e.g. "xuhrik@aisa.fi.muni.cz:/home/xuhrik/public_html".
-This variable might require appropriate changing depending on various circumstances, such as after changing the server.
-Replaces index.html on the server with index.html from your machine.
-Replaces the entire release directory on the server (including all files within recursively) with the one from your machine.