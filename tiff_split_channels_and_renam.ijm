print("[SCRIPT STARTED]");
run("Close All");
setBatchMode(true);	


path = getDirectory("Choose a Directory");

output = path + "forImageM\\"
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
if (endsWith(file, "tif") == true){
	print("Openening: "+file );
	open(path + file);
	run("Split Channels");
	
	saveAs("Tiff", output + "DAPI_" + file);
	
	selectWindow("C3-"+file);
	saveAs("Tiff", output + "INS_" + file);
	//selectWindow("C3-"+file);
	//saveAs("Tiff", output + "OTHER_" + file);
	selectWindow("C2-"+file);
	saveAs("Tiff", output + "GENE_" + file);
	selectWindow("C1-"+file);
	saveAs("Tiff", output + "GFP_" + file);
	run("Close All");
	}
}
