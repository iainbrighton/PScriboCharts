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

$exampleChart = New-Chart -Name Example6 -Width 600 -Height 600

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
    By default, only the first color in the default (or specified) palette is used. To cycle through the color
    palette, specify the the 'ColorPerDataPoint' switch parameter.
#>
$addChartSeriesParams = @{
    Chart             = $exampleChart
    ChartArea         = $exampleChartArea
    Name              = 'exampleChartSeries'
    XField            = 'ProcessName'
    YField            = 'WS'
    Label             = ''
    ColorPerDataPoint = $true
}
$sampleData | Add-ColumnChartSeries @addChartSeriesParams

$chartFileItem = Export-Chart -Chart $exampleChart -Path $Path -Format $Format -PassThru

if ($PassThru)
{
    Write-Output -InputObject $chartFileItem
}
