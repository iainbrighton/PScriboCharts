[CmdletBinding()]
param
(
    [System.String] $Path = '~\Desktop',
    [System.Management.Automation.SwitchParameter] $PassThru,
    [System.String] $Format = 'Png'
)

Import-Module PScriboCharts -Verbose:$false

$sampleData = Get-Process |
    Sort-Object -Property WS -Descending |
        Select-Object -First 15

<#
    When two data series overlap, it is sometimes desirable to apply alhpa blending to each
    series. Here a custom palette is defined, with 50% transparency applied to allow areas
    behind to show though.
#>
$exampleCustomAlphaPalette = @(
    [System.Drawing.Color]::FromArgb(128, [System.Drawing.ColorTranslator]::FromHtml('#1B6EC2'))
    [System.Drawing.Color]::FromArgb(128, [System.Drawing.ColorTranslator]::FromHtml('#343A40'))
)
$exampleChart = New-Chart -Name Example15 -Width 600 -Height 600 -CustomPalette $exampleCustomAlphaPalette

$addChartAreaParams = @{
    Chart                 = $exampleChart
    Name                  = 'exampleChartArea'
    AxisXTitle            = 'Process Name'
    NoAxisXMajorGridLines = $true
    NoAxisYMajorGridLines = $true
}
$exampleChartArea = Add-ChartArea @addChartAreaParams -PassThru

$addChartSeriesParams = @{
    Chart             = $exampleChart
    ChartArea         = $exampleChartArea
    XField            = 'ProcessName'
    Label             = ''
}
<#
    Add the 'PM' and 'WS' proeprties as area chart series.
#>
$sampleData | Add-AreaChartSeries @addChartSeriesParams -Name 'pmSeries' -YField 'PM'
$sampleData | Add-AreaChartSeries @addChartSeriesParams -Name 'wsSeries' -YField 'WS'

$chartFileItem = Export-Chart -Chart $exampleChart -Path $Path -Format $Format -PassThru

if ($PassThru)
{
    Write-Output -InputObject $chartFileItem
}
