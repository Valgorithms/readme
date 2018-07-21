/client/proc/Debug2()
	set category = "Debug"
	set name = "Debug-Game"
	if (!check_rights(R_DEBUG))	return

	if (Debug2)
		Debug2 = FALSE
		message_admins("[key_name(src)] toggled debugging off.")
		log_admin("[key_name(src)] toggled debugging off.")
	else
		Debug2 = TRUE
		message_admins("[key_name(src)] toggled debugging on.")
		log_admin("[key_name(src)] toggled debugging on.")

// callproc moved to code/modules/admin/callproc


/client/proc/Cell()
	set category = "Debug"
	set name = "Cell"
	if (!mob)
		return
	var/turf/T = mob.loc

	if (!istype(T, /turf))
		return

	var/datum/gas_mixture/env = T.return_air()

	var/t = "<span class = 'notice'>Coordinates: [T.x],[T.y],[T.z]\n</span>"
	t += "<span class = 'red'>Temperature: [env.temperature]</span>\n"
	t += "<span class = 'red'>Pressure: [env.return_pressure()]kPa</span>\n"
	for (var/g in env.gas)
		t += "<span class = 'notice'>[g]: [env.gas[g]] / [env.gas[g] * R_IDEAL_GAS_EQUATION * env.temperature / env.volume]kPa</span>\n"

	usr.show_message(t, TRUE)



//TODO: merge the vievars version into this or something maybe mayhaps
/client/proc/cmd_debug_del_all()
	set category = "Debug"
	set name = "Del-All"

	// to prevent REALLY stupid deletions
	var/blocked = list(/obj, /mob, /mob/living, /mob/living/carbon, /mob/living/carbon/human, /mob/observer)
	var/hsbitem = input(usr, "Choose an object to delete.", "Delete:") as null|anything in typesof(/obj) + typesof(/mob) - blocked
	if (hsbitem)
		for (var/atom/O in world)
			if (istype(O, hsbitem))
				qdel(O)
		log_admin("[key_name(src)] has deleted all instances of [hsbitem].")
		message_admins("[key_name_admin(src)] has deleted all instances of [hsbitem].", FALSE)

/*
/client/proc/cmd_debug_make_powernets()
	set category = "Debug"
	set name = "Make Powernets"
	makepowernets()
	log_admin("[key_name(src)] has remade the powernet. makepowernets() called.")
	message_admins("[key_name_admin(src)] has remade the powernets. makepowernets() called.", FALSE)
*/
/*
/client/proc/cmd_debug_tog_aliens()
	set category = "Server"
	set name = "Toggle Aliens"

	config.aliens_allowed = !config.aliens_allowed
	log_admin("[key_name(src)] has turned aliens [config.aliens_allowed ? "on" : "off"].")
	message_admins("[key_name_admin(src)] has turned aliens [config.aliens_allowed ? "on" : "off"].", FALSE)
*/
/client/proc/cmd_assume_direct_control(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Assume direct control"
	set desc = "Direct intervention"

	if (!check_rights(R_DEBUG|R_ADMIN))	return
	if (M.ckey)
		if (WWinput(src, "This mob is being controlled by [M.ckey]. Are you sure you wish to assume control of it? [M.ckey] will be made a ghost.", "Assume Direct Control", "Yes", list("Yes","No")) != "Yes")
			return
		else
			var/mob/observer/ghost/ghost = new/mob/observer/ghost(M,1)
			ghost.ckey = M.ckey
	message_admins("<span class = 'notice'>[key_name_admin(usr)] assumed direct control of [M].</span>", TRUE)
	log_admin("[key_name(usr)] assumed direct control of [M].")
	var/mob/adminmob = mob
	M.ckey = ckey
	if (isghost(adminmob))
		qdel(adminmob)






/*
/client/proc/cmd_admin_areatest()
	set category = "Mapping"
	set name = "Test areas"

	var/list/areas_all = list()
	var/list/areas_with_APC = list()
	var/list/areas_with_air_alarm = list()
	var/list/areas_with_RC = list()
	var/list/areas_with_light = list()
	var/list/areas_with_LS = list()
	var/list/areas_with_intercom = list()
	var/list/areas_with_camera = list()

	for (var/area/A in world)
		if (!(A.type in areas_all))
			areas_all.Add(A.type)
/*
	for (var/obj/machinery/power/apc/APC in world)
		var/area/A = get_area(APC)
		if (!(A.type in areas_with_APC))
			areas_with_APC.Add(A.type)*/
/*
	for (var/obj/machinery/alarm/alarm in world)
		var/area/A = get_area(alarm)
		if (!(A.type in areas_with_air_alarm))
			areas_with_air_alarm.Add(A.type)
*/
/*
	for (var/obj/machinery/requests_console/RC in world)
		var/area/A = get_area(RC)
		if (!(A.type in areas_with_RC))
			areas_with_RC.Add(A.type)
*/
	for (var/obj/structure/light/L in world)
		var/area/A = get_area(L)
		if (!(A.type in areas_with_light))
			areas_with_light.Add(A.type)

/*	for (var/obj/structure/light_switch/LS in world)
		var/area/A = get_area(LS)
		if (!(A.type in areas_with_LS))
			areas_with_LS.Add(A.type)*/

	for (var/obj/item/radio/intercom/I in world)
		var/area/A = get_area(I)
		if (!(A.type in areas_with_intercom))
			areas_with_intercom.Add(A.type)

	var/list/areas_without_APC = areas_all - areas_with_APC
	var/list/areas_without_air_alarm = areas_all - areas_with_air_alarm
	var/list/areas_without_RC = areas_all - areas_with_RC
	var/list/areas_without_light = areas_all - areas_with_light
	var/list/areas_without_LS = areas_all - areas_with_LS
	var/list/areas_without_intercom = areas_all - areas_with_intercom
	var/list/areas_without_camera = areas_all - areas_with_camera

	world << "<b>AREAS WITHOUT AN APC:</b>"
	for (var/areatype in areas_without_APC)
		world << "* [areatype]"

	world << "<b>AREAS WITHOUT AN AIR ALARM:</b>"
	for (var/areatype in areas_without_air_alarm)
		world << "* [areatype]"

	world << "<b>AREAS WITHOUT A REQUEST CONSOLE:</b>"
	for (var/areatype in areas_without_RC)
		world << "* [areatype]"

	world << "<b>AREAS WITHOUT ANY LIGHTS:</b>"
	for (var/areatype in areas_without_light)
		world << "* [areatype]"

	world << "<b>AREAS WITHOUT A LIGHT SWITCH:</b>"
	for (var/areatype in areas_without_LS)
		world << "* [areatype]"

	world << "<b>AREAS WITHOUT ANY INTERCOMS:</b>"
	for (var/areatype in areas_without_intercom)
		world << "* [areatype]"

	world << "<b>AREAS WITHOUT ANY CAMERAS:</b>"
	for (var/areatype in areas_without_camera)
		world << "* [areatype]"
*/
/client/proc/cmd_admin_dress()
	set category = "Fun"
	set name = "Select equipment"

	var/mob/living/carbon/human/M = input("Select mob.", "Select equipment.") as null|anything in human_mob_list
	if (!M) return

	//log_admin("[key_name(src)] has alienized [M.key].")
	var/list/dresspacks = list(
		"strip",
		"job",
		"standard space gear",
		"tournament standard red",
		"tournament standard green",
		"tournament gangster",
		"tournament chef",
		"tournament janitor",
		"pirate",
		"space pirate",
		"pirates admiral",
		"tunnel clown",
		"masked killer",
		"assassin",
		"death commando",
		"syndicate commando",
		"special ops officer",
		"blue wizard",
		"red wizard",
		"marisa wizard",
		"nanotrasen representative",
		"nanotrasen officer",
		"nanotrasen captain"
		)
	var/dresscode = input("Select dress for [M]", "Robust quick dress shop") as null|anything in dresspacks
	if (isnull(dresscode))
		return

	for (var/obj/item/I in M)
/*		if (istype(I, /obj/item/weapon/implant))
			continue*/
		M.drop_from_inventory(I)
		if (I.loc != M)
			qdel(I)
	switch(dresscode)
		if ("strip")
			//do nothing
		if ("job")
			var/selected_job = input("Select job", "Robust quick dress shop") as null|anything in joblist
			if (isnull(selected_job))
				return

			var/datum/job/job = job_master.GetJob(selected_job)
			if (!job)
				return

			job.equip(M)
			job.apply_fingerprints(M)
			job_master.spawnKeys(M, selected_job)
		if ("tournament janitor")
			M.equip_to_slot_or_del(new /obj/item/clothing/under/rank/janitor(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(M), slot_shoes)
			var/obj/item/weapon/storage/backpack/backpack = new(M)
			for (var/obj/item/I in backpack)
				qdel(I)
			M.equip_to_slot_or_del(backpack, slot_back)

			M.equip_to_slot_or_del(new /obj/item/weapon/mop(M), slot_r_hand)
			var/obj/item/weapon/reagent_containers/glass/bucket/bucket = new(M)
			bucket.reagents.add_reagent("water", 70)
			M.equip_to_slot_or_del(bucket, slot_l_hand)

			M.equip_to_slot_or_del(new /obj/item/weapon/grenade/chem_grenade/cleaner(M), slot_r_store)
			M.equip_to_slot_or_del(new /obj/item/weapon/grenade/chem_grenade/cleaner(M), slot_l_store)
			M.equip_to_slot_or_del(new /obj/item/stack/tile/floor(M), slot_in_backpack)
			M.equip_to_slot_or_del(new /obj/item/stack/tile/floor(M), slot_in_backpack)
			M.equip_to_slot_or_del(new /obj/item/stack/tile/floor(M), slot_in_backpack)
			M.equip_to_slot_or_del(new /obj/item/stack/tile/floor(M), slot_in_backpack)
			M.equip_to_slot_or_del(new /obj/item/stack/tile/floor(M), slot_in_backpack)
			M.equip_to_slot_or_del(new /obj/item/stack/tile/floor(M), slot_in_backpack)
			M.equip_to_slot_or_del(new /obj/item/stack/tile/floor(M), slot_in_backpack)
