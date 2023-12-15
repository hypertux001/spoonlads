# Ensure HtmlAgilityPack is installed
# Install-Package HtmlAgilityPack - if not already installed

Add-Type -Path "..\html\HtmlAgilityPack.dll"

# Fetch the webpage content
$url = "https://www.jdwetherspoon.com/pubs/all-pubs"
$response = Invoke-WebRequest -Uri $url

# Load the HTML content with HtmlAgilityPack
$doc = New-Object HtmlAgilityPack.HtmlDocument
$doc.LoadHtml($response.Content)

# Extract facility data
$facilities = @()
$facilityElements = $doc.DocumentNode.SelectNodes("//input[contains(@class, 'js-facilities')]")
foreach ($element in $facilityElements) {
    $value = $element.Attributes['value'].Value
    $label = $doc.DocumentNode.SelectSingleNode("//label[@for='checkbox_$value']").InnerText
    $facilities += @{ Value = $value; Label = $label }
}

# Convert the extracted data to JSON
$facilities | ConvertTo-Json -Depth 100
