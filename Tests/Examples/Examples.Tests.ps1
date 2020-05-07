$here = Split-Path -Path $MyInvocation.MyCommand.Path -Parent;
$testRoot  = Split-Path -Path $here -Parent;
$moduleRoot = Split-Path -Path $testRoot -Parent;
Import-Module "$moduleRoot\PScriboCharts.psm1" -Force;

Get-ChildItem -Path (Join-Path -Path $moduleRoot -ChildPath 'Examples') |
    ForEach-Object {

        Describe $_.Name {
            Mock Import-Module { }

            $result = & $_.FullName -PassThru

            It 'Creates output file' {
                $result | Should Not BeNullOrEmpty
            }

            It 'File length is greater than zero' {
                $result.Length | Should BeGreaterThan 0
            }
        }
    }
