function Add-ChartTitle
{
<#
    .SYNOPSIS


    .DESCRIPTION
        Titles are stored as Title objects in the Chart.Titles collection property. You can dock a title to a chart
        area. To do this, set the Title.DockedToChartArea property to the name of the chart area to which you want
        to dock the title.

    .LINK

#>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType([System.Windows.Forms.DataVisualization.Charting.Title])]
    param
    (
        ## Title name
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.String] $Name,

        ## Chart to add the title to (required due to internal Charting object model)
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.Windows.Forms.DataVisualization.Charting.Chart] $Chart,

        ## ChartArea to dock the title to (required due to internal Charting object model)
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ChartArea')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ChartAreaPosition')]
        [System.Windows.Forms.DataVisualization.Charting.ChartArea] $ChartArea,

        ## Dock the title inside the ChartArea
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'ChartArea')]
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'ChartAreaPosition')]
        [System.Management.Automation.SwitchParameter] $DockedInsideChartArea,

        ## Text for the title
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.String] $Text = $Name,

        ## Title font
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Font] $Font = (Get-DefaultFont),

        ## Title text fore colour
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Color] $ForeColor,

        ## Title text fore colour
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Drawing.Color] $BackColor,

        ## Title text orientation
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Auto','Horizontal','Rotated270','Rotated90','Stacked')]
        [System.String] $Orientation,

        ## The relative X-coordinate of the top-left corner of the chart element
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Position')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ChartAreaPosition')]
        [ValidateRange(0, 100)]
        [System.Int32] $X,

        ## The relative Y-coordinate of the top-left corner of the chart element
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Position')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ChartAreaPosition')]
        [ValidateRange(0, 100)]
        [System.Int32] $Y,

        ## The relative height of the chart element
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Position')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ChartAreaPosition')]
        [ValidateRange(0, 100)]
        [System.Int32] $Height,

        ## The relative width of the chart element
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Position')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ChartAreaPosition')]
        [ValidateRange(0, 100)]
        [System.Int32] $Width,

        ## Pass the [System.Windows.Forms.DataVisualization.Charting.Title] object down the pipeline
        [Parameter(ValueFromPipelineByPropertyName)]
        [System.Management.Automation.SwitchParameter] $PassThru
    )
    process
    {
        $chartTitle = New-Object -TypeName 'System.Windows.Forms.DataVisualization.Charting.Title' -ArgumentList $Name
        $chartTitle.Text = $Text
        $chartTitle.Font = $Font

        if ($PSBoundParameters.ContainsKey('ForeColor'))
        {
            $chartTitle.ForeColor = $ForeColor
        }

        if ($PSBoundParameters.ContainsKey('BackColor'))
        {
            $chartTitle.BackColor = $BackColor
        }

        if ($PSBoundParameters.ContainsKey('Orientation'))
        {
            $chartTitle.TextOrientation = $Orientation
        }

        if ($PSBoundParameters.ContainsKey('ChartArea'))
        {
            $chartTitle.DockedToChartArea = $ChartArea.Name
            $chartTitle.IsDockedInsideChartArea = $DockedInsideChartArea.ToBool()
        }

        if ($PSCmdlet.ParameterSetName -match 'Position')
        {
            $chartTitle.Position.Auto = $false
            $chartTitle.Position.X = $X
            $chartTitle.Position.Y = $Y
            $chartTitle.Position.Width = $Width
            $chartTitle.Position.Height= $Height
        }
        else
        {
            $chartTitle.Position.Auto = $true
        }

        $Chart.Titles.Add($chartTitle)

        if ($PassThru)
        {
            Write-Output -InputObject $chartTitle
        }
    }
}
