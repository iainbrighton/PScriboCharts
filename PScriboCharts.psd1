@{
    RootModule = 'PScriboCharts.psm1'
    ModuleVersion = '0.9.0'
    GUID = 'c513769a-670c-4f23-a811-25bc7bd27fe6'
    Author = 'Iain Brighton'
    CompanyName = 'Virtual Engine'
    Copyright = '(c) 2017 Iain Brighton. All rights reserved.'
    Description = 'Powershell Charting module/framework.'
    PowerShellVersion = '3.0'
    FunctionsToExport = @(
                            'Add-AreaChartSeries',
                            'Add-BarChartSeries',
                            'Add-ChartArea',
                            'Add-ChartAnnotation',
                            'Add-ChartLegend',
                            'Add-ChartTitle',
                            'Add-ColumnChartSeries',
                            'Add-DoughnutChartSeries',
                            'Add-LineChartSeries',
                            'Add-PieChartSeries',
                            'Add-SplineChartSeries',
                            'Add-SplineAreaChartSeries',
                            'Add-StackedAreaChartSeries',
                            'Add-StackedBarChartSeries',
                            'Add-StackedColumnChartSeries',
                            'Export-Chart'
                            'New-Chart',
                            'New-ChartFont'
                        )
    PrivateData = @{
        PSData = @{
            Tags = @('Powershell','PScribo','Chart','Charts','Charting','Framework','VirtualEngine','Windows','PSEdition_Desktop','PSEdition_Core')
            LicenseUri = 'https://raw.githubusercontent.com/iainbrighton/PScriboCharts/master/LICENSE'
            ProjectUri = 'http://github.com/iainbrighton/PScriboCharts'
            # IconUri = '';
        }
    }
}
