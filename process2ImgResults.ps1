# PDF2IMG Testing 
# Process Baseline Test Results
# Updated: 2018-02-06

# This script will use ImageMagick to check the results of 2IMG_BaselineTest.
# baselinePath should point at where the known good results are.
# outputPath should point at where the results for the current test are.
# checkOut should point to an empty folder - this is where various jpgs produced by the compare tool are dropped.
#		 These images can be viewed to see which parts of the image are incorrect.
# comMet is the comparison metric to use. AE = absolute error, the number of different pixels. More information here: http://www.imagemagick.org/script/command-line-options.php#metric
# fuzz prevents the comparison from failing if the color of the pixels are only slightly off. Set to 0 to require exact matches. More info at the above link.

# Update these variables with the paths to your directories:
#	baselinePath: where the 2IMG baseline comparison images are
#	checkOut: where imagemagick should place produced image heatmaps
#	outDir: where the output should appear (this directory will be created if required)
$baselinePath=
$checkOut=
$outDir =

$comMet="AE"  #comparison metric
$fuzz="5%"

# --------------------------------------------------------------------------------------------------

# This executes most of the compares. Usage:
#	Compare-Results Test_Name File_Name Parameters
#	Parameters are optional
function Compare-Results($test, $file, $parameters) {
	$var = & magick compare -metric $comMet -fuzz $fuzz $parameters "$(Join-Path $baselinePath $file)" "$(Join-Path $outDir $file)" "$(Join-Path $checkOut $test)"".jpg" 2>&1
	# Write-Output "	Test: $test"
	# Write-Output "	File: $file"
	# Write-Output "$var"
	if ($var.ToString() -eq 0){
		"        {0, -33} {1,6}" -f $test, "Passed"
	}
	else {
		"        {0, -33} {1,6}" -f $test, "FAILED"
	}
}

Write-Output ""
Write-Output "-------------------------------------------"
Write-Output "Processing 2IMG Baseline Test Results"
Write-Output "-------------------------------------------"
Write-Output ""
Write-Output "Baseline Image Directory:  $baselinePath"
Write-Output "Output Directory:          $outDir"
Write-Output "Processed Files Directory: $checkOut"
Write-Output ""

#if output directory doesn't exist, create it
If(!(Test-Path $outDir))
{
    New-Item -ItemType Directory -Force -Path $outDir | Out-Null
	Write-Output "Output directory created at:"
	Write-Output "     $outDir"
}
else
{
	Write-Output "Output directory found. Directory not created."
}
Write-Output ""

#if processed output directory (checkOut) doesn't exist, create it
If(!(Test-Path $checkOut))
{
    New-Item -ItemType Directory -Force -Path $checkOut | Out-Null
	Write-Output "Processed files directory created at:"
	Write-Output "     $checkOut"
}
else
{
	Write-Output "Directory for processed files found. Directory not created."
}
Write-Output ""

Write-Output "Test: Format conversion"
$formatList = @("jpg", "gif", "png", "tif", "bmp")
# eps has an issue
for ($i=1; $i -lt 5; $i++){
	foreach ($format in $formatList){
		Compare-Results "format_conversion_$i-$format" "format_conversion_$i.$format"
	}
}
Write-Output ""

Write-Output "Test: Convert annotations"
Compare-Results "convert_annotations" "convert_annotations_1.jpg"
Write-Output ""

Write-Output "Test: Blackisone"
for ($i=1; $i -lt 7; $i++) {
	Compare-Results "blackisone_$i-tif"  "blackisone_$i.tif"
}
Write-Output ""

Write-Output "Test: Color model"
$colorModel = @("cmyk", "gray", "lab", "rgb", "rgba")
foreach ($model in $colorModel) {
	Compare-Results "colormodel-$model" "cottage_$($model)_1.jpg"
}
Write-Output ""

Write-Output "Test: Add digits"
$var = "$(Join-Path $outDir add_digits_filename0000001.bmp)"
If (Test-Path $var){
	"        {0, -33} {1,6}" -f "add_digits_filename0000001.bmp", "Passed"
}
else {
	"        {0, -33} {1,6}" -f "add_digits_filename0000001.bmp", "FAILED"
}
Write-Output ""

Write-Output "Test: Ignore default fonts"
$fontOptions = @("NoFonts", "WithFonts")
foreach ($font in $fontOptions){
	Compare-Results "ignore_default_fonts-$font" "Italic_Emulation_$($font)_1.jpg"
}
Write-Output ""

Write-Output "Test: Jpeg quality"
$jpegQual = @("100", "10")
foreach ($qual in $jpegQual){
	Compare-Results "jpeg_qual-$qual" "ImageOnly_ducky_$($qual)_1.jpg"
}
Write-Output ""

Write-Output "Test: No annotations"
Compare-Results "Annotations_noannot_1.png" "Annotations_noannot_1.png"
Write-Output ""

Write-Output "Test: Convert encrypted"
for ($i=1; $i -lt 4; $i++){
	Compare-Results "convert_encrypted-$i" "convert_encrypted_$($i).jpg"
}
Write-Output ""

Write-Output "Test: PDF region"
$regionOptions = @("art", "crop")
foreach ($region in $regionOptions) {
	Compare-Results "pdf_region-$region" "trans_1page_$($region)_1.jpg"
}
Write-Output ""

Write-Output "Test: Pixel count"
$file="cottage_pixelcount_1.jpg"
$var = & magick identify -format "%[fx:w*h]" $(Join-Path $outDir $file) 2>&1
if ($var.ToString() -eq 10000){
	"        {0, -33} {1,6}" -f $file, "Passed"
}
else {
	"        {0, -33} {1,6}" -f $file, "FAILED"
}
Write-Output ""

Write-Output "Test: Resolution"
$resolutionList = @(100, 500, 1000, 2000)
foreach ($res in $resolutionList){
	$test="constitution_resolution_$($res)"
	$file="constitution_resolution_$($res)_01.jpg"
	$var = & magick identify -format "%x x %y" $(Join-Path $outDir $file) 2>&1
	$compString = "$res x $res"
	if ($var.ToString() -eq $compString){
		"        {0, -33} {1,6}" -f $test, "Passed"
	}
	else {
		"        {0, -33} {1,6}" -f $test, "FAILED"
	}
}
Write-Output ""

Write-Output "Test: SF40825"
$file="SF40825_1.tif"
$var = & magick identify -format "%w x %h" $(Join-Path $outDir $file) 2>&1
$compString="10273 x 15410"
if ($var.ToString() -eq $compString){
	"        {0, -33} {1,6}" -f $file, "Passed"
}
else {
	"        {0, -33} {1,6}" -f $file, "FAILED"
}
Write-Output ""