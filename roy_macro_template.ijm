// Initialize, setup and show dialog window
dir_path = getDirectory("Choose the input directory");
//dir_path = "";
out_path = getDirectory("Choose the output directory");
//out_path = "";

Dialog.create("Options"); 
par_1 = Dialog.addNumber("parameter 1", 100);
par_2 = Dialog.addNumber("parameter 2", true);
Dialog.show();
par_1 = Dialog.getNumber();
par_2 = Dialog.getNumber();

print("[STARTED]");
close_all();
setBatchMode(true);	// newly opened images are not displayed. 20x times faster.


files = getFileList(dir_path);

// Process all images
for (i = 0; i < files.length; i++) {
	file = files[i]
	// Open image:
	open(dir_path + file);
	image_name = getTitle();
	print("[PROCESSING] " + image_name);
	
	if (endsWith(image_name, "tif") == true){
		action(file);
		saveAs("Tiff", output + "processed_" + file);
	}
	clear();
}
print("[FINISHED]");

function action(file){
	...
}

function clear(){
	// Clean display image if needed:
	//run("Remove Overlay");
	//run("Select None");
	// Clear ROI manager and Results
	
	roiManager("Deselect");
	roiManager("Delete");
	run("Clear Results");
	
	run("Close All"); // close images
}

function close_all { 
	while (nImages>0) { 
		selectImage(nImages); 
		close();
	}
	if (isOpen("Log")) {
		selectWindow("Log"); run("Close");
	} 
	if (isOpen("Summary")) {
		selectWindow("Summary"); run("Close");
	} 
	if (isOpen("Results")) {
		selectWindow("Results"); run("Close");
	}
	if (isOpen("ROI Manager")) {
		selectWindow("ROI Manager"); run("Close");
	}	
} 
