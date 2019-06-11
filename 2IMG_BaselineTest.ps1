# 2IMG Testing 
# Baseline Test
# Updated: 2018-02-02

# Update these variables with the paths to your directories:
#	exeDir: where the 2IMG executable is
#	testDir: where your test files are
#	outDir: where the output should appear (this directory will be created if required)
$exeDir = 
$outDir = 
$testDir = 

# --------------------------------------------------------------------------------------------------

$cmd = ".exe"

function Run-Test($outFile, $inFile, $outFormat, $parameters) {
	Write-Output "	Input:  $(Join-Path $testDir $inFile)"
	Write-Output "	Output: $(Join-Path $outDir $outFile)"
	&"$(Join-Path $exeDir $cmd)" -output="$(Join-Path $outDir $outFile)" $parameters "$(Join-Path $testDir $inFile)" "$outFormat" | Out-Null
}

Write-Output "----------------------------------"
Write-Output "Executing 2IMG Baseline Test"
Write-Output "----------------------------------"
Write-Output ""
Write-Output "Test File Directory:   $testDir"
Write-Output "---2IMG Directory:  $exeDir"
Write-Output "Output Directory:      $outDir"
Write-Output ""

If(!(Test-Path $outDir))
{
    New-Item -ItemType Directory -Force -Path $outDir | Out-Null
	Write-Output "Output directory created."
}
else
{
	Write-Output "Output directory found. Directory not created."
}
Write-Output ""

Write-Output "Test format conversion"
# "Expected result:"
 # "Convert Final-Fantasy-Adventure-Guide.pdf to jpg, png, bmp, eps, tif, raw, and gif" 
$formatList = @("jpg", "png", "bmp", "eps", "tif", "raw", "gif")
foreach ($format in $formatList)
{
	Write-Output "  Format: $format"
	Run-Test "format_conversion" "Final-Fantasy-Adventure-Guide.pdf" $format 
}
Write-Output ""

Write-Output "Test Option -asprinted and -ignorewarn"
# "Expected result:"
# "Convert Annotations.pdf to jpg and render annotations as if printing instead of viewing;
# default is not to show annotations designated for printing only. A warning that Page 1 contains
# nonrenderable annotations or form fields should be ignored"
$param = '-asprinted', '-ignorewarn'
Run-Test "convert_annotations" "Annotations.pdf" "jpg" $param
Write-Output ""

Write-Output "Test Option -blackisone"
#"Expected result:"
#"Convert thin_Veranda Arch Plan 1-3 floor plans.pdf to tif. Reverse intrpretation of B/W pixels" 
$param = '-blackisone'
Run-Test "blackisone" "thin_Veranda Arch Plan 1-3 floor plans.pdf" "tif"
Write-Output ""

Write-Output "Test Option -colormodel and -output"
# "Expected result:"
# "Convert cottage.pdf to jpg and set colormodel to gray, cmyk, rgb, rgba, and lab" 
$colorList = @("gray", "cmyk", "rgb", "rgba", "lab")
foreach ($colorModel in $colorList) {
	$param = "-colormodel=$colorModel"
	$o = "cottage_$colorModel"
	Run-Test $o "cottage.pdf" "jpg" $param
}
Write-Output ""

Write-Output "Test Option -digits"
# "Expected result:"
# "Convert duckyquadtone.pdf to bmp, and add digits (7) to the output filename"
$param = "-digits=7"
Run-Test "add_digits_filename" "duckyquadtone.pdf" "bmp" $param
Write-Output ""

Write-Output "Test Option -ignoredefaultfonts and -output"
# "Expected result:"
# "Convert Italic_Emulation.pdf to jpg, and do not scan the current directory or default location for fonts"
$param = "-ignoredefaultfonts"
Run-Test "Italic_Emulation_NoFonts" "Italic_Emulation.pdf" "jpg" $param
Run-Test "Italic_Emulation_WithFonts" "Italic_Emulation.pdf" "jpg"
Write-Output ""

Write-Output "Test Option -jpegquality and -output"
# "Expected result:"
# "Convert ImageOnly_ducky.pdf to jpg, and set jpegquality to 10 and 100"
$param = "-jpegquality=10"
Run-Test "ImageOnly_ducky_10" "ImageOnly_ducky.pdf" "jpg" $param
$param = "-jpegquality=100"
Run-Test "ImageOnly_ducky_100" "ImageOnly_ducky.pdf" "jpg" $param
Write-Output ""

Write-Output "Test Option -noannot and -output"
# "Expected result:"
# "Convert Annotations.pdf to png and suppress displayable annots." 
$param = "-noannot"
Run-Test "Annotations_noannot" "Annotations.pdf" "png" $param
Write-Output ""

Write-Output "Test Option -password"
# "Expected result:"
# "Use password to open Encrypted.pdf and convert jpg."
$param = "-password=mypassword"
Run-Test "convert_encrypted" "Encrypted.pdf" "jpg" $param
Write-Output ""

Write-Output "Test Option -pdfregion and -output"
# "Expected result:"
# "Convert trans_1page.pdf to jpg and set pdfregion."
$param = "-pdfregion=crop"
Run-Test "trans_1page_crop" "trans_1page.pdf" "jpg" $param
$param = "-pdfregion=art" 
Run-Test "trans_1page_art" "trans_1page.pdf" "jpg" $param
Write-Output ""

Write-Output "Test Option -pixelcount"
# "Expected result:"
# "Convert cottage.pdf to jpg and set pixelcount."
$param = "-pixelcount=100x100"
Run-Test "cottage_pixelcount" "cottage.pdf" "jpg" $param
Write-Output ""

Write-Output "Test Option -resolution, -output, and -firstonly"
# "Expected result:"
# "Convert first page of constitution.pdf to jpg and set resolution."
$resList = @("100", "500", "1000", "2000")
foreach($resolution in $resList) {
	$param = "-resolution=$resolution", "-firstonly"
	$o = "constitution_resolution_$resolution"
	Run-Test $o "constitution.pdf" "jpg" $param
}
Write-Output ""

Write-Output "Test SF40825 - (Ziflow) Rasterization error when converting customer document to tif using -pixelcount"
# "Expected result:"
# "PDF is converted without errors"
$param = "-pixelcount=10273x15410"
Run-Test "SF40825" "shoes.pdf" "tif" $param
Write-Output ""
