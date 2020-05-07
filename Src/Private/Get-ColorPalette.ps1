function Get-ColorPalette
{
    [CmdletBinding()]
    [OutputType([System.Drawing.Color[]])]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateSet('Amber','Berry','Blue','BlueGrey','Bright','BrightPastel','Brown','Chocolate','Cyan','DeepOrange',
                     'DeepPurple','EarthTones','Excel','Fire','Grayscale','Green','Grey','Indigo','Light','LightBlue',
                     'LightGreen','Lime','Orange','Pastel','Pink','Purple','Red','SeaGreen','SemiTransparent','Teal',
                     'Yellow')]
        [System.String] $Palette
    )
    begin
    {
        $colorMap = @{
            Amber           = '#FFF8E1', '#FFECB3', '#FFE082', '#FFD54F', '#FFCA28', '#FFC107', '#FFB300', '#FFA000', '#FF8F00', '#FF6F00'
            Berry           = '#8A2BE2', '#BA55D3', '#4169E1', '#C71585', '#0000FF', '#8A2BE2', '#DA70D6', '#7B68EE', '#C000C0', '#0000CD', '#800080'
            Blue            = '#E3F2FD', '#BBDEFB', '#90CAF9', '#64B5F6', '#42A5F5', '#2196F3', '#1E88E5', '#1976D2', '#1565C0', '#0D47A1'
            BlueGrey        = '#ECEFF1', '#CFD8DC', '#B0BEC5', '#90A4AE', '#78909C', '#607D8B', '#546E7A', '#455A64', '#37474F', '#263238'
            Bright          = '#008000', '#0000FF', '#800080', '#00FF00', '#FF00FF', '#008080', '#FFFF00', '#808080', '#00FFFF', '#000080', '#800000', '#FF0000', '#808000', '#C0C0C0', '#FF6347', '#FFE4B5'
            BrightPastel    = '#418CF0', '#FCB441', '#E0400A', '#056492', '#BFBFBF', '#1A3B69', '#FFE382', '#129CDD', '#CA6B4B', '#005CDB', '#F3D288', '#506381', '#F1B9A8', '#E0830A', '#7893BE'
            Brown           = '#EFEBE9', '#D7CCC8', '#BCAAA4', '#A1887F', '#8D6E63', '#795548', '#6D4C41', '#5D4037', '#4E342E', '#3E2723'
            Chocolate       = '#A0522D', '#D2691E', '#8B0000', '#CD853F', '#A52A2A', '#F4A460', '#8B4513', '#C04000', '#B22222', '#B65C3A'
            Cyan            = '#E0F7FA', '#B2EBF2', '#80DEEA', '#4DD0E1', '#26C6DA', '#00BCD4', '#00ACC1', '#0097A7', '#00838F', '#006064'
            DeepOrange      = '#FBE9E7', '#FFCCBC', '#FFAB91', '#FF8A65', '#FF7043', '#FF5722', '#F4511E', '#E64A19', '#D84315', '#BF360C'
            DeepPurple      = '#EDE7F6', '#D1C4E9', '#B39DDB', '#9575CD', '#7E57C2', '#673AB7', '#5E35B1', '#512DA8', '#4527A0', '#311B92'
            EarthTones      = '#FF8000', '#B8860B', '#C04000', '#6B8E23', '#CD853F', '#C0C000', '#228B22', '#D2691E', '#808000', '#20B2AA', '#F4A460', '#00C000', '#8FBC8B', '#B22222', '#8B4513', '#C00000'
            Excel           = '#9999FF', '#993366', '#FFFFCC', '#CCFFFF', '#660066', '#FF8080', '#0066CC', '#CCCCFF', '#000080', '#FF00FF', '#FFFF00', '#00FFFF', '#800080', '#800000', '#008080', '#0000FF'
            Fire            = '#FFD700', '#FF0000', '#FF1493', '#DC143C', '#FF8C00', '#FF00FF', '#FFFF00', '#FF4500', '#C71585', '#DDE221'
            Grayscale       = '#C8C8C8', '#BDBDBD', '#B2B2B2', '#A7A7A7', '#9C9C9C', '#919191', '#868686', '#7B7B7B', '#707070', '#656565', '#5A5A5A', '#4F4F4F', '#444444', '#393939', '#2E2E2E', '#232323'
            Green           = '#E8F5E9', '#C8E6C9', '#A5D6A7', '#81C784', '#66BB6A', '#4CAF50', '#43A047', '#388E3C', '#2E7D32', '#1B5E20'
            Grey            = '#FAFAFA', '#F5F5F5', '#EEEEEE', '#E0E0E0', '#BDBDBD', '#9E9E9E', '#757575', '#616161', '#424242', '#212121'
            Indigo          = '#E8EAF6', '#C5CAE9', '#9FA8DA', '#7986CB', '#5C6BC0', '#3F51B5', '#3949AB', '#303F9F', '#283593', '#1A237E'
            Light           = '#E6E6FA', '#FFF0F5', '#FFDAB9', '#FFFACD', '#FFE4E1', '#F0FFF0', '#F0F8FF', '#F5F5F5', '#FAEBD7', '#E0FFFF'
            LightBlue       = '#E1F5FE', '#B3E5FC', '#81D4FA', '#4FC3F7', '#29B6F6', '#03A9F4', '#039BE5', '#0288D1', '#0277BD', '#01579B'
            LightGreen      = '#F1F8E9', '#DCEDC8', '#C5E1A5', '#AED581', '#9CCC65', '#8BC34A', '#7CB342', '#689F38', '#558B2F', '#33691E'
            Lime            = '#F9FBE7', '#F0F4C3', '#E6EE9C', '#DCE775', '#D4E157', '#CDDC39', '#C0CA33', '#AFB42B', '#9E9D24', '#827717'
            Orange          = '#FFF3E0', '#FFE0B2', '#FFCC80', '#FFB74D', '#FFA726', '#FF9800', '#FB8C00', '#F57C00', '#EF6C00', '#E65100'
            Pastel          = '#87CEEB', '#32CD32', '#BA55D3', '#F08080', '#4682B4', '#9ACD32', '#40E0D0', '#FF69B4', '#F0E68C', '#D2B48C', '#8FBC8B', '#6495ED', '#DDA0DD', '#5F9EA0', '#FFDAB9', '#FFA07A'
            Pink            = '#FCE4EC', '#F8BBD0', '#F48FB1', '#F06292', '#EC407A', '#E91E63', '#D81B60', '#C2185B', '#AD1457', '#880E4F'
            Purple          = '#F3E5F5', '#E1BEE7', '#CE93D8', '#BA68C8', '#AB47BC', '#9C27B0', '#8E24AA', '#7B1FA2', '#6A1B9A', '#4A148C'
            Red             = '#FFEBEE', '#FFCDD2', '#EF9A9A', '#E57373', '#EF5350', '#F44336', '#E53935', '#D32F2F', '#C62828', '#B71C1C'
            SeaGreen        = '#2E8B57', '#66CDAA', '#4682B4', '#008B8B', '#5F9EA0', '#3CB371', '#48D1CC', '#B0C4DE', '#8FBC8B', '#87CEEB'
            SemiTransparent = '#FF0000', '#00FF00', '#0000FF', '#FFFF00', '#00FFFF', '#FF00FF', '#AA7814', '#FF0000', '#00FF00', '#0000FF', '#FFFF00', '#00FFFF', '#FF00FF', '#AA7814', '#647832', '#285A96'
            Teal            = '#E0F2F1', '#B2DFDB', '#80CBC4', '#4DB6AC', '#26A69A', '#009688', '#00897B', '#00796B', '#00695C', '#004D40'
            Yellow          = '#FFFDE7', '#FFF9C4', '#FFF59D', '#FFF176', '#FFEE58', '#FFEB3B', '#FDD835', '#FBC02D', '#F9A825', '#F57F17'
        }
    }
    process
    {
        $colorPalette = New-Object -TypeName System.Collections.ArrayList
        foreach ($color in $colorMap[$Palette])
        {
            [ref] $null = $colorPalette.Add([System.Drawing.ColorTranslator]::FromHtml($color))
        }
        return $colorPalette.ToArray()
    }
}
