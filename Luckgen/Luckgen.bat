@echo off
setlocal enableDelayedExpansion
:generate
set /A line=0

copy /y nul sneakylikeafox.txt

for /f "tokens=*" %%s in (params.txt) do (
  set /A line+=1
  %%s
  if !line!==1 (
    set /A timesRun+=1
    echo set /A timesRun=!timesRun!>sneakylikeafox.txt
  ) else (
    echo %%s>>sneakylikeafox.txt
  )
)

del params.txt
ren sneakylikeafox.txt params.txt

set /A valueInversionRNG=%random% %%3

set /A value=%random% %%%valueMax%

set /A rarityRNG=%random% %%4
set /A groupRNG=%random% %%47
set /A effectAnimationRNG=%random% %%4
set /A effectTargetRNG=%random% %%3
set /A effectActionRNG=%random% %%5
set /A effectTriggerRNG=%random% %%3
set /A effectValueInversionRNG=%random% %%3
if %effectValueInversionRNG%==2 (
	set /A effectValueInversionRNG=1
) else (
	set /A effectValueInversionRNG=0
)

if %valueInversionRNG%==2 (
	set /A valueInversionRNG=1
) else (
	set /A valueInversionRNG=0
)

if %effectActionRNG%==0 (
	set /A effectValue=%random% %%51
) else if %effectActionRNG%==1 (
	set /A effectValue=%random% %%51
) else if %effectActionRNG%==2 (
	set effectValue=true
	set /A effectValueInversionRNG=0
	set /A valueInversionRNG=0
) else if %effectActionRNG%==3 (
	set /A effectValue=%random% %%6
	set /A effectValueInversionRNG=0
	set /A valueInversionRNG=0
) else if %effectActionRNG%==4 (
	set /A effectValue=%random% %%6
	set /A effectValueInversionRNG=0
	set /A valueInversionRNG=0
) else if %effectActionRNG%==5 (
	set /A effectValue=
)

if %effectTriggerRNG%==2 (
	set effectTriggerRNG=0
) else (
	set effectTriggerRNG=1
)

if %effectValue%==true (
	set effectValueDesc=
) else (
	set effectValueDesc=!effectValue!
)

if %effectTargetRNG%==0 (
	set /A effectTargetOtherRNG=51
	set /A effectTargetOtherShellChoice=0
	set /A effectAnimationTargetChoice=0
) else if %effectTargetRNG%==1 (
	set /A effectTargetOtherRNG=%random% %%51
	set /A effectAnimationTargetChoice=1
	if %effectTriggerRNG%==0 (
		set /A effectTargetOtherShellChoice=1
	) else (
		set /A effectTargetOtherShellChoice=2
	)
) else if %effectTargetRNG%==2 (
	set /A effectTargetOtherRNG=%random% %%51
	set /A effectAnimationTargetChoice=1
	if %effectTriggerRNG%==0 (
		set /A effectTargetOtherShellChoice=1
	) else (
		set /A effectTargetOtherShellChoice=2
	)
)

if %effectTriggerRNG%==1 (
	set effectTriggerShellChoice=1
) else if %effectTargetOtherRNG%==51 (
	set effectTriggerShellChoice=0
) else (
	set effectTriggerShellChoice=1
)

set effectTargetOtherShell[0]=
set effectTargetOtherShell[1]={!effectTargetOther[%effectTargetOtherRNG%]!}
set effectTargetOtherShell[2]={!effectTargetOther[%effectTargetOtherRNG%]!}
 :: there was a comma and a space before the curly brackets but that broke the game so uhhhh maybe ill replace it later :shrug:
set effectTriggerShell[0]=
set effectTriggerShell[1]="comparisons": [!effectTargetOtherShell[%effectTargetOtherShellChoice%]!], 

rem put !effectTrigger[%effectTriggerRNG%]! up ^there^ later

mkdir %output%\RandomlyGeneratedSymbol%timesRun%\scripts
mkdir %output%\RandomlyGeneratedSymbol%timesRun%\art
mkdir %output%\RandomlyGeneratedSymbol%timesRun%\sfx

(
Echo;extends "res://Mod Data.gd"
Echo;
Echo;func _init(^):
Echo;	mod_type = "symbol"
Echo;	type = "code_fragment_!timesRun!"
Echo;	inherit_effects = false
Echo;	inherit_art = false
Echo;	inherit_groups = false
Echo;	display_name = "Code Fragment"
Echo;	localized_names = {}
Echo;	value = !valueInversion[%valueInversionRNG%]!%value%
Echo;	description = "!effectTargetDesc[%effectTargetRNG%]!!effectTargetOtherDesc[%effectTargetOtherRNG%]!!effectActionDesc[%effectActionRNG%]!!valueInversion[%effectValueInversionRNG%]!%effectValueDesc%!effectActionDesc2[%effectActionRNG%]!!effectTriggerDesc[%effectTriggerRNG%]!"
Echo;	localized_descriptions = {}
Echo;	values = []
Echo;	rarity = !rarities[%rarityRNG%]!
Echo;	groups = [!group[%groupRNG%]!]
Echo;	sfx = []
Echo;	effects = [
Echo;	{"effect_type": !effectTarget[%effectTargetRNG%]! !effectTriggershell[%effectTriggerShellChoice%]!"value_to_change": !effectAction[%effectActionRNG%]! "diff": !valueInversion[%valueInversionRNG%]!!effectValue!, "anim": !effectAnimation[%effectAnimationRNG%]!!effectAnimationTarget[%effectAnimationTargetChoice%]!},
Echo;	{}
Echo;	]
)  >  "%output%\RandomlyGeneratedSymbol%timesRun%\scripts\custom.gd"

xcopy /s Input\code_fragment.png %output%\RandomlyGeneratedSymbol%timesRun%\art\
ren %output%\RandomlyGeneratedSymbol%timesRun%\art\code_fragment.png code_fragment_%timesRun%.png

echo Finished

:choice
set /P c=Would you like to make another symbol[Y/N]?
if /I "%c%"=="Y" goto :generate
if /I "%c%"=="N" goto :end
goto :choice

:end
endlocal