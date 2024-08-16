# Define the path to the input and output files
$FilePath = "C:\gamsync\automate\servicerecruitment1\folderquery.csv"

# Read the content of the input file
$content = Get-Content -Path $FilePath

# Initialize a variable to store processed lines
$processedLines = @()

# Flag to indicate if we have written the header
$headerWritten = $false

# Process each line in the content
foreach ($line in $content) {
    # Check if the line contains a header or if it's an empty line
    if ($line -match "^Owner,id,paths,path\.0$") {
        # If the header has already been written, skip this line
        if ($headerWritten) {
            continue
        }
        # Write the header line to the processed lines
        $processedLines += $line
        $headerWritten = $true
    }
    else {
        # Add non-header lines to the processed lines
        $processedLines += $line
    }
}

# Write the processed content to the output file
$processedLines | Out-File -FilePath $FilePath -Encoding UTF8

Write-Output "File has been cleaned and saved to $outputFilePath"
