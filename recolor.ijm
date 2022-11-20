print("[SCRIPT STARTED]");
run("Close All");
setBatchMode(true);	
path = getDirectory("Choose a Directory");
files = getFileList(path);
for(i=0; i<files.length; i++) {		
	print("**************************************");
	action(path,files[i]);
}


function action(path,file){
	print("Openening: "+file);	
	run("Bio-Formats Importer", "open=[" + path + file + "]autoscale open_all_series color_mode=Default view=Hyperstack stack_order=XYCZT");
	Stack.setChannel(1);
	run("Enhance Contrast", "saturated=0.35");
	run("Green");
	Stack.setChannel(2);
	run("Enhance Contrast", "saturated=0.35");
	run("Red");
	Stack.setChannel(3);
	//run("Enhance Contrast", "saturated=0.35");
	//run("Yellow");
	//Stack.setChannel(4);
	run("Grays");
	run("Enhance Contrast", "saturated=0.35");
	resetMinAndMax();
	Stack.setChannel(4);
	run("Enhance Contrast", "saturated=0.35");
	run("Blue");
	saveAs("tiff", path + file);
	run("Close All");
}
print("FINISHED");