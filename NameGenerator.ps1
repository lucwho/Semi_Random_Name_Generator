#Installer
foreach ($txt in "Firstname.txt","Surname.txt","used.txt","usedFull.txt","possibleFull.txt"){
    if (!(Test-Path -Path $txt)){
        New-Item -Path $txt -ErrorAction SilentlyContinue | Out-Null
        Write-Host "$txt created" -ForegroundColor Green
    }
}

# Global Variables 
$Firstname=Get-Content -path "Firstname.txt"
$Surname=Get-Content -path "Surname.txt"
$Used=Get-Content -Path "used.txt"
$UsedFull=Get-Content -Path "usedFull.txt"
$PossibleFull=Get-Content -Path "possibleFull.txt"
#Create all possible Name combinations
function CreatePF{
    $Result = [System.Windows.Forms.MessageBox]::Show("Generate PossibleFull.txt?`nThe Generation can take a while.","Generate PossibleFull.txt",4,"Information")
    if ($Result -eq "Yes") {
        $Firstname=Get-Content -path "Firstname.txt"
        $Surname=Get-Content -path "Surname.txt"
        $i=0
        Clear-Content -Path "possibleFull.txt"
        foreach ($v in $Firstname){
            foreach ($n in $Surname){
                $i++
                Write-Progress -Activity "Creating Possible Name Combinations..." -PercentComplete (($i*100)/($Firstname.length*$Surname.Length)) -Status "Name: $v $n"
                Add-Content -path "possibleFull.txt" "$v $n"
            }
        }
        $PossibleFull=Get-Content -Path "possibleFull.txt"
    }
}

#Create a list of items, which differ from the already used firstname list
function diffV {
    $diffV= $Firstname | Where {$Used -notcontains $_}
    return $diffV
}

#Create a list of items, which differ from the already used Fullname list
function diffF{
    $diffF= $PossibleFull | Where {$UsedFull -notcontains $_}
    return $diffF
}

#Get Random not used firstname
function Firstname{
    $Used=Get-Content -Path "used.txt"
    $diffFirstname = diffV
    if ($diffFirstname.length -eq 0){
            [System.Windows.Forms.MessageBox]::Show( "All Firstnames have been used ", "Script completed", "OK", "Warning" )
            return
        }
        else {
            $genName = Get-Random -InputObject $diffFirstname
        }
    Add-Content -Path "used.txt" "$genName"
    $TextBox_Created.Text=$genName
    #write-Host "`n$genName`n" -ForegroundColor "DarkYellow"
}

#Get Random not used full name
function Fullname{
    $UsedFull=Get-Content -Path "usedFull.txt"
    $diffFull= diffF
    if ($diffFull.length -eq 0){            
        [System.Windows.Forms.MessageBox]::Show( "All Fullnames have been used ", "Script completed", "OK", "Warning" )
        return
    }
    else{
        $genName = Get-Random -InputObject $diffFull
    }
    Add-Content -Path "usedFull.txt" "$genName"
    $TextBox_Created.Text=$genName
    #write-Host "`n$genName`n"  -ForegroundColor "DarkYellow"
}
#Function to Edit the Surname and Firstname Files
function editLists{
    
    $edit_Form=New-Object System.Windows.Forms.Form
    $edit_Form.Text ='Semi Random Name Generator'
    $edit_Form.Width = 400
    $edit_Form.Height = 600
    $edit_Form.AutoSize = $true

    $ComboBox_List = New-Object system.Windows.Forms.ComboBox
    $ComboBox_List.text = ""
    $ComboBox_List.width = 100
    $ComboBox_List.autosize = $true
    @("Firstname.txt", "Surname.txt") | ForEach-Object {[void] $ComboBox_List.Items.Add($_)}
    # Select the default value
    $ComboBox_List.SelectedIndex = 0
    $ComboBox_List.location = New-Object System.Drawing.Point(10,10)
    $edit_Form.Controls.Add($ComboBox_List)

    $TextBox_List = New-Object System.Windows.Forms.TextBox
    $TextBox_List.Text = ""
    $TextBox_List.Enabled=$true
    $TextBox_List.AcceptsReturn=$true
    $TextBox_List.Multiline = $true
    $TextBox_List.ScrollBars = "Vertical"
    $TextBox_List.Location  = New-Object System.Drawing.Size(20,50)
    $TextBox_List.Size =  New-Object System.Drawing.Size(480,580)
    $TextBox_List.AutoSize = $true
    $edit_Form.Controls.Add($TextBox_List)

    $Button_Save = New-Object System.Windows.Forms.Button
    $Button_Save.Location = New-Object System.Drawing.Size(240,10)
    $Button_Save.Size = New-Object System.Drawing.Size(100,23)
    $Button_Save.Text = "Save"
    $edit_Form.Controls.Add($Button_Save)

    $Button_Cancel = New-Object System.Windows.Forms.Button
    $Button_Cancel.Location = New-Object System.Drawing.Size(360,10)
    $Button_Cancel.Size = New-Object System.Drawing.Size(100,23)
    $Button_Cancel.Text = "Cancel"
    $edit_Form.Controls.Add($Button_Cancel)

    $Button_Open = New-Object System.Windows.Forms.Button
    $Button_Open.Location = New-Object System.Drawing.Size(120,10)
    $Button_Open.Size = New-Object System.Drawing.Size(100,23)
    $Button_Open.Text = "Open"
    $edit_Form.Controls.Add($Button_Open)

    $Button_Open.Add_Click{$TextBox_List.Lines=Get-Content -Path $ComboBox_List.SelectedItem}
    $Button_Save.Add_Click{Clear-Content -path $ComboBox_List.selectedItem; Add-Content -Path $ComboBox_List.selectedItem $TextBox_List.Text;[System.Windows.Forms.MessageBox]::Show( "Saved successfully!", "Script completed", "OK", "Information" )}
    $Button_Cancel.Add_Click{$edit_form.Close()}    
    
    $edit_Form.ShowDialog()

}

 
#GUI
Add-Type -AssemblyName System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='Semi Random Name Generator'
$main_form.Width = 600
$main_form.Height = 200
$main_form.AutoSize = $true

$Label_CreatedName = New-Object System.Windows.Forms.Label
$Label_CreatedName.Text = "Created Name:"
$Label_CreatedName.Location  = New-Object System.Drawing.Point(0,40)
$Label_CreatedName.AutoSize = $true
$main_form.Controls.Add($Label_CreatedName)

$TextBox_Created = New-Object System.Windows.Forms.TextBox
$TextBox_Created.Text = ""
$TextBox_Created.Enabled=$true
$TextBox_Created.Location  = New-Object System.Drawing.Point(100,40)
$TextBox_Created.AutoSize = $true
$main_form.Controls.Add($TextBox_Created)

$Button_Firstname = New-Object System.Windows.Forms.Button
$Button_Firstname.Location = New-Object System.Drawing.Size(400,10)
$Button_Firstname.Size = New-Object System.Drawing.Size(200,23)
$Button_Firstname.Text = "Pick Not Used Firstname"
$main_form.Controls.Add($Button_Firstname)

$Button_FullName = New-Object System.Windows.Forms.Button
$Button_FullName.Location = New-Object System.Drawing.Size(400,40)
$Button_FullName.Size = New-Object System.Drawing.Size(200,23)
$Button_FullName.Text = "Pick Not Used Fullname"
$main_form.Controls.Add($Button_FullName)

$Button_Exit = New-Object System.Windows.Forms.Button
$Button_Exit.Location = New-Object System.Drawing.Size(480,177)
$Button_Exit.Size = New-Object System.Drawing.Size(120,23)
$Button_Exit.Text = "Exit"
$main_form.Controls.Add($Button_Exit)

$Button_Firstname.add_click{Firstname}
$Button_Fullname.add_click{Fullname}
$Button_Exit.add_click{$main_form.Close()}

$menuMain = New-Object System.Windows.Forms.MenuStrip
$mainToolStrip = New-Object System.Windows.Forms.ToolStrip
$menuFile = New-Object System.Windows.Forms.ToolStripMenuItem
$menuExit = New-Object System.Windows.Forms.ToolStripMenuItem
$menuLists = New-Object System.Windows.Forms.ToolStripMenuItem
$main_form.MainMenuStrip = $menuMain
$main_form.Controls.Add($menuMain)
# Show Menu Bar
[void]$main_Form.Controls.Add($menuMain)
# Menu: File
$menuFile.Text = "File"
[void]$menuMain.Items.Add($menuFile)

# Menu: File -> Open
$menuLists.Text = "Edit Lists"
$menuLists.Add_Click({editLists;CreatePF})
[void]$menuFile.DropDownItems.Add($menuLists)
# Menu: File -> Save
$menuExit.Text = "Exit"
$menuExit.Add_Click({$main_form.Close()})
[void]$menuFile.DropDownItems.Add($menuExit)
# Menu: File -> Exit
#{[System.Windows.Forms.MessageBox]::Show( "This Feature will be coming soon", "Script completed", "OK", "Information" )}
CreatePF
$main_form.ShowDialog()


#Option picker
<#function Choose{
    $Choose=Read-Host -Prompt "Please pick an option`n1) Firstname`n2) First- & Surname`n0) Ende"
    
    switch ($Choose){
        1 {Firstname}
        2 {Fullname}
        0 {exit}
        default {"Ungueltig"}
     }
}

while ($true){
    Choose

    $UsedFull=Get-Content -Path "usedFull.txt"
}#>
