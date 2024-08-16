Start-Sleep -Seconds 2

# Define the path to the input CSV file and the output CSV file
$inputFile = "C:\gamsync\automate\servicerecruitment1\filequery.csv"
$outputFile = "C:\gamsync\automate\servicerecruitment1\filequery.csv"

# Import the CSV file
$data = Import-Csv -Path $inputFile

# Filter out rows where the 'Owner' field starts with 'owner'
$filteredData = $data | Where-Object { $_.Owner -notmatch '^owner' }

# Process each row to create the new column
$processedData = $filteredData | ForEach-Object {
    # Add a new property with the merged value
    $_ | Add-Member -MemberType NoteProperty -Name "newname" -Value ("$($_.Owner) $($_.name)") -Force
    $_  # Output the modified row
}

# Export the modified data to a new CSV file
$processedData | Export-Csv -Path $outputFile -NoTypeInformation
