#requires -Version 2 -Modules posh-git

function Write-Theme {
    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )
    #$prompt += Write-Prompt -Object ($sl.PromptSymbols.PromptIndicator+" ") -ForegroundColor $sl.Colors.PromptBackgroundColor
    #check the last command state and indicate if failed
    $promtSymbolColor = [ConsoleColor]::Green
    If ($lastCommandFailed) {
        $promtSymbolColor = [ConsoleColor]::Red
    }
    
    $prompt += Write-Prompt -Object (
        [char]::ConvertFromUtf32(0x1F984)) -ForegroundColor  $sl.Colors.GitNoLocalChangesAndAheadColor
    $prompt += Write-Prompt -Object (
        [char]::ConvertFromUtf32(0x1F525)+" ") -ForegroundColor $promtSymbolColor
    # Writes the postfixes to the prompt
    

    $user = $sl.CurrentUser 
    $prompt += Write-Prompt -Object $user
    $prompt += Write-Prompt -Object " :: " 
    # Writes the drive portion
    $drive = $sl.PromptSymbols.HomeSymbol
    if ($pwd.Path -ne $HOME) {
        $drive = "$(Split-Path -path $pwd -Leaf)"
    }
    $prompt += Write-Prompt -Object $drive -ForegroundColor $sl.Colors.DriveForegroundColor

    $status = Get-VCSStatus
    if ($status) {
        $prompt += Write-Prompt -Object " git(" -ForegroundColor $sl.Colors.PromptHighlightColor
        $prompt += Write-Prompt -Object ($status.Branch) -ForegroundColor $sl.Colors.WithForegroundColor
        $prompt += Write-Prompt -Object ")" -ForegroundColor $sl.Colors.PromptHighlightColor
        if ($status.Working.Length -gt 0) {
            $prompt += Write-Prompt -Object (" "+$sl.PromptSymbols.GitDirtyIndicator) -ForegroundColor $sl.Colors.GitDefaultColor
        }
    } else {
        $prompt += Write-Prompt -Object (" ::") -ForegroundColor $sl.Colors.GitDefaultColor
    }

    if ($with) {
        $prompt += Write-Prompt -Object "$($with.ToUpper()) " -BackgroundColor $sl.Colors.WithBackgroundColor -ForegroundColor $sl.Colors.WithForegroundColor
    }
    # $sTime = " $(Get-Date -Format HH:mm)"
    # $prompt += Write-Prompt -Object $sTime   -ForegroundColor $sl.colors.PromptSymbolColor
    #$prompt += Set-Newline

    $prompt += '  '
    $prompt
    $timeStamp = Get-Date -Format "hh:mm tt"
    $timestamp = " $timeStamp "

    if ($host.UI.RawUI.CursorPosition.X + $timestamp.Length + 13 -lt $host.UI.RawUI.WindowSize.Width){
        $prompt += Set-CursorForRightBlockWrite -textLength ($timestamp.Length + 13)
        $prompt += Write-Prompt -Object $sl.PromptSymbols.Blur1Symbol -ForegroundColor $PromptForegroundColor
        $prompt += Write-Prompt -Object $sl.PromptSymbols.Blur2Symbol -ForegroundColor $PromptForegroundColor
        $prompt += Write-Prompt -Object $sl.PromptSymbols.Blur3Symbol -ForegroundColor $PromptForegroundColor
        $prompt += Write-Prompt -Object $sl.PromptSymbols.Blur4Symbol -ForegroundColor $PromptForegroundColor
        $prompt += Write-Prompt $timeStamp -ForegroundColor $sl.Colors.GitForegroundColor -BackgroundColor $sl.Colors.PromptForegroundColor
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.ClockSymbol) " -ForegroundColor $sl.Colors.GitForegroundColor -BackgroundColor $sl.Colors.PromptForegroundColor
    }
    $prompt += Set-Newline
    $prompt += Write-Prompt -Object $sl.PromptSymbols.Blur5Symbol -ForegroundColor $PromptForegroundColor
    $prompt += Write-Prompt -Object $sl.PromptSymbols.Blur6Symbol -ForegroundColor $PromptForegroundColor
}

function Get-TimeSinceLastCommit {
    return (git log --pretty=format:'%cr' -1)
}

$sl = $global:ThemeSettings #local settings
$sl.PromptSymbols.PromptIndicator = '+'
$sl.PromptSymbols.HomeSymbol = [char]::ConvertFromUtf32(0x1F3E0)
$sl.Colors.PromptSymbolColor = [ConsoleColor]::Green
$sl.Colors.PromptHighlightColor = [ConsoleColor]::Blue
$sl.Colors.DriveForegroundColor = [ConsoleColor]::Cyan
$sl.Colors.WithForegroundColor = [ConsoleColor]::Red
$sl.PromptSymbols.GitDirtyIndicator =[char]::ConvertFromUtf32(0x26A1)  + [char]::ConvertFromUtf32(0x2615)  + [char]::ConvertFromUtf32(0x1F914)
$sl.Colors.GitDefaultColor = [ConsoleColor]::Yellow
$sl.Colors.AdminIconForegroundColor = [ConsoleColor]::Blue
$sl.PromptSymbols.Blur1Symbol = [char]::ConvertFromUtf32(0x1F31E)
$sl.PromptSymbols.Blur2Symbol = [char]::ConvertFromUtf32(0x1F680)
$sl.PromptSymbols.Blur3Symbol = [char]::ConvertFromUtf32(0x26A1)
$sl.PromptSymbols.Blur4Symbol = "69%"
$sl.PromptSymbols.ClockSymbol = [char]::ConvertFromUtf32(0x23F0)
$sl.PromptSymbols.Blur5Symbol = [char]::ConvertFromUtf32(0x1F680)
$sl.PromptSymbols.Blur6Symbol = [char]::ConvertFromUtf32(0x1F4A8)
