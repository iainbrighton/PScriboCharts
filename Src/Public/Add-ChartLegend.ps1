function Add-ChartLegend
{
<#
    .SYNOPSIS
        Adds a legend to an existing chart object.

    .DESCRIPTION
        There can be any number of legends for a chart image. Legends can:

            Be docked and aligned.
            Be displayed inside or outside the plotted chart areas.
            Automatically fit their contents.
            Use a predefined style, such as row, column or table.
            Use hatching, gradient colors and background images.
            Be sized and positioned anywhere within the chart image.

    .LINK
        https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.datavisualization.charting.legend
#>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType([System.Windows.Forms.DataVisualization.Charting.Legend])]
    param
    (
        ## Chart object to add the chart legend
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.Windows.Forms.DataVisualization.Charting.Chart] $Chart,

        ## Internal name of the legend
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String] $Name,

        ## Chart series to render in the legend
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [OutputType([System.Windows.Forms.DataVisualization.Charting.Series[]])] $ChartSeries,

        ## Title text
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $Title = $Name,

        ## Title text alignment.
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Center', 'Near', 'Far')]
        [System.String] $TitleAlignment = 'Center',

        ## Font used within the legend
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Font] $Font = (Get-DefaultFont),

        ## The relative X-coordinate of the top-left corner of the chart element
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Position')]
        [ValidateRange(0, 100)]
        [System.Int32] $X,

        ## The relative Y-coordinate of the top-left corner of the chart element
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Position')]
        [ValidateRange(0, 100)]
        [System.Int32] $Y,

        ## The relative height of the chart element
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Position')]
        [ValidateRange(0, 100)]
        [System.Int32] $Height,

        ## The relative width of the chart element
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Position')]
        [ValidateRange(0, 100)]
        [System.Int32] $Width,

        ## Name of the ChartArea where the legend will be docked
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $DockedToChartArea,

        ## The style of the legend.
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Column', 'Row', 'Table')]
        [System.String] $Style,

        ## The legend can be docked to the top, left, bottom or right of either the entire chart image, or the inside or outside of a chart area.
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Top', 'Right', 'Bottom', 'Left')]
        [System.String] $Dock,

        ## Pass the [System.Windows.Forms.DataVisualization.Charting.Legend] object down the pipeline
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $PassThru
    )
    process
    {
        $chartLegend = New-Object -TypeName System.Windows.Forms.DataVisualization.Charting.Legend -ArgumentList $Name
        $chartLegend.Title = $Title
        $chartLegend.TitleAlignment = $TitleAlignment
        $chartLegend.Font = $Font

        if ($PSCmdlet.ParameterSetName -in 'Position')
        {
            $chartLegend.Position.Auto = $false
            $chartLegend.Position.X = $X
            $chartLegend.Position.Y = $Y
            $chartLegend.Position.Width = $Width
            $chartLegend.Position.Height= $Height
        }
        else
        {
            $chartLegend.Position.Auto = $true
        }

        if ($PSBoundParameters.ContainsKey('DockedToChartArea'))
        {
            $chartLegend.DockedToChartArea = $DockedToChartArea
        }

        if ($PSBoundParameters.ContainsKey('Style'))
        {
            $chartLegend.LegendStyle = $Style
        }

        if ($PSBoundParameters.ContainsKey('Dock'))
        {
            $chartLegend.Docking = $Dock
        }

        $Chart.Legends.Add($chartLegend)
        foreach ($series in $ChartSeries)
        {
            $series.Legend = $chartLegend.Name
        }

        if ($PassThru)
        {
            Write-Output -InputObject $chartLegend
        }
    }
}
