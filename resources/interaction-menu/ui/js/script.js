var emoteOptions = ["Cancel", "Cop", "Sit", "Cross Arms", "Kneel", "CPR", "Notepad","Traffic", "Photo","Clipboard", "Lean", "Hangout", "Pot", "Phone", "Damn", "Yoga", "Cheer", "Statue", "Jog",
"Flex", "Sit up", "Push up", "Peace", "Mechanic", "Smoke 1", "Smoke 2", "Drink", "Gang 1", "Gang 2", "Prone", "Weld", "Bum 1", "Bum 2", "Bum 3", "Drill", "Blower", "Chillin'", "Mobile Film", "Planting", "Golf", "Hammer", "Clean", "Musician", "Party", "Prostitute", "High Five", "Wave", "Hug", "Fist bump", "Salute", "Dance 1", "Dance 2", "Dance 3", "Dance 4", "Dance 5", "Shag 1", "Shag 2", "Shag 3",
"Whatup", "Kiss", "Handshake", "Surrender", "Aim", "Fail", "No", "Palm", "Finger"];

const DEFAULT_ITEM_IMAGE = "https://i.imgur.com/JlvKMeQ.png";

var itemImages = {
  "Driver's License": "https://i.imgur.com/dy0SpFh.png",
  "Firearm Permit": "https://www.scientific.net/KEM.773.56/preview.gif",
  "Cell Phone": "https://i.dlpng.com/static/png/1350388_thumb.png",
  "Tuna Sandwich": "http://www.nunnbettercatering.com/wp-content/uploads/2016/05/tunasandwich3-300x300.png",
  "Chocolate Pizza": "https://imgur.com/jbx6mcI.png",
  "Cheeseburger": "https://ya-webdesign.com/images/cheese-burger-png-8.png",
  "Kosher Hot Dog": "http://clipart-library.com/image_gallery2/Hot-Dog-PNG-Clipart.png",
  "Microwave Burrito": "http://pluspng.com/img-png/bean-burrito-png-i-ordered-a-beef-and-bean-burrito-for-my-daughter-it-felt-pretty-light-610.png",
  "Peanut Butter Cups": "https://i.imgur.com/wuMmBIL.png",
  "Donut": "http://25.media.tumblr.com/92c54f13df54b2440f7f5782c4504e99/tumblr_mg3rni4xx81qhy9dqo1_400.png",
  "Taco": "http://www.stickpng.com/assets/thumbs/58727fb4f3a71010b5e8ef08.png",
  "Nachos": "https://newvitruvian.com/images/nachos-transparent-big-1.png",
  "Sea Salt & Vinegar Chips": "https://i.imgur.com/Wk2tecx.png",
  "Cheetos": "https://imgur.com/nJxPlfa.png",
  "Doritos": "https://ui-ex.com/images/doritos-transparent-3.png",
  "Water": "https://www.freepngimg.com/thumb/water_bottle/5-2-water-bottle-transparent.png",
  "Arizona Iced Tea": "https://coconutbreezecuisine.com/wr/img-wmedia/img-Bvg_AWatermelon.png",
  "Gatorade": "https://www.pngkit.com/png/full/115-1153791_gatorade-transparent-32-ounce-clip-transparent-library-32.png",
  "Caramel Iced Coffee": "https://i.pinimg.com/originals/6e/59/7a/6e597aeb09c6604cf5eb99e6c5472ba3.png",
  "Mocha Iced Coffee": "https://i.pinimg.com/originals/6e/59/7a/6e597aeb09c6604cf5eb99e6c5472ba3.png",
  "Slurpee": "https://www.7-eleven.com/sites/default/files/2017-03/Red.png",
  "Pepsi": "https://www.freepngimg.com/thumb/pepsi/3-2-pepsi-transparent.png",
  "Dr. Pepper": "https://cdn.shopify.com/s/files/1/2597/8324/products/170200209-1-dr-pepper-carbonated-beverage-web.png?v=1524654127",
  "Grape Soda": "https://www.zevia.ca/sites/zevia.ca/files/2019-02/Canadian_BlackCherry_Can.png",
  "Monster Energy Drink": "https://www.drink-shop.ch/11055-large_default/monster-energy-lh-44-lewis-hamilton-500-ml-uk.jpg",
  "Four Loko (12%)": "https://az.crescentcrown.com/wp-content/uploads/sites/2/brands/Four-Loko-Watermelon-Brand_714.png",
  "Corona Light Beer (4%)": "https://www.mcquades.com/Images/Upload/Corona_Lt_Btl.png",
  "Jack Daniels Whiskey (40%)": "https://www.totalwine.com/media/sys_master/twmmedia/he0/hcb/10679197270046.png",
  "Everclear Vodka (90%)": "https://imgur.com/eCptoIY.png",
  "Repair Kit": "http://www.pngpix.com/wp-content/uploads/2016/10/PNGPIX-COM-Toolbox-PNG-Transparent-Image-1-500x535.png",
  "First Aid Kit": "https://i.imgur.com/q3GjQKH.png",
  "Large Scissors": "http://www.fiskars.ca/var/fiskars_amer/storage/images/frontpage/products/sewing-and-quilting/sewing-scissors/fabric-scissors/softgrip-r-razor-edge-scissors-8/14794-3-eng-US/Softgrip-R-Razor-edge-Scissors-8_product_main_large.png",
  "Shovel": "http://www.transparentpng.com/thumb/shovel/CTaQzl-shovel-transparent-picture.png",
  "Sturdy Rope": "https://www.rpgstash.com/4597-product_page/sturdy-twine-x-100-fortnite.jpg?timestamp=1548931403",
  "Bag": "https://www.fastprinting.com.au/wp-content/uploads/Shopping-Bag.png",
  "Condoms": "https://i.dlpng.com/static/png/319596_thumb.png",
  "KY Intense Gel": "http://www.trojanbrands.com/-/media/Trojan/Products/Lubricants/Arouses_Intensifies-Box_Frnt.png?h=540&la=en&w=349&hash=3897CCA59E69F2FB5A1FD60F93FFAB810E72A7FD",
  "Viagra": "https://imgur.com/XmpRKyX.png",
  "Tent": "http://www.stickpng.com/assets/thumbs/5a62107deace967f8e026a25.png",
  "Wood": "https://ya-webdesign.com/images/logs-clipart-chopped-wood-19.png",
  "Chair": "http://www.stickpng.com/assets/thumbs/580b57fcd9996e24bc43c26b.png",
  "Vortex Optics Binoculars": "https://cdn.shopify.com/s/files/1/0785/3853/products/bup291.png?v=1510698821",
  "Flashlight": "https://i.dlpng.com/static/png/86976_thumb.png",
  "Hammer": "https://i.imgur.com/Eov8V1h.png",
  "Knife": "https://www.pngarts.com/files/3/Kitchen-Knife-Transparent-Background-PNG.png",
  "Bat": "https://www.pngarts.com/files/3/Baseball-Bat-Download-Transparent-PNG-Image.png",
  "Crowbar": "http://assets.stickpng.com/thumbs/58b8364015d8273a5cab2f7b.png",
  "Hatchet": "https://i.ibb.co/7R0MYwX/hatchet.png",
  "Wrench": "https://imgur.com/C0pRAo5.png",
  "Machete": "https://i.imgur.com/bMxYq8T.png",
  "Pistol": "https://steamuserimages-a.akamaihd.net/ugc/29613457985625199/0D5453A0ADC32EDBADEACF8D5CBE1EF129FCA5DC/",
  "Heavy Pistol": "https://vignette.wikia.nocookie.net/saintsrow/images/9/9c/SRIV_Pistols_-_Heavy_Pistol_-_.45_Fletcher_-_Default.png/revision/latest/scale-to-width-down/350?cb=20131028193410",
  ".50 Caliber": "https://i.imgur.com/W9sFoxi.png",
  "SNS Pistol": "https://vignette.wikia.nocookie.net/gtawiki/images/f/f5/SNSPistol-GTAV-SocialClub.png/revision/latest/scale-to-width-down/185?cb=20180202170333",
  "Combat Pistol": "https://vignette.wikia.nocookie.net/the-gta-online/images/4/4e/CombatPistol-GTA5-ingame.png/revision/latest?cb=20150519181654",
  "Revolver": "https://upload.wikimedia.org/wikipedia/commons/7/77/Taurus_Raging_Bull.png",
  "MK2": "https://i.pinimg.com/originals/3e/5b/09/3e5b09796cb124639c5f2232e5f32d9b.png",
  "Vintage Pistol": "https://i.pinimg.com/originals/3e/5b/09/3e5b09796cb124639c5f2232e5f32d9b.png",
  "Marksman Pistol": "http://img3.wikia.nocookie.net/__cb20100502124008/gtawiki/images/d/de/Pistol.44-TBOGT.png",
  "Pump Shotgun": "https://steamuserimages-a.akamaihd.net/ugc/29613457985659003/1B48193086C05B7FB56FA9770E2507492F47B6DF/",
  "Bullpup Shotgun": "https://steamuserimages-a.akamaihd.net/ugc/29613457985658075/DE3DC076CD63090D340BC133DDA9460E388E8A73/",
  "Musket": "https://www.gtabase.com/images/gta-5/weapons/shotguns/musket.png",
  "Firework Gun": "https://www.gtabase.com/images/gta-5/weapons/heavy/firework-launcher.png",
  "Parachute": "https://vignette.wikia.nocookie.net/gtawiki/images/f/f5/Parachute-GTAV.png/revision/latest?cb=20140515064734",
  "Toe Tag": "https://assets.bigcartel.com/product_images/119020083/toe-tag.png?auto=format&fit=max&h=1000&w=1000",
  "Trout": "http://www.stickpng.com/assets/images/580b57fbd9996e24bc43bbf9.png",
  "Flounder": "https://www.freshfromflorida.com/var/ezdemo_site/storage/images/media/images/marketing-development-images/flounder-transparent/2389314-1-eng-US/flounder-transparent_large.png",
  "Halibut": "https://i.dlpng.com/static/png/332762_thumb.png",
  "Yellowfin Tuna" : "https://imgur.com/JQmcQLV.png",
  "Swordfish" : "https://imgur.com/7718g2G.png",
  "Weed Bud": "https://66.media.tumblr.com/30ff99a59894fdd9abd04712189708af/tumblr_mvyvwdxNVi1t04rb2o1_r1_400.png",
  "Packaged Weed": "https://imgur.com/QnjBptr.png",
  "Processed Sand": "https://imgur.com/GQ8TPYU.png",
  "Lagunitas IPA": "https://www.totalwine.com/media/sys_master/twmmedia/h0a/h36/8804310974494.png",
  "Budweiser": "http://dbertolineandsons.com/wp-content/uploads/2016/08/budweiser-8-200x390.png",
  "Miller Lite": "https://www.liquormarts.ca/sites/mlcc_public_website/files/styles/product_fullsize/public/product/24367_383cd34522f3613dc452921121a3d00c.png?itok=txEs6zi-",
  "Grapefruit Sculpin": "https://halftimebeverage.com/media/catalog/product/cache/6b1c09900b407c50fce2db5e66ebc123/13037.png",
  "Blue Moon": "https://decrescente.net/images/suppliers/millercoors/blue-moon/blue-moon-belgian-white/belgian-white-bottle-lg.png",
  "Modelo Especial": "http://www.treuhouse.com/wp-content/uploads/2013/06/Modelo_Especial.png",
  "Jack & Coke":"http://www.haveacocktail.com/images/da/4197.jpg",
  "Grey Goose Vodka": "https://www.totalwine.com/media/sys_master/twmmedia/h29/h37/9977682231326.png",
  "Sonoma-Cutrer Chardonnay": "https://cdn.shopify.com/s/files/1/1580/4729/products/8813678362654.png?v=1501205503",
  "Oyster Bay Sauvignon Blanc": "https://www.totalwine.com/media/sys_master/twmmedia/hed/hd6/11385158762526.png",
  "Meiomi Pinot Noir": "https://www.totalwine.com/media/sys_master/twmmedia/h1b/h49/11343134654494.png",
  "El Pepino": "https://images.cocktailflow.com/v1/cocktail/w_300,h_540/cocktail_city_slicker-1.png",
  "Fresh Watermelon Margarita": "https://images.cocktailflow.com/v1/cocktail/w_300,h_540/cocktail_champagne_cocktail-1.png",
  "Gentlemans Old Fashioned": "https://res.cloudinary.com/hjqklbxsu/image/upload/f_auto,fl_lossy,q_auto/v1537152401/recipe/recipe/JDSB_OldFashioned_FullSize_0.png",
  "Classic Smash": "https://res.cloudinary.com/hjqklbxsu/image/upload/f_auto,fl_lossy,q_auto/v1539032291/product/bottle/d/GJ_Sour_406_x_550px.png",
  "Cucumber Watermelon": "https://www.realingredients.com/wp-content/uploads/sites/2/2017/11/watermeloncucumberpunch.png",
  "Voodoo": "https://vignette.wikia.nocookie.net/cocktails/images/b/b2/Voodoo.gif/revision/latest?cb=20110211232733",
  "Mi Casa Es Su Casa": "https://d32miag6ta013h.cloudfront.net/master_cocktails/2729/en-gl/small/cuatro-mismo_sml_580x820.png",
  "Back Porch Strawberry Lemonade": "https://polarice.ca/wp-content/uploads/2015/06/polar-ice-vodka-recipes-lychee-lemonade-mobile.png",
  "Fried Dill Pickles": "https://www.pngkey.com/png/full/72-726901_deep-fried-pickles-mccain-anchor-breaded-dill-pickle.png",
  "Onion Straws": "http://cafecitonj.com/images/menu/bites/onionrings.png",
  "Bacon Mac N Cheese": "http://www.kraftcanada.com/~/media/Kraft%20Canada/brands/images/craves/Carousel1_baconMac-m.png",
  "Pulled Pork Queso Dip": "https://www.haciendafiesta.com/images/galleries/dips/white-queso.png",
  "Artichoke Spinach Dip": "https://natureshealthygourmet.com/wp-content/plugins/dopts/uploads/thumbs/SH1dTyFGedH5nWdTSp23ZyMhLrESwLbKWeGXrzfaanxtSA3ahewBbtC3dbSR9r3h8.png",
  "Chicken Wings": "https://www.woodyswinghouse.com/wp-content/uploads/2017/07/chicken-wings-edit.png",
  "All American Hamburger": "https://ya-webdesign.com/images/cheese-burger-png-8.png",
  "Chopped Salad": "https://imgur.com/DywE0Z1.png",
  "Pizza": "https://www.happyspizza.com/wp-content/uploads/hp_plate_sm_2toppizza.png",
  "Chicken Sandwich": "https://brownbagonline.com/wp-content/uploads/2016/03/ChipotleChicken.png",
  "Ahi Tuna Sandwich": "https://russoscafe.com/wp-content/uploads/California-Tuna-Salad-Roll.png",
  "French Dip Au Jus": "http://wafflesatnoon.com/wp-content/uploads/2013/01/FrnchDip.png",
  "Boat License": "https://www.scientific.net/KEM.773.56/preview.gif",
  "Aircraft License": "https://www.scientific.net/KEM.773.56/preview.gif",
  "Bar Certificate": "https://www.scientific.net/KEM.773.56/preview.gif",
  "Key": "https://imgur.com/HOhkwYB.png",
  "Champagne (12.5%)": "https://www.wineconnection.com.sg//media/catalog/product/c/h/ch31_3.png",
  "Lockpick": "https://lansky.com/files/2015/4593/1583/LMT100B.png",
  "Molotov": "https://vignette.wikia.nocookie.net/left4dead/images/e/ea/Molotov-1.png/revision/latest?cb=20140322002700",
  "Thermite": "https://i.imgur.com/9OsEhuK.png",
  "Stolen Goods": "https://i.imgur.com/Yi5ZmwE.png",
  "Brass Knuckles": "https://i.pinimg.com/originals/5b/b6/84/5bb684cd2beb5e318fe3933262121c32.png",
  "Dagger": "http://www.pngmart.com/files/8/Dagger-PNG-Free-Download.png",
  "Switchblade": "https://vignette.wikia.nocookie.net/gtawiki/images/f/fc/Switchblade-GTAV.png/revision/latest?cb=20161021210105",
  "AP Pistol": "https://i.pinimg.com/originals/3e/5b/09/3e5b09796cb124639c5f2232e5f32d9b.png",
  "Sawn-off": "https://steamcommunity-a.akamaihd.net/economy/image/-9a81dlWLwJ2UUGcVs_nsVtzdOEdtWwKGZZLQHTxDZ7I56KU0Zwwo4NUX4oFJZEHLbXH5ApeO4YmlhxYQknCRvCo04DEVlxkKgpopbuyLgNv1fX3cDx96t2ykb-GkuP1P7fYlVRd4cJ5ntbN9J7yjRq1qkRoYmHxJICcdwVrNVyC_Va-xrq718W0uZSbm3M26Cdws3mOlkTln1gSOcynOW1P/360fx360f",
  "Micro SMG": "https://www.gtagaming.com/images/10490/1317045779_micro_uzi_t_lad.png",
  "SMG": "https://img.gta5-mods.com/q75/images/assault-smg-new-sound-effects/b5ff68-AssaultSMG-GTAV.png",
  "Machine Pistol": "https://i.pinimg.com/originals/19/38/54/193854f15e38f4e13174e815c92de4e4.png",
  "Tommy Gun": "https://www.gtabase.com/images/gta-5/weapons/machine-guns/gusenberg-sweeper.png",
  "AK47": "http://www.transparentpng.com/thumb/ak-47/icon-clipart-ak-47-12.png",
  "Carbine": "http://www.gaksharpshooters.com/images/ar15.gif",
  "Bullpup Rifle": "https://gaming.newbcomputerbuild.com/wp-content/uploads/2015/09/Bullpup-Rifle-GTA-V-300x111.png",
  "Curly Fries": "https://herfybd.com/assets/image/curly_fries.png",
  "Nightstick": "https://officialpsds.com/imageview/rq/9m/rq9m5w_large.png?1521316473",
  "Stun Gun": "https://www.gtabase.com/images/gta-5/weapons/handguns/stun-gun.png",
  "Uncut Cocaine": "https://i.imgur.com/hbQzCgC.png",
  "Packaged Cocaine": "https://pngimage.net/wp-content/uploads/2018/05/drug-bag-png-4.png",
  "Pseudoephedrine": "http://38.media.tumblr.com/25a96472f57c74e6a91afa6c56e9aa2b/tumblr_n1oqykqHpr1sp5w7co1_500.png",
  "Red Phosphorus": "https://imgur.com/J3uFUB7.png",
  "Fluffy Handcuffs": "https://i.imgur.com/O5KqMZV.png",
  "Razor Blade": "https://i.imgur.com/QAaLE3J.png",
  "Flaming Hot Cheetos": "https://i.imgur.com/EYQAFrx.png",
  "Packaged Blue Meth": "https://i.imgur.com/eAtLdlS.png",
  "Blue Meth Rock": "https://i.imgur.com/pyAj35G.png",
  "Packaged Meth": "https://i.imgur.com/31nlzQE.png",
  "Meth Rock": "https://i.imgur.com/AOveEbU.png",
  "Hotwiring Kit": "https://assets.fellowes.com/images/products/zoom/49106.png",
  "Vibrator": "http://images.hktvmall.com/h0966011/100638/h0966011_svakomadonis001_170606015542_01_1200.png",
  "Used Condoms": "https://officialpsds.com/imageview/r8/26/r826yr_large.png?1521316450",
  "Ludde's Lube": "https://www.pngfind.com/pngs/m/204-2045538_rated-squirt-lube-png-transparent-png.png",
  "Chicken": "https://i1.wp.com/freepngimages.com/wp-content/uploads/2016/11/chicken-transparent-background.png?fit=457%2C750",
  "Chicken carcass": "https://img.pngio.com/dead-chicken-tyranachupng-dead-chicken-png-939_939.png",
  "Featherless chicken carcass": "https://cdn.shopify.com/s/files/1/2554/4616/t/5/assets/Image-47_299x.png?16156401367434920007",
  "Raw chicken meat": "https://www.pattonsbargainbutcher.com.au/uploads/3/0/1/3/30136237/4385440.png?376",
  "MK2 Carbine Rifle": "https://www.gtabase.com/images/gta-5/weapons/assault-rifles/carbine-rifle-mk2.png",
  "MK2 Pump Shotgun": "https://www.gtabase.com/images/gta-5/weapons/shotguns/pump-shotgun-mk2.png",
  "Body Armor": "https://i.imgur.com/oHsLkWD.png",
  "Police Armor": "https://i.imgur.com/oHsLkWD.png",
  "Tear Gas": "https://i.imgur.com/v9b6bNm.png",
  "Flare": "https://i.imgur.com/gMOnw6x.png",
  "The Daily Weazel": "https://i.imgur.com/Pg6TODN.png",
  "Fire Extinguisher": "https://i.imgur.com/7avLEgk.png",
  "Marksman Rifle": "https://i.imgur.com/aFlRlSb.png",
  "Raw Sand": "https://i.imgur.com/Z19qckK.png",
  "Jerry Can": "https://i.imgur.com/Izo2ego.png",
  "Root Beer": "https://imgur.com/EynrcEX.png",
  "Coca Cola": "https://imgur.com/n7ciMKF.png",
  "Diet Cola": "https://imgur.com/RM0xZpN.png",
  "Peach Fanta": "https://imgur.com/gQc2DGm.png",
  "Pineapple Fanta": "https://imgur.com/EwUNSgR.png",
  "Fiji Water": "https://imgur.com/taRRZd1.png",
  "Value Water": "https://imgur.com/gVAYNfG.png",
  "Verana Blend Hot Coffee": "https://imgur.com/WVkbOa4.png",
  "Vanilla Iced Coffee": "https://imgur.com/115QUbe.png",
  "Original Iced Coffee": "https://imgur.com/115QUbe.png",
  "Redbull Energy Drink": "https://imgur.com/ydttLBB.png",
  "Rockstar Energy Drink": "https://imgur.com/mb2EFV8.png",
  "Funyuns": "https://i.imgur.com/0DVO49N.png",
  "Cool Ranch Doritos": "https://i.imgur.com/7zwiCP5.png",
  "Gummy Worms": "https://i.imgur.com/CjOhIJF.png",
  "Sour Gummy Worms": "https://i.imgur.com/AiSyyCw.png",
  "LSD Vial": "https://imgur.com/4zNSw5c.png",
  "RAW Papers": "https://imgur.com/BHm4hHf.png",
  "Bic Lighter": "https://imgur.com/sVSnmCy.png",
  "Joint": "https://imgur.com/NBVdIqF.png",
  "Watering Can": "https://imgur.com/GC5yvkj.png",
  "Fertilizer": "https://imgur.com/uyRhO93.png",
  "Small Weed Plant": "https://imgur.com/5dRRvsl.png",
  "Animal Fur": "https://imgur.com/SURTdtd.png",
  "Butchered Meat": "https://imgur.com/hkb5zK4.png",
  "Big Whopper": "https://imgur.com/kbekBig.png",
  "Foot Long Dog": "https://imgur.com/f6gTkeW.png",
  "Doughnuts": "https://imgur.com/iyQg2J4.png",
  "Fries": "https://imgur.com/VepJLUO.png",
  "Chicken Nuggets": "https://imgur.com/GT5V0pq.png",
  "Fried Chicken Burger": "https://imgur.com/rDtXz3S.png",
  "Smoothie Special": "https://imgur.com/YJnRI47.png",
  "Orange Fanta": "https://imgur.com/Fr3Px9r.png",
  "Pepsi": "https://imgur.com/fHUPIqp.png",
  "Dr Pepper": "https://imgur.com/JNCWDcR.png",
  "Veggie Gasm Burger" : "https://imgur.com/pzwQmmQ.png",
  "Torpedo Sandwich" : "https://imgur.com/fqnd3wJ.png",
  "Fishing Pole": "https://i.imgur.com/FPgsx97.png",
  "Sam Smith's Strapon": "https://i.imgur.com/cQjjGVg.png",
  "Advanced Pick" : "https://i.imgur.com/86KdWw0.png",
  "Cooked Meat": "https://i.imgur.com/5pd8czn.png",
  "Drill": "https://i.imgur.com/7lMxrcm.png",
  "Gold": "https://i.imgur.com/QYthPRN.png",
  "Diamond": "https://i.imgur.com/F1arH11.png",
  "Aluminum": "https://i.imgur.com/FAhri6J.png",
  "Copper": "https://i.imgur.com/7sC2n9I.png",
  "Iron": "https://i.imgur.com/362wJPk.png",
  "Pick Axe": "https://i.imgur.com/fEmIfhj.png",
  "Ceramic Tubing": "https://i.imgur.com/Fg1pZNH.png",
  "Aluminum Powder": "https://i.imgur.com/FcoUYM4.png",
  "Iron Oxide": "https://i.imgur.com/pBhnwQl.png",
  "Vape": "https://i.imgur.com/d8BS61Q.png",
  "Black Powder": "https://i.imgur.com/Zct2dcM.png",
  "Large Firework": "https://i.imgur.com/XHhxRmG.png",
  "Spike Strips": "https://i.imgur.com/0iPbmxW.png",
  "Heavy Shotgun": "https://i.imgur.com/JRP4gPv.png",
  "SMG MK2": "https://i.imgur.com/sN9udjW.png",
  "Radio": "https://i.imgur.com/FUreKPT.png",
  "Police Radio": "https://i.imgur.com/0ve01NN.png",
  "EMS Radio": "https://i.imgur.com/0ve01NN.png",
  "Compact Rifle": "https://i.imgur.com/38RjuhX.png"
}

var menuItems = [
  {
    name: "Actions",
    children: [
      { name: "Show ID" },
      { name: "Give cash" },
      { name: "Bank" },
      { name: "Phone number" },
      { name: "Glasses" },
      { name: "Mask" },
      { name: "Hat" },
      { name: "Tie" },
      { name: "Untie" },
      { name: "Drag" },
      { name: "Blindfold" },
      { name: "Remove blindfold" },
      { name: "Place" },
      { name: "Unseat" },
      { name: "Rob" },
      { name: "Search" },
      { name: "Roll dice" },
      { name: "Walkstyle" }
    ]
  },
  {
    name: "Inventory" // will get it's own UI
  },
	{
    name: "Emotes" // children built below
  },
	{
    name: "VOIP",
    children: [
      { name: "Yell" },
      { name: "Normal" },
			{ name: "Whisper" }
    ]
  }
];

/* build list of emotes */
var temp = [];
for (var i = 0; i < menuItems.length; i++) {
  if (menuItems[i].name == "Emotes") {
    for (var k = 0; k < emoteOptions.length; k++) {
      var child = { name: emoteOptions[k]};
      temp.push(child);
    }
    menuItems[i].children = temp;
    break;
  }
}

var vehicleActions = [
  { name: "Roll Windows"},
  { name: "Engine", children: [
    { name: "On" },
    { name: "Off" }
  ]},
  { name: "Open", children: [
    { name: "Hood" },
    { name: "Front Left" },
    { name: "Back Left" },
    { name: "Front Right" },
    { name: "Back Right" },
    { name: "Trunk" },
  ]},
  { name: "Close", children: [
    { name: "Hood" },
    { name: "Front Left" },
    { name: "Back Left" },
    { name: "Front Right" },
    { name: "Back Right" },
    { name: "Trunk" },
  ]},
  { name: "Shuffle" },
  { name: "Brakelights" }
];

/* Helps navigate backwards when going into multiple submenus (stack) */
var navigationHistory = [{ name: "Home", children: menuItems }];

var interactionMenu = new Vue({
  el: "#app",
  data: {
    menuItems: menuItems,
    currentPage: "Home",
    currentSubmenuItems: [],
    targetVehiclePlate: null,
    showSecondaryInventory: false,
    inputBox: {
      show: false,
      value: null
    },
    inventory: {
      MAX_CAPACITY: 25,
      items: {}
    },
    vehicleInventory: {
      MAX_ITEMS: 25,
      MAX_CAPACITY: 0.0,
      items: {}
    },
    isInsideVehicle: false,
    isCuffed: false,
    contextMenu: {
      showContextMenu: false,
      top: 0,
      left: 0,
      clickedInventoryIndex: 0,
      openMenu: function(clickedInventoryIndex) {
        /* Show context menu */
        this.showContextMenu = true
        /* Open next to mouse: */
        this.top = event.y;
        this.left = event.x;
        /* Saved clicked inventory index */
        this.clickedInventoryIndex = clickedInventoryIndex;
      }
    },
    nearestPlayer: {
      id: 0, // 0 if nobody near
      name: "no one"
    },
    dropHelper: {
      originIndex: null,
      targetIndex: null,
      fromType: null,
      toType: null
    },
    locked: null, // to be moved into vehicleInventory property (since it pertains to veh inv)
    profiler: {
      startTime: null
    }
  },
  methods: {
    onClick: function(item) {
      /* Navigate to page if submenu */
      if (item.children) {
        this.currentSubmenuItems = item.children;
        this.currentPage = item.name;
        navigationHistory.push(item);
      /* Perform action if not submenu */
      } else {
        switch (item.name) {
          case "Inventory": {
            /* load inventory items */
            $.post('http://interaction-menu/loadInventory', JSON.stringify({}));
            /* Toggle veh inv */
            if (this.targetVehiclePlate) {
              $.post("http://interaction-menu/loadVehicleInventory", JSON.stringify({
                plate: this.targetVehiclePlate
              }));
            }
            /* Set page */
            this.currentPage = "Inventory";
            break;
          }
        }
      }
    },
    onSubmenuItemClick: function(item) {
      switch(this.currentPage) {
        case "Actions": {
          $.post('http://interaction-menu/performAction', JSON.stringify({
            action: item.name,
            isVehicleAction: false
          }));
          break;
        }
        case "Emotes": {
          if (!this.isInVehicle) {
            $.post('http://interaction-menu/playEmote', JSON.stringify({
              emoteName: item.name
            }));
          } else {
            $.post('http://interaction-menu/notification', JSON.stringify({
              msg: "Can't use emotes when in a vehicle!"
            }));
          }
          break;
        }
        case "VOIP": {
          $.post('http://interaction-menu/setVoipLevel', JSON.stringify({
            level: item.name
          }));
          break;
        }
        case "Vehicle Actions": {
          /* Navigate into submenu */
          if (item.children) {
            this.currentSubmenuItems = item.children;
            navigationHistory.push(item);
            return; // don't close menu
          /* No more submenus, perform action */
          } else {
            var parentMenu = navigationHistory[navigationHistory.length - 1];
            $.post('http://interaction-menu/performAction', JSON.stringify({
              action: item.name,
              isVehicleAction: true,
              parentMenu: parentMenu.name // helps index into Lua table of vehicle actions
            }));
          }
          break;
        }
      }
      /* Close Menu after click */
      CloseMenu();
    },
    showVehicleActions: function() {
      this.currentSubmenuItems = vehicleActions;
      this.currentPage = "Vehicle Actions";
      navigationHistory.push({ name: "Vehicle Actions", children: vehicleActions });
    },
    contextMenuClicked: function(event, action) {
      var index = this.contextMenu.clickedInventoryIndex;
      var item = this.inventory.items[index];
      /* Perform Action */
      if (action == "Drop") {
        /* Perform Action */
        $.post('http://interaction-menu/dropItem', JSON.stringify({
          index: index,
          itemName: item.name,
          objectModel: item.objectModel
        }));
      } else {
        $.post('http://interaction-menu/inventoryActionItemClicked', JSON.stringify({
          index: index,
          wholeItem: item,
          itemName: item.name,
          actionName: action.toLowerCase(),
          playerId: interactionMenu.nearestPlayer.id
        }));
      }
      /* Close context menu */
      CloseMenu();
    },
    back: function() {
      if (navigationHistory[navigationHistory.length - 1].name !== "Home") {
        navigationHistory.pop();
        this.currentPage = navigationHistory[navigationHistory.length - 1].name;
        this.currentSubmenuItems = navigationHistory[navigationHistory.length - 1].children;
      }
    },
    closeMenu: function() {
      CloseMenu();
    },
    continueInventoryMove: function(doInputCheck) {
      /* Hide input */
      this.inputBox.show = false;
      if (doInputCheck) {
        /* Make input quantity valid */
        if (this.inputBox.value <= 0) {
          this.inputBox.value = 0;
          return;
        }
        else if (this.dropHelper.fromType == "primary" && this.inputBox.value > this.inventory.items[this.dropHelper.originIndex].quantity)
          this.inputBox.value = this.inventory.items[this.dropHelper.originIndex].quantity;
        else if (this.dropHelper.fromType == "secondary" && this.inputBox.value > this.vehicleInventory.items[this.dropHelper.originIndex].quantity)
          this.inputBox.value = this.vehicleInventory.items[this.dropHelper.originIndex].quantity;
      }
      /* Update player */
      $.post('http://interaction-menu/moveItem', JSON.stringify({
        fromSlot: parseInt(this.dropHelper.originIndex),
        toSlot: parseInt(this.dropHelper.targetIndex),
        fromType: this.dropHelper.fromType,
        toType: this.dropHelper.toType,
        quantity: this.inputBox.value,
        plate: this.targetVehiclePlate
      }));
      /* Reset quantity input box value */
      this.inputBox.value = 1;
      //console.log("Took: " + (performance.now() - this.profiler.startTime) + "ms to run");
    },
    isItemIllegal: function(item) {
      if (item.legality) {
        if (item.legality == "illegal")
          return true;
        else
          return false;
      } else {
        return false;
      }
    },
    getItemImage: function(name) {
      if (name.includes("Cell Phone")) {
        return itemImages["Cell Phone"];
      } else if (name.includes("Key")) {
        return itemImages["Key"];
      } else if (itemImages[name]) {
        return itemImages[name];
      } else {
        return DEFAULT_ITEM_IMAGE;
      }
    }
  },
  computed: {
    inventoryWeight: function() {
      let weight = 0
      for (var index in this.inventory.items) {
        let item = this.inventory.items[index]
        weight += (item.weight * (item.quantity || 1) || 1.0)
      }
      return weight
    },
    vehicleInventoryWeight: function() {
      let weight = 0
      for (var index in this.vehicleInventory.items) {
        let item = this.vehicleInventory.items[index]
        weight += (item.weight * (item.quantity || 1) || 1.0)
      }
      return weight
    }
  },
  directives: { /* used for primary inventory items (see 'updated' for secondary inventory items)*/
    draggable: {
      bind: function(el, binding, vnode) {
        if ($(el).draggable("instance") == undefined)
          $(el).draggable({
            //revert: false,
            /*
            revert: function (socketObj) {
              if (socketObj === true) {
                // Drag success :)
                alert("Success!");
                return false;
              }
              else {
                // Drag fail :(
                alert("Reverting!");
                return true;
              }
            }
            */
            scroll: true,
            helper: "clone",
            start: function(event, ui) {
              //console.log("started dragging!");
            },
            stop: function(event, ui) {
              //console.log("stopped dragging!");
            }
          });
        //else
          //console.log("did not make draggable");
      }
    },
    droppable: {
      bind: function(el, binding, vnode) {
        var componentInstance = vnode.context;
        //console.log("instance: " + $(el).droppable("instance"));
        if ($(el).droppable("instance") == undefined)
          $(el).droppable({
          classes: {
            "ui-droppable-hover": "ui-item-hover"
          },
          drop: function(event, ui) {
            //componentInstance.profiler.startTime = performance.now();
            /* Origin/Target Inventory Indexes */
            var originIndex = $(ui.draggable).attr("id");
            var targetIndex = $(this).attr("id");

            /* Target/Destination Inventory Types */
            var fromType = $(ui.draggable).attr("data-inventory-type");
            var toType = $(this).attr("data-inventory-type");

            if (originIndex == targetIndex && fromType == toType)
              return;

            componentInstance.dropHelper.originIndex = originIndex;
            componentInstance.dropHelper.targetIndex = targetIndex;
            componentInstance.dropHelper.fromType = fromType;
            componentInstance.dropHelper.toType = toType;

            if (fromType != toType && ((fromType == "primary" && componentInstance.inventory.items[originIndex].quantity > 1) || fromType == "secondary" && componentInstance.vehicleInventory.items[originIndex].quantity > 1)) {
              /* Get user input for quantity to move */
              componentInstance.inputBox.show = true;
            } else {
              componentInstance.continueInventoryMove(false);
            }
          }
        });
      }
    }
  },
  updated: function() {
    //var t1 = performance.now();

    /* Resize item name text */
    jQuery(".inventory-item footer span").fitText(1.0, { minFontSize: '9px', maxFontSize: '40px' });

	  var app = this;
    $(".secondary-inv-slot").each(function(index) {
      if ($(this).droppable("instance") == undefined)
        $(this).droppable({
            classes: {
              "ui-droppable-hover": "ui-item-hover"
            },
            drop: function(event, ui) {

              //app.profiler.startTime = performance.now();

              /* Origin/Target Inventory Indexes */
              var originIndex = $(ui.draggable).attr("id");
              var targetIndex = $(this).attr("id");

              /* Target/Destination Inventory Types */
              var fromType = $(ui.draggable).attr("data-inventory-type");
              var toType = $(this).attr("data-inventory-type");

              if (originIndex == targetIndex && fromType == toType)
                return;

              app.dropHelper.originIndex = originIndex;
              app.dropHelper.targetIndex = targetIndex;
              app.dropHelper.fromType = fromType;
              app.dropHelper.toType = toType;

              if (fromType != toType && ((fromType == "primary" && app.inventory.items[originIndex].quantity > 1) || fromType == "secondary" && app.vehicleInventory.items[originIndex].quantity > 1)) {
                /* Get user input for quantity to move */
                app.inputBox.show = true;
              } else {
                app.continueInventoryMove(false);
              }
            }
          });
    });
    //$(".secondary-inv-slot").droppable("enable");

    /* prevent access to veh inv items of a locked vehicle unless inside it */
    //console.log("seeing if this.locked is undefined...");
    if (typeof this.locked != "undefined" && this.locked != null) {
      $(".secondary-inv-slot").css("filter", "none");
  		if (this.locked && !this.isInVehicle) {
  			$(".secondary-inv-slot").droppable("disable");
        $(".secondary-inv-slot").css("filter", "blur(5px)");
  		}
		  //console.log("# items in veh inv:" + $(".secondary-inv-item").size());
      if ($(".secondary-inv-item").size() > 0) {
        $(".secondary-inv-item").each(function(index) {
          if ($(this).draggable("instance") == undefined)
            $(this).draggable({
            //revert: false,
            /*
            revert: function (socketObj) {
              if (socketObj === true) {
                // Drag success :)
                alert("Success!");
                return false;
              }
              else {
                // Drag fail :(
                alert("Reverting!");
                return true;
              }
            }
            */
            scroll: true,
            helper: "clone",
            start: function(event, ui) {
              //console.log("started dragging veh item!");
            },
            stop: function(event, ui) {
              //console.log("stopped dragging veh item!");
            }
          });
        });
        //$(".secondary-inv-item").draggable("enable");
        if (this.locked && !this.isInVehicle) {
          $(".secondary-inv-item").draggable("disable");
        }
      }
    }

    //var t2 = performance.now();

    //console.log("took: " + (t2 - t1) + "ms to run");
  }
});

function CloseMenu() {
  document.body.style.display = "none";
  $.post('http://interaction-menu/escape', JSON.stringify({
    vehicle: {
      plate: interactionMenu.targetVehiclePlate
    }
  }));
  interactionMenu.currentPage = "Home";
  interactionMenu.currentSubmenuItems = [];
  interactionMenu.showSecondaryInventory = false;
  interactionMenu.contextMenu.showContextMenu = false;
  interactionMenu.inputBox.show = false;
  interactionMenu.locked = false;
  navigationHistory = [{ name: "Home", children: menuItems }];
  /* Clean up jQuery UI stuff! (causes mem leak if not cleaned up) */
  $(".draggable").draggable("destroy");
  $(".droppable").droppable("destroy");
  $(".secondary-inv-slot").droppable("destroy");
  $(".secondary-inv-item").draggable("destroy");
}

$(function() {
  /* To talk with LUA */
	window.addEventListener('message', function(event) {
		if (event.data.type == "enableui") {
      /* Display */
			document.body.style.display = event.data.enable ? "block" : "none";
      /* Set targetted / occupied in vehicle */
      if (event.data.target_vehicle_plate && typeof event.data.target_vehicle_plate !== "undefined")
        interactionMenu.targetVehiclePlate = event.data.target_vehicle_plate;
      else
        interactionMenu.targetVehiclePlate = null;
      /* Set nearest player */
      interactionMenu.nearestPlayer = event.data.nearestPlayer;
      if (!interactionMenu.nearestPlayer) {
        interactionMenu.nearestPlayer = {
          id: 0,
          name: "no one"
        }
      }
      /* Set misc variables from client */
      interactionMenu.isInVehicle = event.data.isInVehicle;
      interactionMenu.isCuffed = event.data.isCuffed;
		} else if (event.data.type == "inventoryLoaded") {
      interactionMenu.inventory = event.data.inventory;
      for (var i = 0; i < interactionMenu.inventory.MAX_CAPACITY; i++)
        if (interactionMenu.inventory.items[i] && !interactionMenu.inventory.items[i].image)
          interactionMenu.inventory.items[i].image = "http://icons.iconarchive.com/icons/pixelkit/tasty-bites/256/hamburger-icon.png";
		} else if (event.data.type == "vehicleInventoryLoaded") {
      /* null check */
      if (!event.data.inventory.items)
        event.data.inventory.items = {};
      /* set items */
      interactionMenu.vehicleInventory = event.data.inventory;
      /* prevent access to veh inv items of a locked vehicle unless inside it */
      if (event.data.locked) {
        interactionMenu.locked = event.data.locked;
      }
      /* Show secondary inventory (only show after locked status is set to prevent premature access to items when locked) */
      interactionMenu.showSecondaryInventory = true;
		} else if (event.data.type == "updateBothInventories") {
      interactionMenu.inventory = event.data.inventory.primary;
      interactionMenu.vehicleInventory = event.data.inventory.secondary;
    } else if (event.data.type == "updateNearestPlayer") {
      var nearest = event.data.nearest;
      if (nearest.name == "") {
        nearest = {
          id: 0,
          name: "no one"
        }
      }
      interactionMenu.nearestPlayer = nearest;
		}
	});
  /* Close Menu */
	document.onkeydown = function (data) {
		if (data.which == 27 || data.which == 77) { // Escape key or M
      CloseMenu();
		}
	};
});
