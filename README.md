[![Build status](https://ci.appveyor.com/api/projects/status/ckqhlepsa0hh345s?svg=true)](https://ci.appveyor.com/project/iainbrighton/pscribocharts)
![Platforms](https://img.shields.io/powershellgallery/p/PScriboCharts.svg)
![Version](https://img.shields.io/powershellgallery/v/PScriboCharts.svg)
![Downloads](https://img.shields.io/powershellgallery/dt/PScriboCharts.svg)

# PScribo Charts (Preview) #

_PScribo_ (pronounced 'skree-bo') _Charts_ is an open source project that provides a PowerShell facade over the
`[System.Windows.Forms.DataVisualization.Charting]` .NET library. PScribo Charts provides a set of functions for
authoring charts and graphs in Windows PowerShell for use in documentation and/or web pages, e.g. with
[PScribo](http://github.com/iainbrighton/PScribo).

Due to its reliance on the `[System.Windows.Forms.DataVisualization.Charting]` namespace, this module only works on Microsoft Windows devices. However, both Windows PowerShell and PowerShell (Core) are supported on Microsoft Windows.

Requires __Powershell 3.0__ or later.

## Authoring Example ##

The following example creates a line chart of the highest 10 process WorkingSet properties and exports a .PNG file to the desktop.

```powershell
Import-Module PScriboCharts

$sampleData = Get-Process | Sort-Object -Property WS -Descending | Select-Object -First 10
$exampleChart = New-Chart -Name Example1 -Width 600 -Height 600
$addChartSeriesParams = @{
    Chart     = $exampleChart
    ChartArea = Add-ChartArea -Chart $exampleChart -Name exampleChartArea -PassThru
    Name      = 'exampleChartSeries'
    XField    = 'ProcessName'
    YField    = 'WS'
}
$sampleData | Add-LineChartSeries @addChartSeriesParams
Export-Chart -Chart $exampleChart -Path ~\Desktop -Format PNG -PassThru
```

## Installation ##

* Automatic (via PowerShell Gallery):
  * Run 'Install-Module PScriboCharts'
  * Run 'Import-Module PScriboCharts'
* Manual:
  * Download and unblock the latest .zip file.
  * Extract the .zip into your $PSModulePath, e.g. ~\Documents\WindowsPowerShell\Modules\
  * Ensure the extracted folder is named 'PScriboCharts'
  * Run 'Import-Module PScriboCharts'

If you find it useful, unearth any bugs or have any suggestions for improvements,
feel free to add an [issue](https://github.com/iainbrighton/PScriboCharts/issues) or
place a comment at the project home page.
