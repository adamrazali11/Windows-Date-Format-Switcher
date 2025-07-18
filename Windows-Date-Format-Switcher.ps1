Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Date Format Switcher"
$form.Size = New-Object System.Drawing.Size(500, 440)
$form.StartPosition = "CenterScreen"
$form.Topmost = $true

# today's date
$today = Get-Date
$irsDate = $today.ToString("dd/MMM/yyyy")
$sqlDate = $today.ToString("d/M/yyyy")

# label - instruction
$label = New-Object System.Windows.Forms.Label
$label.Text = "Select your preferred short date format:"
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(30, 30)
$form.Controls.Add($label)

# example display
$exampleLabel = New-Object System.Windows.Forms.Label
$exampleLabel.Text = "Option 1: $irsDate    |    Option 2: $sqlDate"
$exampleLabel.AutoSize = $true
$exampleLabel.Location = New-Object System.Drawing.Point(30, 55)
$form.Controls.Add($exampleLabel)

# Option 1 button
$btnIRS = New-Object System.Windows.Forms.Button
$btnIRS.Text = "Use Option 1"
$btnIRS.Size = New-Object System.Drawing.Size(140,40)
$btnIRS.Location = New-Object System.Drawing.Point(40, 100)
$btnIRS.Add_Click({
    Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name "sShortDate" -Value "dd/MMM/yyyy"
    Stop-Process -Name explorer -Force
    Start-Process explorer
    [System.Windows.Forms.MessageBox]::Show("Switched to ($irsDate)","Success")
})
$form.Controls.Add($btnIRS)

# Option 2 button
$btnSQL = New-Object System.Windows.Forms.Button
$btnSQL.Text = "Use Option 2"
$btnSQL.Size = New-Object System.Drawing.Size(140,40)
$btnSQL.Location = New-Object System.Drawing.Point(200, 100)
$btnSQL.Add_Click({
    Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name "sShortDate" -Value "d/M/yyyy"
    Stop-Process -Name explorer -Force
    Start-Process explorer
    [System.Windows.Forms.MessageBox]::Show("Switched to ($sqlDate)","Success")
})
$form.Controls.Add($btnSQL)

# label - other formats
$otherLabel = New-Object System.Windows.Forms.Label
$otherLabel.Text = "Other Common Formats:"
$otherLabel.AutoSize = $true
$otherLabel.Location = New-Object System.Drawing.Point(30, 160)
$form.Controls.Add($otherLabel)

# helper function to add button + example label (vertically stacked)
function Add-DateFormatButtonWithExample {
    param (
        [string]$text,
        [string]$formatString,
        [int]$y
    )

    $exampleText = $today.ToString($formatString)

    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Size = New-Object System.Drawing.Size(140, 35)
    $btn.Location = New-Object System.Drawing.Point(40, $y)
    $btn.Tag = $formatString
    $btn.Add_Click({
        $fmt = $this.Tag
        Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name "sShortDate" -Value $fmt
        Stop-Process -Name explorer -Force
        Start-Process explorer
        [System.Windows.Forms.MessageBox]::Show("Switched to $($this.Text) format ($fmt)","Success")
    })
    $form.Controls.Add($btn)

    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = "→ $exampleText"
    $lbl.AutoSize = $true
    $lbl.Location = New-Object System.Drawing.Point(200, ($y + 8))
    $lbl.ForeColor = "Gray"
    $form.Controls.Add($lbl)
}

# add formats vertically
Add-DateFormatButtonWithExample "US Style"     "MM/dd/yyyy"     190
Add-DateFormatButtonWithExample "ISO 8601"     "yyyy-MM-dd"     230
Add-DateFormatButtonWithExample "Dotted"       "dd.MM.yyyy"     270
Add-DateFormatButtonWithExample "Full Month"   "dd MMMM yyyy"   310

# credit label
$credit = New-Object System.Windows.Forms.Label
$credit.Text = "Developed by @adamrazali11"
$credit.Font = New-Object System.Drawing.Font("Segoe UI",8,[System.Drawing.FontStyle]::Italic)
$credit.AutoSize = $true
$credit.ForeColor = "Blue"
$credit.Cursor = [System.Windows.Forms.Cursors]::Hand
$credit.Location = New-Object System.Drawing.Point(30, 380)
$credit.Add_Click({
    Start-Process "https://github.com/adamrazali11"
})
$form.Controls.Add($credit)

$form.Add_Shown({$form.Activate()})
[void]$form.ShowDialog()
