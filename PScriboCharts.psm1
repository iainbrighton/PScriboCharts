Set-StrictMode -Version Latest

## Import localisation strings based on UICulture
$importLocalizedDataParams = @{
    BindingVariable = 'localized'
    BaseDirectory   = $PSScriptRoot
    FileName        = 'PScriboCharts.Resources.psd1'
}
Import-LocalizedData @importLocalizedDataParams -ErrorAction SilentlyContinue

#Fallback to en-US culture strings
if (-not (Test-Path -Path 'Variable:\localized'))
{
    $importLocalizedDataParams['UICulture'] = 'en-US'
    Import-LocalizedData @importLocalizedDataParams -ErrorAction Stop
}

## Dot source all the nested .ps1 files in the \Functions and \Plugin folders, excluding tests
$pscriboRoot = Split-Path -Parent $PSCommandPath;
Get-ChildItem -Path "$pscriboRoot\Src\" -Include '*.ps1' -Recurse |
    ForEach-Object {
        Write-Verbose ($localized.ImportingFile -f $_.FullName);
        ## https://becomelotr.wordpress.com/2017/02/13/expensive-dot-sourcing/
        . ([System.Management.Automation.ScriptBlock]::Create(
                [System.IO.File]::ReadAllText($_.FullName)
            ));
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms.DataVisualization

<# Custom Chart Properties:

    https://msdn.microsoft.com/en-us/library/dd489233.aspx
    https://msdn.microsoft.com/en-us/library/dd456764.aspx

Area          : EmptyPointValue, LabelStyle, PixelPointDepth, PixelPointGapDepth, ShowMarkerLines
Bar           : BarLabelStyle, DrawingStyle, DrawSideBySide, EmptyPointValue, MaxPixelPointWidth, MinPixelPointWidth, PixelPointDepth, PixelPointGapDepth, PixelPointWidth, PointWidth
BoxPlot       : BoxPlotPercentile, BoxPlotSeries, BoxPlotShowAverage, BoxPlotShowMedian, BoxPlotShowUnusualValues, BoxPlotWhiskerPercentile, DrawSideBySide, MaxPixelPointWidth, MinPixelPointWidth, PixelPointDepth, PixelPointGapDepth, PixelPointWidth, PointWidth
Bubble        : BubbleMaxSize, BubbleMinSize, BubbleScaleMax, BubbleScaleMin, BubbleUseSizeForLabel, EmptyPointValue, LabelStyle, PixelPointDepth, PixelPointGapDepth
Candlestick   : LabelValueType, MaxPixelPointWidth, MinPixelPointWidth, PixelPointDepth, PixelPointGapDepth, PixelPointWidth, PointWidth, PriceDownColor, PriceUpColor
Column        : DrawingStyle, DrawSideBySide, EmptyPointValue, LabelStyle, MaxPixelPointWidth, MinPixelPointWidth, PixelPointDepth, PixelPointGapDepth, PixelPointWidth, PointWidth
Doughnut      : 3DLabelLineSize, CollectedColor, CollectedLabel, CollectedLegendText, CollectedSliceExploded, CollectedThreshold,
                CollectedThresholdUsePercent, CollectedToolTip, DoughnutRadius, Exploded, LabelsHorizontalLineSize, LabelsRadialLineSize, MinimumRelativePieSize, PieDrawingStyle, PieLabelStyle, PieLineColor, PieStartAngle
ErrorBar      : DrawSideBySide, ErrorBarCenterMarkerStyle, ErrorBarSeries, ErrorBarStyle, ErrorBarType, MaxPixelPointWidth, MinPixelPointWidth, PixelPointDepth, PixelPointGapDepth, PixelPointWidth, PointWidth
FastLine      : PixelPointDepth, PixelPointGapDepth
FastPoint     : <None>
Funnel        : CalloutLineColor, Funnel3DDrawingStyle, Funnel3DRotationAngle, FunnelInsideLabelAlignment, FunnelLabelStyle, FunnelMinPointHeight, FunnelNeckHeight, FunnelNeckWidth, FunnelOutsideLabelPlacement, FunnelPointGap, FunnelStyle
Kagi          : PixelPointDepth, PixelPointGapDepth, PriceUpColor, ReversalAmount, UsedYValue
Line          : EmptyPointValue, LabelStyle, PixelPointDepth, PixelPointGapDepth, ShowMarkerLines
Pie           : 3DLabelLineSize, CollectedColor, CollectedLabel, CollectedLegendText, CollectedSliceExploded, CollectedThreshold,
                CollectedThresholdUsePercent, CollectedToolTip, Exploded, LabelsHorizontalLineSize, LabelsRadialLineSize, MinimumRelativePieSize, PieDrawingStyle, PieLabelStyle, PieLineColor, PieStartAngle
Point         : EmptyPointValue, LabelStyle, PixelPointDepth, PixelPointGapDepth
PointAndFigure: BoxSize, CurrentBoxSize (read-only), PixelPointDepth, PixelPointGapDepth, PriceUpColor, ProportionalSymbols, ReversalAmount, UsedYValueHigh, UsedYValueLow
Polar         : AreaDrawingStyle, CircularLabelStyle, EmptyPointValue, LabelStyle, PolarDrawingStyle
Pyramid       : CalloutLineColor, Pyramid3DDrawingStyle, Pyramid3DRotationAngle, PyramidInsideLabelAlignment, PyramidLabelStyle, PyramidMinPointHeight, PyramidOutsideLabelPlacement, PyramidPointGap, PyramidValueType
Radar         : AreaDrawingStyle, CircularLabelStyle, EmptyPointValue, LabelStyle, RadarDrawingStyle
Range         : EmptyPointValue, LabelStyle, PixelPointDepth, PixelPointGapDepth, ShowMarkerLines
RangeBar      : BarLabelStyle, DrawingStyle, DrawSideBySide, EmptyPointValue, MaxPixelPointWidth, MinPixelPointWidth, PixelPointDepth, PixelPointGapDepth, PixelPointWidth, PointWidth
RangeColumn   : DrawingStyle, DrawSideBySide, EmptyPointValue, MaxPixelPointWidth, MinPixelPointWidth, PixelPointDepth, PixelPointGapDepth, PixelPointWidth, PointWidth
Renko         : BoxSize, CurrentBoxSize (read-only), PixelPointDepth, PixelPointGapDepth, PriceUpColor, UsedYValue
Spline        : EmptyPointValue, LabelStyle, LineTension, PixelPointDepth, PixelPointGapDepth, ShowMarkerLines
SplineArea    : EmptyPointValue, LabelStyle, LineTension, PixelPointDepth, PixelPointGapDepth, ShowMarkerLines
SplineRange   : EmptyPointValue, LabelStyle, LineTension, PixelPointDepth, PixelPointGapDepth, ShowMarkerLines
StackedArea   : PixelPointDepth, PixelPointGapDepth
StackedArea100: PixelPointDepth, PixelPointGapDepth
StackedBar    : BarLabelStyle, DrawingStyle, MaxPixelPointWidth, MinPixelPointWidth, PixelPointDepth, PixelPointGapDepth, PixelPointWidth, PointWidth, StackedGroupName
StackedBar100 : BarLabelStyle, DrawingStyle, MaxPixelPointWidth, MinPixelPointWidth, PixelPointDepth, PixelPointGapDepth, PixelPointWidth, PointWidth, StackedGroupName
StackedColumn : DrawingStyle, MaxPixelPointWidth, MinPixelPointWidth, PixelPointDepth, PixelPointGapDepth, PixelPointWidth, PointWidth, StackedGroupName
StepLine      : EmptyPointValue, LabelStyle, PixelPointDepth, PixelPointGapDepth, ShowMarkerLines
Stock         : LabelValueType, MaxPixelPointWidth, MinPixelPointWidth, OpenCloseStyle, PixelPointDepth, PixelPointGapDepth, PixelPointWidth, PointWidth, ShowOpenClose
ThreeLineBreak: NumberOfLinesInBreak, PixelPointDepth, PixelPointGapDepth, PriceUpColor, UsedYValue


#>
