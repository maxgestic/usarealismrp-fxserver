const ReplaceStr = '_%_';

export const TSL = {
    list: {
        farm_main_name: 'Animalfarm',
        name: 'Name',
        owner: 'Owner',
        no_one: 'No-one',
        price: 'Price',
        locked: 'Locked',
        yes: 'Yes',
        no: 'No',
        buy: 'Buy',
        actions: 'Actions',
        rename: 'Rename',
        sell: 'Sell',

        thirst: 'Thirst',
        hunger: 'Hunger',
        health: 'Health',
        age: 'Age',

        gather: 'Gather',
        weight: 'Weight',

        animal_sold: `You have sold the animal for ${ReplaceStr} dollars!`,
        sell_animal_question: `Are you sure you want to sell this animal for ${ReplaceStr} dollars?`,

        no_more_storage: 'No more storage!',

        first_paddock: 'Paddock',
        second_paddock: 'Second Paddock',
        third_big_paddock: 'Third Paddock',
        first_chicken_paddock: 'Chicken Paddock',
        second_chicken_paddock: 'Second Chicken Paddock',
        can_not_buy_more_animals: 'You can not buy more animals into this Paddock!',

        raycast_shit_name: 'Shit\n~q~(Need shovel)',
        need_shovel_for_shit: 'You will need a shovel for that!',

        raycast_water_name: 'Fill with water.\n~q~(Need bucket of water)',
        water_trough_already_filled: 'The trough is filled with water!',
        need_bucket_with_water: 'Need a bucket filled with water!',
        
        water_main_name: 'Water trough',
        upgrade_water_description: 'Trough for providing water to your animals, without water your animals will die faster and produce less value.',

        raycast_trough_name: 'Fill with food.\n~q~(Need food with bag)',
        trough_already_filled: 'The trough is filled!',
        trough_need_foodbag: 'Need a food of bag to fill the trough!',

        trough_main_name: 'Feeding trough',
        upgrade_trough_description: 'Trough for providing food to your animals, without food your animals will die faster and produce less value.',

        need_empty_bucket: 'Need an empty bucket!',
        can_not_gather_milk_yet: 'You can not gather the milk yet!',
        raycast_bucket_with_milk: 'Bucket filled with milk.',

        farm_system_bought: `You bought the farm (${ReplaceStr}) for ${ReplaceStr} dollars.`,
        farm_closed: 'The door is closed!',
        farm_locked: 'Farm is now closed!',
        farm_unlocked: 'Farm is now opened!',
        no_key: 'You do not have a key to open this door!',
        farm_limit_buy: 'You can not buy more farms!',
        farm_target_limit_buy: 'The player you are trying to sell the farm to has exceeded the maximum amount of farms he can own.',
        farm_not_for_sale: 'This farm is not for sale!',
        target_not_exist: 'Target player is not exist!',
        farm_sold: `You have sold your farm for ${ReplaceStr} dollars.`,
        farm_bought: `You have bought the farm for ${ReplaceStr} dollars.`,
        farm_player_not_owner: 'You are not the owner of this farm!',
        not_enough_bank: 'You do not have enough money!',
        target_not_enough_bank: 'Target does not have enough money!',
        target_is_far: 'Target is too far!',
        watertip_far: 'Need to be closer!',
        watertip_already_bucket: 'There is already a bucket under the water tip..',
        watertip_already_filling: 'Currently filling another bucket...',
        watertip_need_emptybucket: 'You need a bucket to fill!',
        watertip_filling_starting: 'Filling the bucket...',
        raycast_empty_bucket_name: 'Empty bucket',
        raycast_filled_bucket_name: 'Bucket filled with water.',
        bucket_not_filled_yet: 'Bucket is not filled with water yet!',

        raycast_pickup_putdown_shovel: 'Pickup / Put down shovel',
        raycast_pickup_putdown_bucket: 'Pickup / Put down bucket',
        raycast_food_bag_name: 'Foodbag',
        raycast_milk_container_name: 'Milk container\n~q~(Need bucket of milk)',

        constant_name_upgrades: 'Upgrades',

        buy_farm_question: 'Are you sure you want to buy this farm?',
        rename_farm_question: 'Please enter the farm name.',
        sell_farm_question: 'Do you really want to sell your farm?\n\nPlease enter the Target ID and the price.',
        sell_farm_prompt_question: `${ReplaceStr} would sell his farm for $${ReplaceStr}.\nDo you accept?`,

        placeholder_rename: 'Name',
        placeholder_price: 'Price',
        placeholder_targetId: 'Target ID (source)',

        raycast_loot_egg_name: 'Egg box',
        egg: 'Eggs',
        eggs_sold_all_notification: `You have sold ${ReplaceStr} egg boxes for $${ReplaceStr}!`,
        egg_sold_notification: `You have sold one box of egg for $${ReplaceStr}!`,

        raycast_loot_meal_name: 'Meal box',
        meal: 'Meal',
        meal_sold_all_notification: `You have sold ${ReplaceStr} meal boxes for $${ReplaceStr}!`,
        meal_sold_notification: `You have sold one box of meal for $${ReplaceStr}!`,

        raycast_loot_milk_name: 'Milk box',
        milk: 'Milk',
        milk_sold_all_notification: `You have sold ${ReplaceStr} milk boxes for $${ReplaceStr}!`,
        milk_sold_notification: `You have sold one box of milk for $${ReplaceStr}!`,

        menu_sell_one_box: 'Sell one box',
        menu_sell_all_box: 'Sell all boxes',

        button_sell: 'Sell',
        button_rename: 'Rename',
        button_yes: 'Yes',
        button_no: 'No',
        button_cancel: 'Cancel',

        something_in_your_hand: 'Something is in my hand...',

        exit_text: '~b~[EXIT]',
        sell_text: '~g~[SELL]',
        food_text: `Food\n~o~${ReplaceStr} / ${ReplaceStr} kg.`,
        water_text: `Water\n~b~${ReplaceStr} / ${ReplaceStr} l.`,
        watertip_text: 'Water tip',
        watertip_filling_text: 'Water tip\n(Filling)',
        composter_text: `~y~Composter\n${ReplaceStr} / ${ReplaceStr} l.`,

        animal_dead_notification: 'This animal is dead!',

        nui_upgrades: 'Upgrades',
        nui_animals: 'Animals',

        composter_sell: 'Sell',
        composter_sold_things: `You sold the contains of the composter for $${ReplaceStr}!`
    },
    format(msg: string, args: (string | number)[]) {
        try {
            let message = msg;
            for (let i = 0; i < args.length; i++) {
                message = message.replace(ReplaceStr, args[i].toString());
            }
            return message;
        } catch {
            return 'UNKNOWN_TRANSLATION';
        }
    }
    
};