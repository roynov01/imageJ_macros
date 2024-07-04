COLORS = newArray("Green", "Red", "Green", "Grays"); // color order
DAPI = "Blue"; // color of last channel
Z_MIN = 5; // minimal stack to consider in Z max-projection
Z_MAX = 18; // maximal stack to consider in Z max-projection


run("Close All");
setBatchMode(true);	
run("Bio-Formats Macro Extensions");

//path = File.openDialog("Choose a File"); 
//filename = File.getNameWithoutExtension(path);

print("[SCRIPT STARTED]");
run("Close All");
setBatchMode(true);	

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


files = getFileList(path);
for(i=0; i<files.length; i++) {		
	print("**************************************");
	action(path,files[i],output);
}

print("[FINISHED]");


function action(path,file, output){
if (endsWith(file, "nd2") == true){
	print("Openening: "+file+". Please be patient." );
	run("Bio-Formats Importer", "open=[" + path + file + "]autoscale open_all_series color_mode=Default view=Hyperstack stack_order=XYCZT");
	}

for (i=0;i<nImages;i++) {
    selectImage(i+1);
    
    // Recolor channels
    Stack.setDisplayMode("color");
    _ = Stack.getDimensions(width, height, nChannels, slices, frames);
    for (c=1; c<=nChannels; c++) {
        Stack.setChannel(c);
        run("Enhance Contrast", "saturated=0.35");
        if (c < COLORS.length) {
            run(COLORS[c-1]); 
        } else {
            run(DAPI);
        }
    }
    Stack.setDisplayMode("composite");
    activeChannels = "";
    for (c=1; c<=nChannels; c++) {
        activeChannels = activeChannels + "1";
    }
    Stack.setActiveChannels(activeChannels);
    
    // export image and Z projection
    cleanFile = replace(file, ".nd2", "");
    saveAs("tiff", output + cleanFile + "_" + i+1);
    run("Z Project...", "start=Z_MIN stop=Z_MAX projection=[Max Intensity]");
    saveAs("tiff", output + cleanFile + "_" + i+1 + "_MAXI");
    print("saved: " + output + cleanFile + "_" + i+1);
    close();
}
run("Close All");
}


