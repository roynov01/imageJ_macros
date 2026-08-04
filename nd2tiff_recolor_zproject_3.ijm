COLORS = newArray("Green", "Red", "Green", "Magenta","Blue"); // color order
DAPI = "Blue"; // color of last channel
Z_PROJ = 1; // run Zprojection?
Z_MIN = 5; // minimal stack to consider in Z max-projection
Z_MAX = 15; // maximal stack to consider in Z max-projection


//path = File.openDialog("Choose a File"); 
//filename = File.getNameWithoutExtension(path);

print("[SCRIPT STARTED]");
run("Close All");
setBatchMode(true);	
run("Bio-Formats Macro Extensions");

path = getDirectory("Choose a Directory");
files = getFileList(path);
output = path + "tiff_files\\"
if(!File.exists(output)){
	File.mkdir(output);
}
else {
	print("The following output folder exist already: " + output);
	output = getDirectory("Open new output directory");
	File.mkdir(output);
}
print("Processing files in directory: " + path);


files = getFileList(path);



for (i = 0; i < files.length; i++) {
    print(files[i]);
}

print("Numer of files:: " + files.length);

for(j=0; j<files.length; j++) {	
	print("**************************************");
	if (!endsWith(files[j], ".nd2") == true) {
        print("Skipping non-nd2 file: " + files[j]);
        continue; 
    }
	print("Processing file: " + files[j]);
	action(path,files[j],output);
	//run("Close All");
}

print("[FINISHED]");


function action(path, file, output) {
    print("Opening: " + file + ". Please be patient.");
    run("Bio-Formats Importer", "open=[" + path + file + "] autoscale open_all_series color_mode=Default view=Hyperstack stack_order=XYCZT");

    // Get list of open image titles
    imageTitles = getList("image.titles");
    numImages = imageTitles.length;
    print("Number of images (series) in the file: " + numImages);

    for (i = 0; i < numImages; i++) {
        imageTitle = imageTitles[i];
        selectImage(imageTitle);

        // Recolor channels
        Stack.setDisplayMode("color");
        _ = Stack.getDimensions(width, height, nChannels, slices, frames);
        print("Processing image " + (i + 1) + " - Dimensions: " + width + "x" + height + ", Channels: " + nChannels + ", Slices: " + slices + ", Frames: " + frames);

        for (c = 1; c <= nChannels; c++) {
            Stack.setChannel(c);
            run("Enhance Contrast", "saturated=0.35");
            if (c <= COLORS.length) {
                run(COLORS[c - 1]);
            } else {
                run(DAPI);
            }
        }
        Stack.setDisplayMode("composite");
        activeChannels = "";
        for (c = 1; c <= nChannels; c++) {
            activeChannels = activeChannels + "1";
        }
        Stack.setActiveChannels(activeChannels);

        // Export image
        cleanFile = replace(file, ".nd2", "");
        saveAs("tiff", output + cleanFile + "_" + (i + 1));
        print("Saved TIFF: " + output + cleanFile + "_" + (i + 1));

        // Z max projection
        if (slices > 1 && Z_PROJ == 1) {
            print("Performing Z max projection for image " + (i + 1) + ", slices: " + slices);
            run("Z Project...", "start=" + Z_MIN + " stop=" + Z_MAX + " projection=[Max Intensity]");

            // Save the Z-projection image
            saveAs("tiff", output + cleanFile + "_" + (i + 1) + "_MAXI");
            print("Saved Z max projection: " + output + cleanFile + "_" + (i + 1) + "_MAXI");

            // Close the Z-projection image
            close();
        } else {
            print("Skipping Z max projection for image " + (i + 1));
        }

        // Close the original image
        //selectImage(imageTitle);
        close();
    }
}


