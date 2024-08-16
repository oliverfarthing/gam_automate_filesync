# Define paths to your CSV files
$csv1Path = "C:\gamsync\automate\servicerecruitment1\filequery.csv"
$csv2Path = "C:\gamsync\automate\servicerecruitment1\filevalidator.csv"

# Import CSV files into arrays of objects (hashtables)
$csv1 = Import-Csv $csv1Path | ForEach-Object { $_ }
$csv2 = Import-Csv $csv2Path | ForEach-Object { $_ }

# Define the columns to match in each CSV file
$csv1MatchColumn = 'newname'
$csv2MatchColumn = 'name'

# Get an array of values from the match column in csv2
$csv2Values = @($csv2 | ForEach-Object { $_.$csv2MatchColumn })

# Initialize an empty array to hold filtered rows from csv1
$filteredCsv1 = @()

# Loop through csv1 and only add rows where the match column value does not exist in csv2
foreach ($row in $csv1) {
    if ($csv2Values -notcontains $row.$csv1MatchColumn) {
        $filteredCsv1 += $row
    }
}

# Export the filtered results to a new CSV file
$filteredCsv1 | Export-Csv $csv1Path -NoTypeInformation

# Define the path to the input and output files
$FilePath = "C:\gamsync\automate\servicerecruitment1\filequery.csv"

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

Write-Output "File has been cleaned and saved"
