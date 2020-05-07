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
        Select-Object -First 10

$exampleChart = New-Chart -Name Example8 -Width 600 -Height 600

$addChartAreaParams = @{
    Chart                 = $exampleChart
    Name                  = 'exampleChartArea'
    AxisXTitle            = 'Process Name'
    AxisYTitle            = 'Working Set'
    NoAxisXMajorGridLines = $true
    NoAxisYMajorGridLines = $true
}
$exampleChartArea = Add-ChartArea @addChartAreaParams -PassThru

<#
    In addition to the built-in color palettes, you can also define your own custom palette by creating an array
    of [System.Drawing.Color[]] colors and applying it to a series using the 'CustomPalette' parameter.

    When creating custom palettes you can use a tool like https://learnui.design/tools/data-color-picker.html to
    generate professional looking charts.
#>
$exampleCustomPalette = @(
    [System.Drawing.ColorTranslator]::FromHtml('#6741D9')
    [System.Drawing.ColorTranslator]::FromHtml('#9C36B5')
    [System.Drawing.ColorTranslator]::FromHtml('#C2255C')
    [System.Drawing.ColorTranslator]::FromHtml('#E03130')
    [System.Drawing.ColorTranslator]::FromHtml('#E8580B')
    [System.Drawing.ColorTranslator]::FromHtml('#F08C00')
    [System.Drawing.ColorTranslator]::FromHtml('#2F9E44')
    [System.Drawing.ColorTranslator]::FromHtml('#1B6EC2')
    [System.Drawing.ColorTranslator]::FromHtml('#343A40')
)
$addChartSeriesParams = @{
    Chart             = $exampleChart
    ChartArea         = $exampleChartArea
    Name              = 'exampleChartSeries'
    XField            = 'ProcessName'
    YField            = 'WS'
    Label             = ''
    ColorPerDataPoint = $true
    CustomPalette     = $exampleCustomPalette
}
$sampleData | Add-ColumnChartSeries @addChartSeriesParams

$chartFileItem = Export-Chart -Chart $exampleChart -Path $Path -Format $Format -PassThru

if ($PassThru)
{
    Write-Output -InputObject $chartFileItem
}
