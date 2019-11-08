#debuglevel 10

	gosub routinecommon
	gosub routineingot
	#gosub routinecombat
	#gosub routinemoonbuffs
	#gosub routinesteal
	#gosub astro.initialize

	var train_now forging
	var resonance stealing
	put #var monitor no

mainloop:
	if_1 then gosub %1

	#gosub iron3
	#gosub iron3
	#gosub iron3

	gosub smelt {tiny tin nugget|20} {tin ingot|1}
	#gosub ingot refine steel
	#gosub smelt {damite ingot|1} {audrualm ingot|1}
	#exit
	#gosub ingot refine iron
	#gosub ingot refine iron


	goto mainloop

forge_exit:
	gosub get my ingot
	gosub put.1 "put ingot in buck" "^You drop|^What were you"
	put #parse Forging done

exit

mix:
	var do1 %2
	var do2 %3
	if "$1" != "" then var do1 $1
	if "$2" != "" then var do1 $2
	gosub smelt {%do1 ingot|1} {%do2 ingot|1}
return

## ** STEEL - 50 Quantity
iron2:
	gosub smelt {massive iron nugget|10}
	gosub ingot refine iron
	gosub smelt {iron ingot|1} {massive coal nugget|10}
return

iron3:
	#gosub smelt {massive iron nugget|5}
	#gosub smelt {iron ingot|1} {massive coal nugget|15}
	gosub smelt {massive iron nugget|5} {massive coal nugget|15}
	#gosub ingot refine steel
return

oravir100:
	gosub smelt {tiny oravir nugget|20}
	gosub smelt {oravir ingot|1} {tiny oravir nugget|20}
	gosub smelt {oravir ingot|1} {tiny oravir nugget|20}
	gosub smelt {oravir ingot|1} {tiny oravir nugget|20}
	gosub smelt {oravir ingot|1} {tiny oravir nugget|20}
	gosub ingot refine oravir
return

nickel100:
	gosub smelt {tiny nickel nugget|20}
	gosub smelt {nickel ingot|1} {tiny nickel nugget|20}
	gosub smelt {nickel ingot|1} {tiny nickel nugget|20}
	gosub smelt {nickel ingot|1} {tiny nickel nugget|20}
	gosub smelt {nickel ingot|1} {tiny nickel nugget|20}
	gosub ingot refine nickel
return

tin100:
	gosub smelt {tiny tin nugget|20}
	gosub smelt {tin ingot|1} {tiny tin nugget|20}
	gosub smelt {tin ingot|1} {tiny tin nugget|20}
	gosub smelt {tin ingot|1} {tiny tin nugget|20}
	gosub smelt {tin ingot|1} {tiny tin nugget|20}
	#gosub ingot refine tin
return

smelt:
	var item1 $1
	var item2 $2
	var item3 $3
	var item4 $4
	var origin $roomid

	gosub item_vars
	pause
	pause
	gosub buy_ingredients

	## *** first forging room
	gosub move 915
	gosub checkplayer
	if %playerhere = 1 then
	{
		gosub move 916
		gosub checkplayer
		if %playerhere = 1 then gosub move 975
		gosub checkplayer
		if %playerhere = 1 then gosub move 974
		gosub checkplayer
		if %playerhere = 1 then return
	}
smelt2:
	if "%item1" != "" then gosub loadcruc %item1
	if "%item2" != "" then gosub loadcruc %item2
	if "%item3" != "" then gosub loadcruc %item3
	if "%item4" != "" then gosub loadcruc %item4
	gosub emptyhands
	gosub ingot smelt
	gosub emptyhands
	return

loadcruc:
	action math cruc_load add 1 when ^You put your.*crucible.
	action var cruc_full 1 when ^That is far too hot
	var cruc_full 0
	var this_load $0
	eval this_load replace ("%this_load", "tiny ", "")
	eval this_load replace ("%this_load", "massive ", "")
	eval this_load replace ("%this_load", "huge ", "")
	var cruc_load 0
loadloop:
	if !contains("$lefthand", "%this_load") then if "$lefthand" != "Empty" then gosub stow left
	if !contains("$lefthand", "%this_load") then if "$righthand" != "Empty" then gosub stow right
	if %cruc_full = 1 then return
	if !contains("$lefthand", "%this_load") then gosub get my %this_load(0)
	gosub put.1 "put my $righthandnoun in cruc" "^You put"
	if %cruc_load < %this_load(1) then goto loadloop
	return

singlemix:
	if "$righthand" != "Empty" then gosub stow right
	gosub get my rod
	gosub put.1 "mix cruc with my rod" "^Roundtime:"
	gosub stow right
	var cruc_max 1
	return

buy_ingredients:
	if "%item1" != "" then gosub order {%item1}
	if "%item2" != "" then gosub order {%item2}
	if "%item3" != "" then gosub order {%item3}
	if "%item4" != "" then gosub order {%item4}
return

order:
	var current_order none
	var this_order $0
	if contains("%this_order", "tiny coal nugget") then var current_order 1
	if contains("%this_order", "massive coal nugget") then var current_order 2
	if contains("%this_order", "tiny oravir nugget") then var current_order 3
	if contains("%this_order", "tiny tin nugget") then var current_order 4
	if contains("%this_order", "tiny zinc nugget") then var current_order 5
	if contains("%this_order", "tiny iron nugget") then var current_order 6
	if contains("%this_order", "massive iron nugget") then var current_order 7
	if contains("%this_order", "tiny steel ingot") then var current_order 8
	if contains("%this_order", "massive steel ingot") then var current_order 9
	if contains("%this_order", "tiny nickel nugget") then var current_order 10
	if contains("%this_order", "huge bronze ingot") then var current_order 11
	if contains("%this_order", "tiny copper nugget") then var current_order 12
	if contains("%this_order", "lead nugget") then var current_order 13
	if "%current_order" = "none" then return
	gosub move 920
	var nuggetcount 0
	action math nuggetcount add 1 when ^The attendant takes some coins from you and hands you
orderloop:
	gosub emptyhands
	gosub put.1 "order %current_order" ".+"
	gosub put.1 "order %current_order" ".+"

	if %nuggetcount >= %this_order(1) then goto orderloop.exit

	gosub put.1 "order %current_order" ".+"
	gosub put.1 "order %current_order" ".+"

	if %nuggetcount >= %this_order(1) then goto orderloop.exit

	goto orderloop

orderloop.exit:
	gosub emptyhands

return

item_vars:
	if "%item1" != "" then var item1_name %item1(0)
	if "%item1" != "" then var item1_quantity %item1(1)
	if "%item2" != "" then var item2_name %item2(0)
	if "%item2" != "" then var item2_quantity %item2(1)
	if "%item3" != "" then var item3_name %item3(0)
	if "%item3" != "" then var item3_quantity %item3(1)
	if "%item4" != "" then var item4_name %item4(0)
	if "%item4" != "" then var item4_quantity %item4(1)
return

include routinecommon.cmd
#include routinecombat.cmd
#include routinesteal.cmd
#include routinemoonbuffs.cmd
#include astro.cmd
include ingot.cmd
