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

print("FINISHED");


function action(path,file, output){
if (endsWith(file, "nd2") == true){
	print("Openening: "+file+". Please be patient." );
	
	run("Bio-Formats Importer", "open=[" + path + file + "]autoscale open_all_series color_mode=Default view=Hyperstack stack_order=XYCZT");
	}
for (i=0;i<nImages;i++) {
        selectImage(i+1);
        Stack.setDisplayMode("color");
        Stack.setChannel(2);
        run("Enhance Contrast", "saturated=0.35");
        run("Green");
        Stack.setChannel(2);
        run("Enhance Contrast", "saturated=0.35");
        run("Red");
        Stack.setChannel(3);
        run("Enhance Contrast", "saturated=0.35");
        run("Grays");
        resetMinAndMax();
        Stack.setChannel(4);
        run("Enhance Contrast", "saturated=0.35");
        run("Blue");
        Stack.setDisplayMode("composite");
        Stack.setActiveChannels("1111");
        saveAs("tiff", output + file + "_" + i+1);
        run("Z Project...", "start=5 stop=18 projection=[Max Intensity]");
        saveAs("tiff", output + file + "_" + i+1 + "_MAXI");
        print("saved: " + output + file + "_" + i+1);
        close();
}
run("Close All");
}


