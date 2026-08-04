print("[SCRIPT STARTED]");
run("Close All");

z = 5; // z-slice to save

setBatchMode(true);

path = getDirectory("Choose a Directory");
files = getFileList(path);

for (i = 0; i < files.length; i++) {
	print("**************************************");
	action(path, files[i]);
}

setBatchMode(false);
print("[SCRIPT FINISHED]");

function action(path, file) {

	// Skip directories
	if (File.isDirectory(path + file))
		return;

	print("Opening: " + file);

	open(path + file);

	// Get image dimensions
	getDimensions(width, height, channels, slices, frames);

	// Check if requested z exists
	if (z > slices) {
		print("Skipping " + file + " - only " + slices + " slices");
		run("Close All");
		return;
	}

	// Select desired z-slice
	Stack.setSlice(z);

	// Duplicate only current slice
	run("Duplicate...", "title=temp");

	// Remove extension from filename
	dot = lastIndexOf(file, ".");
	if (dot != -1)
		base = substring(file, 0, dot);
	else
		base = file;

	// Save
	saveAs("Tiff", path + base + "_z" + z + ".tif");

	run("Close All");
}