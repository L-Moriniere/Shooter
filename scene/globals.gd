extends Node

#HUD
var mob_hit = 0
var round_count = 1
var mob_count = 0
var mob_count_last_round
var mob_per_round = 1
var is_game_over = false
var score = 0
var is_round_finished : bool = false

#Player
var player_speed = 350
var lvl_power = 1
var fire_rate = 0.6
var number_weapon = 1
var label_fire_rate = 0
var label_speed = 0
var health = 2


#Mobs
var round_boss_base = 4
var round_boss_spawn = randi_range(round_boss_base,round_boss_base+4)
var speed_tie_fighter = 100
var speed_tie_interceptor = 50
var fire_rate_tie = 3
var is_boss_defeated = false

