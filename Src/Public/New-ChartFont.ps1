function New-ChartFont
{
<#
    .SYNOPSIS
        Creates a new font defintion for use in charts.
#>
    [CmdletBinding(DefaultParameterSetName = 'Palette')]
    [OutputType([System.Drawing.Font])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions','')]
    param
    (
        ## Font family name.
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.String] $Name,

        ## Font point size.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Single] $Size,

        ## Apply bold styling.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $Bold,

        ## Apply italic styling.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $Italic,

        ## Apply strike out styling.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $StrikeOut,

        ## Apply underline styling.
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $Underline
    )
    process
    {
        $fontStyle = [System.Drawing.FontStyle]::Regular
        if ($Bold)
        {
            $fontStyle = $fontStyle -bor [System.Drawing.FontStyle]::Bold
        }
        if ($Italic)
        {
            $fontStyle = $fontStyle -bor [System.Drawing.FontStyle]::Italic
        }
        if ($StrikeOut)
        {
            $fontStyle = $fontStyle -bor [System.Drawing.FontStyle]::StrikeOut
        }
        if ($Underline)
        {
            $fontStyle = $fontStyle -bor [System.Drawing.FontStyle]::Underline
        }
        return New-Object -TypeName System.Drawing.Font -ArgumentList @($Name, $Size, $fontStyle)
    }
}
