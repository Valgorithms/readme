/datum/job/var/allow_spies = FALSE
/datum/job/var/is_officer = FALSE
/datum/job/var/is_squad_leader = FALSE
/datum/job/var/is_commander = FALSE
/datum/job/var/is_petty_commander = FALSE
/datum/job/var/is_nonmilitary = FALSE
/datum/job/var/spawn_delay = FALSE
/datum/job/var/delayed_spawn_message = ""
/datum/job/var/is_partisan = FALSE
/datum/job/var/is_primary = TRUE
/datum/job/var/is_secondary = FALSE
/datum/job/var/is_tankuser = FALSE
/datum/job/var/blacklisted = FALSE
/datum/job/var/is_target = FALSE //for VIP modes
/datum/job/var/rank_abbreviation = null

// new autobalance stuff - Kachnov
/datum/job/var/min_positions = 1 // absolute minimum positions if we reach player threshold
/datum/job/var/max_positions = 1 // absolute maximum positions if we reach player threshold
/datum/job/var/player_threshold = 0 // number of players who have to be on for this job to be open
/datum/job/var/scale_to_players = 50 // as we approach this, our open positions approach max_positions. Does nothing if min_positions == max_positions, so just don't touch it

/* type_flag() replaces flag, and base_type_flag() replaces department_flag
 * this is a better solution than bit constants, in my opinion */

/datum/job
	var/_base_type_flag = -1

/datum/job/proc/specialcheck()
	return TRUE

/datum/job/proc/type_flag()
	return "[type]"

/datum/job/proc/base_type_flag(var/most_specific = FALSE)

	if (_base_type_flag != -1)
		return _base_type_flag

	else if (istype(src, /datum/job/pirates))
		. = PIRATES
	else if (istype(src, /datum/job/british))
		. = BRITISH

	else if (istype(src, /datum/job/partisan))
		if (istype(src, /datum/job/partisan/civilian))
			. = CIVILIAN
		else
			. = PARTISAN



	_base_type_flag = .
	return _base_type_flag

/datum/job/proc/get_side_name()
	return capitalize(lowertext(base_type_flag()))

/datum/job/proc/assign_faction(var/mob/living/carbon/human/user)



	if (!squad_leaders[BRITISH])
		squad_leaders[BRITISH] = FALSE
	if (!squad_leaders[PIRATES])
		squad_leaders[PIRATES] = FALSE
	if (!squad_leaders[PARTISAN])
		squad_leaders[PARTISAN] = FALSE

	if (!officers[BRITISH])
		officers[BRITISH] = FALSE
	if (!officers[PIRATES])
		officers[PIRATES] = FALSE
	if (!officers[PARTISAN])
		officers[PARTISAN] = FALSE

	if (!commanders[BRITISH])
		commanders[BRITISH] = FALSE
	if (!commanders[PIRATES])
		commanders[PIRATES] = FALSE
	if (!commanders[PARTISAN])
		commanders[PARTISAN] = FALSE

	if (!soldiers[BRITISH])
		soldiers[BRITISH] = FALSE
	if (!soldiers[PIRATES])
		soldiers[PIRATES] = FALSE
	if (!soldiers[PARTISAN])
		soldiers[PARTISAN] = FALSE


	if (!squad_members[BRITISH])
		squad_members[BRITISH] = FALSE
	if (!squad_members[PIRATES])
		squad_members[PIRATES] = FALSE
	if (!squad_members[PARTISAN])
		squad_members[PARTISAN] = FALSE

	if (!istype(user))
		return

	if (istype(src, /datum/job/pirates))
		user.faction_text = "PIRATES"
		user.base_faction = new/datum/faction/pirates(user, src)
	else if (istype(src, /datum/job/british))
		user.faction_text = "BRITISH"
		user.base_faction = new/datum/faction/british(user, src)

	else if (istype(src, /datum/job/partisan))
		user.faction_text = "PARTISAN"
		user.base_faction = new/datum/faction/partisan(user, src)
		if (is_officer && !is_commander)
			user.officer_faction = new/datum/faction/partisan/officer(user, src)
		else if (is_commander)
			user.officer_faction = new/datum/faction/partisan/commander(user, src)


/datum/job/proc/opposite_faction_name()
	if (istype(src, /datum/job/pirates))
		return "Royal Navy"
	else
		return "Pirates"
		/*

*/
/proc/get_side_name(var/side, var/datum/job/j)
	if (side == BRITISH)
		return "Royal Navy"
	if (side == PIRATES)
		return "Pirates"
	return null

// here's a story
// the lines to give people radios and harnesses are really long and go off screen like this one
// and I got tired of constantly having to readd radios because merge conflicts
// so now there's this magical function that equips a human with a radio and harness
//	- Kachnov

/datum/job/update_character(var/mob/living/carbon/human/H)
	..()
	if (is_officer)
		H.make_artillery_officer()
		H.add_note("Officer", "As an officer, you can check coordinates.</span>")

	// hack to make scope icons immediately appear - Kachnov
	spawn (20)
		for (var/obj/item/weapon/gun/G in H.contents)
			if (list(H.l_hand, H.r_hand).Find(G))
				for (var/obj/item/weapon/attachment/scope/S in G.contents)
					if (S.azoom)
						S.azoom.Grant(H)
		for (var/obj/item/weapon/attachment/scope/S in H.contents)
			if (list(H.l_hand, H.r_hand).Find(S))
				if (S.azoom)
					S.azoom.Grant(H)