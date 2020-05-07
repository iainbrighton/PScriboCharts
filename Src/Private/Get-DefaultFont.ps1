function Get-DefaultFont
{
    [CmdletBinding()]
    [OutputType([System.Drawing.Font])]
    param ( )
    process
    {
        $font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList @('Segoe UI', '9', [System.Drawing.FontStyle]::Regular)
        return $font
    }
}
